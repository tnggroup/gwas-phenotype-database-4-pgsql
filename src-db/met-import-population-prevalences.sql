CREATE OR REPLACE FUNCTION met.import_population_prevalences() RETURNS int AS $$
DECLARE
    nkey int = -1;
	crec RECORD;
	tempmessage varchar;
	nphenotype int;
	nancestry met.varcharcodesimple_lc;
	nreferencedoi varchar;
	nreference int;
	ndocumentation varchar;
BEGIN
	
	--Deal with missing phenotypes - show which to create manually
	CREATE TEMP TABLE IF NOT EXISTS missing ON COMMIT DROP AS
	SELECT DISTINCT trim(lower(popprev20210226.trait_code)) AS code
	FROM johan.popprev20210226 LEFT OUTER JOIN met.phenotype
	ON trim(lower(popprev20210226.trait_code))=phenotype.code WHERE phenotype.code IS NULL AND (phenotype.phenotype_type='dis' OR phenotype.phenotype_type='trt') ORDER BY code;
	
	IF EXISTS (SELECT 1 FROM missing)
	THEN
	tempmessage:=(SELECT string_agg(missing.code, ', ') FROM missing);
	RAISE NOTICE 'Phenotypes missing!';
	RAISE NOTICE '%',tempmessage;
	--RETURN QUERY SELECT * FROM missing;
	RETURN -1;
	END IF;
	
	FOR crec in (SELECT * FROM johan.popprev20210226 )
	LOOP
        RAISE NOTICE 'Processing: %', crec;
		
		SELECT phenotype.id INTO nphenotype FROM met.phenotype WHERE trim(lower(crec.trait_code))=phenotype.code AND phenotype.phenotype_type='dis';
		
		IF nphenotype IS NULL
		THEN
			SELECT phenotype.id INTO nphenotype FROM met.phenotype WHERE trim(lower(crec.trait_code))=phenotype.code AND phenotype.phenotype_type='trt';
		END IF;
		
		CASE crec.ancestory
			WHEN 'european','europe' THEN nancestry:='eur';
			ELSE nancestry:='multi';
		END CASE;
		
		nreferencedoi:= replace(lower(crec."DOI"),'https://doi.org/','');
		SELECT reference.id INTO nreference FROM met.reference WHERE reference.doi=nreferencedoi;
		IF nreference IS NULL
		THEN 
			INSERT INTO met.reference(doi,year) VALUES(nreferencedoi,2020) RETURNING id INTO nreference;
		END IF;
		
		ndocumentation:=''||crec.ancestory||','||crec.geographical_location||','||crec.age;
		IF ndocumentation IS NULL THEN ndocumentation:=''; END IF;
		
		INSERT INTO met.phenotype_population_prevalence(phenotype,ancestry_population,sex,country_reference,age_min,age_max,estimate,is_meta_analysis,needs_update,reference,documentation)
		VALUES(
			  nphenotype,
			  nancestry,
			  'unspecified',
			  NULL,
			  0,
			  99,
			   crec.population_prevalence,
			  crec.meta_analysis,
			  NOT crec.complete_info,
			  nreference,
			  ndocumentation);
		
    END LOOP;

	RETURN nkey;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = met, pg_temp; -- Set a secure search_path: trusted schema(s), then 'pg_temp'.
ALTER FUNCTION met.import_population_prevalences()
  OWNER TO "phenodb_metadata_editor";

--SELECT * FROM met.phenotype ORDER BY phenotype.name;

UPDATE johan.popprev20210226 SET trait_code='ocdi' WHERE popprev20210226.trait_code='OCD';
  
SELECT * FROM met.import_population_prevalences();