CREATE OR REPLACE FUNCTION met.import_population_prevalences() RETURNS int AS $$
DECLARE
    nkey int = 0;
	crec RECORD;
	tempmessage varchar;
BEGIN
	
	--Deal with missing phenotypes - show which to create manually
	CREATE TEMP TABLE IF NOT EXISTS missing ON COMMIT DROP AS
	SELECT DISTINCT trim(lower(popprev20210226.trait_code)) AS code 
	FROM johan.popprev20210226 INNER JOIN met.phenotype
	ON trim(lower(popprev20210226.trait_code))!=phenotype.code ORDER BY code;
	
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
    END LOOP;

	RETURN nkey;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = met, pg_temp; -- Set a secure search_path: trusted schema(s), then 'pg_temp'.
ALTER FUNCTION met.import_population_prevalences()
  OWNER TO "phenodb_metadata_editor";
  
  
SELECT * FROM met.import_population_prevalences()