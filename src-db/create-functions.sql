--DROP FUNCTION met.get_phenotype;
CREATE OR REPLACE FUNCTION met.get_phenotype
(
	phenotype_type met.varcharcodeletnum_lc,
	phenotype_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT id INTO nid FROM met.phenotype WHERE phenotype_type=$1 AND code=$2;
	
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_phenotype(
	phenotype_type met.varcharcodeletnum_lc,
	phenotype_code met.varcharcodeletnum_lc)
  OWNER TO "phenodb_coworker";

--DROP FUNCTION met.get_cohort;
CREATE OR REPLACE FUNCTION met.get_cohort
(
	cohort_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT id INTO nid FROM met.cohort WHERE cohort.code=$1;
	
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_cohort(
	code met.varcharcodeletnum_lc)
  OWNER TO "phenodb_coworker";
 
--SELECT met.get_cohort('covidcns');

--DROP FUNCTION met.get_cohortinstance;
CREATE OR REPLACE FUNCTION met.get_cohortinstance
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT cohortinstance.id INTO nid FROM met.cohortinstance, met.cohort WHERE cohort.code=$1 AND cohortinstance.code=$2 
		and cohortinstance.cohort=cohort.id;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_cohortinstance(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc)
  OWNER TO "phenodb_coworker";
 
--SELECT met.get_cohortinstance('covidcns','2021');

--DROP FUNCTION met.get_cohortstage;
CREATE OR REPLACE FUNCTION met.get_cohortstage
(
	cohort_code met.varcharcodeletnum_lc,
	stage_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT cohortstage.id INTO nid FROM met.cohortstage, met.cohort WHERE cohort.code=$1 AND cohortstage.code=$2 
		and cohortstage.cohort=cohort.id;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_cohortstage(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc)
  OWNER TO "phenodb_coworker";
 
--SELECT met.get_cohortstage('covidcns','bl');

--DROP FUNCTION met.get_reference_by_doi;
CREATE OR REPLACE FUNCTION met.get_reference_by_doi
(
	doi character varying
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT id INTO nid FROM met.reference WHERE reference.doi=$1;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_reference_by_doi(
	doi character varying)
  OWNER TO "phenodb_coworker";
 
--SELECT met.get_reference_by_doi('10.1136/bmj.m3871');

--DROP FUNCTION met.get_assessment;
CREATE OR REPLACE FUNCTION met.get_assessment
(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc DEFAULT ''
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT assessment.id INTO nid FROM met.assessment 
	WHERE assessment.code=assessment_code
	AND assessment.code=$1
	AND assessment.version_code=assessment_version_code;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
--select met.get_assessment('idpoxfordukbb','')

 --DROP FUNCTION met._select_assessment_items_by_fuzzy_item_text;
CREATE OR REPLACE FUNCTION met._select_assessment_item_by_fuzzy_item_text
(
	assessment_id int,
	source_text character varying(255)
) RETURNS TABLE(assessment_item_id int, _ldistance int) AS $$
	
	SELECT assessment_item.id, levenshtein($2,assessment_item.item_text) ld FROM met.assessment_item 
	WHERE assessment_item.assessment=$1 order by ld

$$ LANGUAGE SQL
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._select_assessment_item_by_fuzzy_item_text(
	assessment_id int,
	source_text character varying(255)
	)
  OWNER TO "phenodb_coworker";
--select met._select_assessment_item_by_fuzzy_item_text(1,'What is name?')
 
 --DROP FUNCTION met._get_assessment_item;
CREATE OR REPLACE FUNCTION met._get_assessment_item
(
	assessment_id int,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT assessment_item.id INTO nid FROM met.assessment_item 
	WHERE assessment_item.code=assessment_item_code
	AND assessment_item.assessment=assessment_id;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item(
	assessment_id int,
	assessment_item_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
--select met._get_assessment_item(1,'myitem')

 --DROP FUNCTION met.get_assessment_item;
CREATE OR REPLACE FUNCTION met.get_assessment_item
(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT assessment_item.id INTO nid FROM met.assessment_item 
	WHERE assessment_item.code=assessment_item_code
	AND assessment_item.assessment=met.get_assessment(assessment_type,assessment_code,assessment_version_code);
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item(
	assessment_id int,
	assessment_item_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
 
  --DROP FUNCTION met._get_assessment_item_variable;
CREATE OR REPLACE FUNCTION met._get_assessment_item_variable
(
	assessment_item_id int,
	variable_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT assessment_item_variable.id INTO nid FROM met.assessment_item_variable 
	WHERE assessment_item_variable.code=variable_code
	AND assessment_item_variable.assessment_item=assessment_item_id;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item_variable(
	assessment_item_id int,
	variable_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met.create_assessment_ignoresert
(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	name character VARYING,
	abbreviation CHARACTER VARYING,
	reference_id int,
	documentation CHARACTER VARYING
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment WHERE assessment_type=$1 AND code=$2 AND version_code=$3;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment(assessment_type,code,version_code,name,abbreviation,assessment_type,reference,documentation) VALUES(assessment_type,assessment_code,assessment_version_code,name,abbreviation,assessment_type,documentation) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_assessment_ignoresert(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	name character VARYING,
	abbreviation CHARACTER VARYING,
	reference_id int,
	documentation CHARACTER varying
	)
  OWNER TO "phenodb_coworker";

 
CREATE OR REPLACE FUNCTION met.construct_cohortinstance_table_name
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int default 0
) RETURNS met.varcharcodeletnum_lc AS $$
BEGIN
	return cohort_code ||'_'|| instance_code ||'_'||  assessment_code || '_' || assessment_version_code ||  '_' || table_index::text;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.construct_cohortinstance_table_name(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met.construct_cohortinstance_column_name
(
	assessment_item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc
) RETURNS met.varcharcodeletnum_lc AS $$
BEGIN
	return assessment_item_code ||'_'|| variable_code;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.construct_cohortinstance_column_name(
	assessment_item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";

 
CREATE OR REPLACE FUNCTION met.create_cohortinstance_table
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int default 0
) RETURNS int AS $$
DECLARE
    nid int = NULL;
    tname character varying = NULL;
BEGIN
	
	nid:=met.get_cohort(cohort_code);
	IF nid IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent cohort [%]', cohort_code
      		USING HINT = 'Check that the cohort has been created with the code you are using.';
	END IF;

	nid:=met.get_cohortinstance(cohort_code, instance_code);
	IF nid IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent cohortinstance [%]', cohort_code
      		USING HINT = 'Check that the cohortinstance has been created with the code you are using, for the referenced cohort.';
	END IF;

	nid:=met.get_assessment(assessment_code,assessment_version_code);
	IF nid IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent assessment [%]', assessment_code || assessment_version_code
      		USING HINT = 'Check that the assessment has been created with the code you are using, for the referenced cohort.';
	END IF;

	tname:= met.construct_cohortinstance_table_name(cohort_code,instance_code,assessment_code,assessment_version_code,table_index);

	execute 'CREATE TABLE IF NOT EXISTS coh.' || tname || '(_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),_stage met.varcharcodeletnum_lc NOT NULL,_individual_identifier uuid NOT NULL);';

	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_cohortinstance_table(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int
	)
  OWNER TO "phenodb_coworker";

 --SELECT met.create_cohortinstance_table('covidcns','2021','idpoxfordukbb','');

 
CREATE OR REPLACE FUNCTION met.check_assessment_item_variable
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc,
	table_index int default 0
) RETURNS boolean AS $$
DECLARE
    toreturn boolean = FALSE;
BEGIN

	IF EXISTS
	(
		SELECT 1 
		FROM information_schema.columns 
		WHERE table_schema='coh'
		AND table_name = met.construct_cohortinstance_table_name(cohort_code,instance_code,assessment_code,assessment_version_code,table_index)
		AND column_name = met.construct_cohortinstance_column_name(assessment_item_code,variable_code)
	) THEN
		toreturn:=TRUE;
	END IF;

	RETURN toreturn;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.check_assessment_item_variable(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc,
	table_index int
	)
  OWNER TO "phenodb_coworker";
 
 
--HERE!!!!!!! 
CREATE OR REPLACE FUNCTION met._create_assessment_item
(
	assessment_id int,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment WHERE assessment_type=$1 AND code=$2 AND version_code=$3;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment(assessment_type,code,version_code,name,abbreviation,assessment_type,reference,documentation) VALUES(assessment_type,assessment_code,assessment_version_code,name,abbreviation,assessment_type,documentation) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_assessment_ignoresert(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	name character VARYING,
	abbreviation CHARACTER VARYING,
	reference_id int,
	documentation CHARACTER varying
	)
  OWNER TO "phenodb_coworker";

-- NEEDS REVIEW!
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
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_phenotype_ignoresert(name character varying(100),
	code_suggestion_old character varying(100),
	nphenotype_type met.varcharcodesimple_lc,
	documentation character varying,
	nid_gwasdb integer,
	ncode_gwasdb met.varcharcodeletnum_lc,
	reclevel integer)
  OWNER TO "phenodb_coworker";
  
--SELECT met.create_phenotype_upsert('ADHD symptoms','ADHD','trt','')