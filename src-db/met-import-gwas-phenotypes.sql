--TRUNCATE TABLE met.phenotype_phenotype_category;
--TRUNCATE TABLE met.phenotype RESTART IDENTITY CASCADE;

CREATE OR REPLACE FUNCTION met.create_phenotype_ignoresert_old
(
	name character varying(100),
	code_suggestion_old character varying(100) DEFAULT NULL,
	nphenotype_type met.varcharcodesimple_lc DEFAULT 'trt',
	documentation character varying DEFAULT '',
	nid_gwasdb integer DEFAULT NULL,
	ncode_gwasdb met.varcharcodeletnum_lc DEFAULT NULL,
	reclevel integer DEFAULT 0
) RETURNS int AS $$
DECLARE
    nid int = -1;
	ncode met.varcharcodeletnum_lc;
	ncode2 character varying(100);
BEGIN
	
	IF code_suggestion_old IS NULL
	THEN 
		ncode:=name;
	ELSE
		ncode:=code_suggestion_old;
	END IF;
	
	ncode :=lower(ncode);
	ncode := regexp_replace(ncode,'[^a-z0-9]','','g'); --flag g specifies replacing all matches rather than the first
	
	if(reclevel>1)
	THEN
		ncode:=substring(ncode for (char_length(ncode)-char_length(''||reclevel)+1))||reclevel;
	else
		if(reclevel=1)
		then
			ncode2 :=lower(name);
			ncode2:=replace(ncode2,ncode,'');
			ncode2 := regexp_replace(ncode2,'[^a-z0-9]','','g');
			ncode2 := regexp_replace(ncode2,'[aoueiy]','','g');
			ncode:=ncode||ncode2;
		end if;
	END IF;
	
	if(char_length(ncode)>10)
	then
		ncode:=substring(ncode for 6)||substring(ncode from char_length(ncode)-4 for 4);
	end if;
	
	
	
	RAISE NOTICE 'ncode:%;', ncode;
	
	IF EXISTS (SELECT 1 FROM met.phenotype WHERE phenotype.code=ncode AND phenotype.phenotype_type=nphenotype_type)
	THEN
		nid:=met.create_phenotype_ignoresert(name,ncode,nphenotype_type,documentation,nid_gwasdb,ncode_gwasdb,(reclevel+1));
	ELSE
		--INSERT INTO met.phenotype(code,name,phenotype_type,documentation,id_gwasdb,code_gwasdb) VALUES(ncode,name,nphenotype_type,documentation,nid_gwasdb,ncode_gwasdb) ON CONFLICT DO NOTHING RETURNING id INTO nid;
		INSERT INTO met.phenotype(code,name,phenotype_type,documentation,id_gwasdb,code_gwasdb) VALUES(ncode,name,nphenotype_type,documentation,nid_gwasdb,ncode_gwasdb) RETURNING id INTO nid;
	END IF;
	
	RETURN nid;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = met, pg_temp;
ALTER FUNCTION met.create_phenotype_ignoresert(name character varying(100),
	code_suggestion_old character varying(100),
	nphenotype_type met.varcharcodesimple_lc,
	documentation character varying,
	nid_gwasdb integer,
	ncode_gwasdb met.varcharcodeletnum_lc,
	reclevel integer)
  OWNER TO "phenodb_metadata_editor";
  
--SELECT met.create_phenotype_upsert('ADHD symptoms','ADHD','trt','')

CREATE OR REPLACE FUNCTION met.import_gwas_phenotypes() RETURNS int AS $$
DECLARE
    nid int = -1;
	crec RECORD;
	nphenotype_type met.varcharcodesimple_lc;
BEGIN
	CREATE TEMP TABLE IF NOT EXISTS toimport ON COMMIT DROP AS
	SELECT DISTINCT lower(substring("GWAS".code for 4)) AS code, substring("GWAS".code for 4) AS old_phenotype_code, phenotype.name, phenotype.type, category.name AS category, category.id AS category_id, phenotype.id AS old_phenotype_id 
	FROM sumstat_old.phenotype 
	INNER JOIN sumstat_old."GWAS" ON "GWAS".phenotype_id=phenotype.id 
	LEFT OUTER JOIN sumstat_old.category ON phenotype.category_id=category.id 
	ORDER BY phenotype.type, old_phenotype_code, phenotype.name, old_phenotype_id ASC;


	FOR crec in (SELECT * FROM toimport )
	LOOP
		RAISE NOTICE 'Processing: %', crec;
		--IF crec.type = 'trait' THEN 
		nphenotype_type:='trt';
		IF crec.type = 'disorder' THEN nphenotype_type:='dis'; END IF;
		IF crec.type = 'biomarker' THEN nphenotype_type:='bio'; END IF;
		nid:=met.create_phenotype_ignoresert(crec.name,crec.old_phenotype_code,nphenotype_type,crec.name,crec.old_phenotype_id,crec.old_phenotype_code);
		RAISE NOTICE 'FOUND/INSERTED PHENOTYPE ID: %', nid;
		INSERT INTO met.phenotype_phenotype_category(phenotype,phenotype_category) VALUES(nid,crec.category_id) ON CONFLICT DO NOTHING;
		
	END LOOP;

	RETURN nid;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = met, pg_temp;
ALTER FUNCTION met.import_gwas_phenotypes()
  OWNER TO "phenodb_metadata_editor";
  
SELECT met.import_gwas_phenotypes();

SELECT * FROM met.phenotype;
