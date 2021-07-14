--TRUNCATE TABLE met.phenotype_phenotype_category;
--TRUNCATE TABLE met.phenotype RESTART IDENTITY CASCADE;

CREATE OR REPLACE FUNCTION met.create_phenotype_ignoresert
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