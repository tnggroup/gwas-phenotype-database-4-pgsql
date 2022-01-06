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
$$ LANGUAGE plpgsql;
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
$$ LANGUAGE plpgsql;
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
$$ LANGUAGE plpgsql;
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
$$ LANGUAGE plpgsql;
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
$$ LANGUAGE plpgsql;
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
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
--select met.get_assessment('idpukbb','2021')

--DROP FUNCTION met.get_assessment_item_type;
CREATE OR REPLACE FUNCTION met.get_assessment_item_type
(
	assessment_type met.varcharcodesimple_lc,
    code met.varcharcodesimple_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	SELECT assessment_item_type.id INTO nid FROM met.assessment_item_type
	WHERE assessment_item_type.assessment_type=$1
	AND assessment_item_type.code=$2;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment_item_type(
	assessment_type met.varcharcodesimple_lc,
	code met.varcharcodesimple_lc
	)
  OWNER TO "phenodb_coworker";
--select met.get_assessment_item_type('imaging','idp')

 --DROP FUNCTION met._select_assessment_items_by_fuzzy_item_text;
CREATE OR REPLACE FUNCTION met._select_assessment_item_by_fuzzy_item_text
(
	assessment_id int,
	source_text character varying(255)
) RETURNS TABLE(assessment_item_id int, _ldistance int) AS $$
	
	SELECT assessment_item.id, levenshtein($2,assessment_item.item_text) ld FROM met.assessment_item 
	WHERE assessment_item.assessment=$1 order by ld

$$ LANGUAGE sql;
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
	WHERE assessment_item.assessment=$1 AND assessment_item.item_code=$2;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item(
	assessment_id int,
	assessment_item_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
--select met._get_assessment_item(1,'myitem')
--select met._get_assessment_item(met.get_assessment('covidcnsdem','1'),'test')

 --DROP FUNCTION met.get_assessment_item;
CREATE OR REPLACE FUNCTION met.get_assessment_item
(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	SELECT met._get_assessment_item(met.get_assessment($1,$2),$3) INTO nid;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment_item(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";

 --select met.get_assessment_item('covidcnsdem','1','test');
 
 
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
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item_variable(
	assessment_item_id int,
	variable_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met.create_assessment_ignoresert
(
	assessment_type met.varcharcodesimple_lc,
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
	
	SELECT 1 id INTO nid FROM met.assessment WHERE assessment.assessment_type=$1 AND assessment.code=$2 AND assessment.version_code=$3;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment(assessment_type,code,version_code,name,abbreviation,reference,documentation) VALUES(assessment_type,assessment_code,assessment_version_code,name,abbreviation,reference_id,documentation) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_assessment_ignoresert(
	assessment_type met.varcharcodesimple_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	name character VARYING,
	abbreviation CHARACTER VARYING,
	reference_id int,
	documentation CHARACTER varying
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met._create_assessment_item_ignoresert
(
	assessment integer,
	assessment_type met.varcharcodesimple_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
	item_code met.varcharcodeletnum_lc,
    item_original_descriptor character varying(100),
    item_name character varying,
    item_index met.intoneindex,
    item_text character varying,
    documentation character varying = ''
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment_item
	WHERE assessment_item.assessment=$1 AND assessment_item.item_code=$4;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment_item(assessment,assessment_item_type,item_code,item_original_descriptor,item_name,item_index,item_text,documentation)
		VALUES($1,met.get_assessment_item_type($2,$3),$4,$5,$6,$7,$8,$9) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._create_assessment_item_ignoresert(
	assessment integer,
	assessment_type met.varcharcodesimple_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
	item_code met.varcharcodeletnum_lc,
    item_original_descriptor character varying(100),
    item_name character varying,
    item_index met.intoneindex,
    item_text character varying,
    documentation character varying
	)
  OWNER TO "phenodb_coworker";
 
 
CREATE OR REPLACE FUNCTION met.create_assessment_item_ignoresert
(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_type met.varcharcodesimple_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
	item_code met.varcharcodeletnum_lc,
    item_original_descriptor character varying(100),
    item_name character varying,
    item_index met.intoneindex,
    item_text character varying,
    documentation character varying = ''
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment_item
	WHERE assessment_item.assessment=met.get_assessment($1,$2) AND assessment_item.item_code=$5;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment_item(assessment,assessment_item_type,item_code,item_original_descriptor,item_name,item_index,item_text,documentation)
		VALUES(met.get_assessment($1,$2),met.get_assessment_item_type($3,$4),$5,$6,$7,$8,$9,$10) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.create_assessment_item_ignoresert(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_type met.varcharcodesimple_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
	item_code met.varcharcodeletnum_lc,
    item_original_descriptor character varying(100),
    item_name character varying,
    item_index met.intoneindex,
    item_text character varying,
    documentation character varying
	)
  OWNER TO "phenodb_coworker";

CREATE OR REPLACE FUNCTION met._create_assessment_item_variable_ignoresert
(
	assessment_item integer,
	variable_code met.varcharcodeletnum_lc,
    variable_original_descriptor character varying,
    variable_index met.intoneindex,
	variable_name character varying=NULL,
	variable_text character varying=NULL,
    variable_int_min_limit integer=NULL,
    variable_int_max_limit integer=NULL,
    variable_float_min_limit double precision=NULL,
    variable_float_max_limit double precision=NULL,
    variable_unit CHARACTER VARYING=NULL,
    variable_alt_code character varying(100)[]=NULL,
    variable_alt_text character varying(100)[]=NULL
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment_item_variable
	WHERE assessment_item_variable.assessment_item=$1 AND assessment_item_variable.variable_code=$2;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment_item_variable(assessment_item,variable_code,variable_original_descriptor,variable_index,variable_name,variable_text,variable_int_min_limit,variable_int_max_limit,variable_float_min_limit,variable_float_max_limit,
												variable_unit,variable_alt_code,variable_alt_text)
		VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._create_assessment_item_variable_ignoresert(
	assessment_item integer,
	variable_code met.varcharcodeletnum_lc,
    variable_original_descriptor character varying,
    variable_index met.intoneindex,
	variable_name character varying,
	variable_text character varying,
    variable_int_min_limit integer,
    variable_int_max_limit integer,
    variable_float_min_limit double precision,
    variable_float_max_limit double precision,
    variable_unit CHARACTER VARYING,
    variable_alt_code character varying(100)[],
    variable_alt_text character varying(100)[]
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
$$ LANGUAGE plpgsql;
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
	column_code met.varcharcodeletnum_lc
) RETURNS met.varcharcodeletnum_lc AS $$
BEGIN
	return assessment_item_code ||'_'|| column_code;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.construct_cohortinstance_column_name(
	assessment_item_code met.varcharcodeletnum_lc,
	column_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met.parse_cohort_code_from_table_name
(
	table_name text
) RETURNS text AS $$
BEGIN
	return substring("table_name" from '^(.+?)_');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_cohort_code_from_table_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";
 
CREATE OR REPLACE FUNCTION met.parse_instance_code_from_table_name
(
	table_name text
) RETURNS text AS $$
BEGIN
	return substring("table_name" from '^.+?_(.*?)_');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_instance_code_from_table_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";

CREATE OR REPLACE FUNCTION met.parse_assessment_code_from_table_name
(
	table_name text
) RETURNS text AS $$
BEGIN
	return substring("table_name" from '^.+?_.*?_(.+?)_');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_assessment_code_from_table_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";

CREATE OR REPLACE FUNCTION met.parse_assessment_version_code_from_table_name
(
	table_name text
) RETURNS text AS $$
BEGIN
	return substring("table_name" from '^.+?_.*?_.+?_(.*?)_');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_assessment_version_code_from_table_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";

CREATE OR REPLACE FUNCTION met.parse_table_index_from_table_name
(
	table_name text
) RETURNS int AS $$
BEGIN
	return substring("table_name" from '_(\d+)$')::int;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_table_index_from_table_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";
  
CREATE OR REPLACE FUNCTION met.parse_assessment_item_code_from_column_name
(
	column_name text
) RETURNS text AS $$
BEGIN
	return substring("column_name" from '^([^_\n\r]+?)(_|$)');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_assessment_item_code_from_column_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";

CREATE OR REPLACE FUNCTION met.parse_assessment_item_variable_code_from_column_name
(
	column_name text
) RETURNS text AS $$
BEGIN
	return substring("column_name" from '^[^_\n\r]+?_(.+)$');
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.parse_assessment_item_variable_code_from_column_name(
	table_name text
	)
  OWNER TO "phenodb_coworker";
 
 
CREATE OR REPLACE FUNCTION met.verify_cohortinstance_assessment
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc ='',
	stage_code met.varcharcodeletnum_lc default NULL
) RETURNS int[] AS $$
DECLARE
    nid int = NULL;
	ids int[];
BEGIN
	ids[1]:=met.get_cohort(cohort_code);
	IF ids[1] IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent cohort [%]', cohort_code
      		USING HINT = 'Check that the cohort has been created with the code you are using.';
	END IF;

	ids[2]:=met.get_cohortinstance(cohort_code, instance_code);
	IF ids[2] IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent cohortinstance [%]', cohort_code
      		USING HINT = 'Check that the cohortinstance has been created with the code you are using, for the referenced cohort.';
	END IF;

	ids[3]:=met.get_assessment(assessment_code,assessment_version_code);
	IF ids[3] IS NULL
	THEN
		RAISE EXCEPTION 'Nonexistent assessment [%]', assessment_code || '_' || assessment_version_code
      		USING HINT = 'Check that the assessment has been created with the code you are using.';
	END IF;

	if stage_code is not null
	THEN
		ids[4]:=met.get_cohortstage(cohort_code,stage_code);
		IF ids[4] IS NULL
		THEN
			RAISE EXCEPTION 'Nonexistent cohortstage[%]', stage_code
	      		USING HINT = 'Check that the cohortstage has been created with the code you are using, for the referenced cohort.';
		END IF;
	end if;
	return ids;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.verify_cohortinstance_assessment(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	stage_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
--select met.verify_cohortinstance_assessment('covidcns','2021','idpukbb','2021');

CREATE OR REPLACE FUNCTION coh.create_cohortinstance_table
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int default 1
) RETURNS int AS $$
DECLARE
    nid int = NULL;
    tname character varying = NULL;
BEGIN
	
	PERFORM met.verify_cohortinstance_assessment(cohort_code,instance_code,assessment_code,assessment_version_code);

	tname:= met.construct_cohortinstance_table_name(cohort_code,instance_code,assessment_code,assessment_version_code,table_index);

	EXECUTE 'CREATE TABLE IF NOT EXISTS coh.' || tname || '(_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),_stage integer NOT NULL,_individual_identifier uuid NOT NULL,_time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),_time_assessment TIMESTAMP WITH TIME ZONE NOT NULL,_user name NOT NULL DEFAULT session_user, CONSTRAINT ' || tname || '_stage_fk FOREIGN KEY (_stage) REFERENCES met.cohortstage(id));';
	EXECUTE 'CREATE INDEX IF NOT EXISTS ' || tname || '_i ON coh.' || tname || ' (_stage,_individual_identifier,_time_entry,_time_assessment,_user);';

	RETURN nid;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = coh, pg_temp;
ALTER FUNCTION coh.create_cohortinstance_table(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int
	)
  OWNER TO "phenodb_owner";

 --SELECT coh.create_cohortinstance_table('covidcns','2021','idpukbb','2021');

CREATE OR REPLACE FUNCTION coh.create_cohortinstance_table_column
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc,
	pgsql_datatype_string met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    tindex int = NULL;
	string_query text;
BEGIN
	
	--PERFORM met.verify_cohortinstance_assessment(cohort_code,instance_code,assessment_code,assessment_version_code);
    tindex:=met.get_cohortinstance_table_index(cohort_code,instance_code,assessment_code,assessment_version_code);
	PERFORM coh.create_cohortinstance_table(cohort_code,instance_code,assessment_code,assessment_version_code,tindex);
	--TODO add verify assessment item and variable
	string_query := 'ALTER TABLE coh.' || met.construct_cohortinstance_table_name(cohort_code,instance_code,assessment_code,assessment_version_code,tindex) || ' ADD COLUMN IF NOT EXISTS ' || met.construct_cohortinstance_column_name(item_code,variable_code) || ' ' || pgsql_datatype_string || ';';
	--RAISE NOTICE 'Q: %',string_query;
	EXECUTE string_query;

	RETURN tindex;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = coh, pg_temp;
ALTER FUNCTION coh.create_cohortinstance_table_column(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	item_code met.varcharcodeletnum_lc,
	variable_code met.varcharcodeletnum_lc,
	pgsql_datatype_string met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_owner";

 
/*
CREATE OR REPLACE FUNCTION met.select_cohort_inventory
(
	cohort_code met.varcharcodeletnum_lc = NULL,
	instance_code met.varcharcodeletnum_lc = NULL,
	assessment_code met.varcharcodeletnum_lc = NULL,
	assessment_version_code met.varcharcodeletnum_lc = NULL,
	OUT cohort_code text,
	OUT instance_code text,
	OUT assessment_code text,
	OUT assessment_version_code text,
	OUT assessment_item_code text,
	OUT assessment_item_variable_code text,
	OUT table_index information_schema.character_data,
	OUT column_default information_schema.character_data,
	OUT is_nullable information_schema.yes_or_no,
	OUT data_type information_schema.character_data,
	OUT cohort_id int
	
) AS $$

	WITH fi AS (SELECT
				substring("table_name" from '^(.+?)_') cohort_code,
				substring("table_name" from '^.+?_(.*?)_') instance_code,
				substring("table_name" from '^.+?_.*?_(.+?)_') assessment_code,
				substring("table_name" from '^.+?_.*?_.+?_(.*?)_') assessment_version_code,
				substring("table_name" from '_(\d+)$')::int table_index,
				substring("column_name" from '^([^_\n\r]+?)(_|$)') assessment_item_code,
				substring("column_name" from '^[^_\n\r]+?_(.+)$') assessment_item_variable_code,
				columns.column_default,
				columns.is_nullable,
				columns.data_type
				FROM information_schema.columns where table_catalog='phenodb' AND table_schema='coh'
			   )
	SELECT fi.*, cohort.id AS cohort_id
	FROM fi LEFT OUTER JOIN met.cohort ON fi.cohort_code=cohort.code
	where ($1=fi.cohort_code OR $1 IS NULL) AND ($2=fi.instance_code OR $2 IS NULL) AND ($3=fi.assessment_code OR $3 IS NULL) AND ($4=fi.assessment_version_code OR $4 IS NULL)
	ORDER BY cohort_code,instance_code,assessment_code,assessment_version_code,assessment_item_code,assessment_item_variable_code


$$ LANGUAGE sql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.select_cohort_inventory(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 */
--SELECT * FROM met.select_cohort_inventory('covidcns','2021','idpukbb','2021');
 
CREATE OR REPLACE FUNCTION met.get_cohortinstance_table_index
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    toreturn int=NULL;
	columncount int=NULL;
BEGIN

	SELECT COUNT(cohort_inventory.cohort_code), max(cohort_inventory.table_index) INTO columncount,toreturn FROM met.cohort_inventory
	WHERE
		cohort_inventory.cohort_code=$1
	AND cohort_inventory.instance_code=$2
	AND cohort_inventory.assessment_code=$3
	AND cohort_inventory.assessment_version_code=$4;
	
	IF columncount<500
	THEN RETURN toreturn;
	ELSE RETURN (toreturn+1);
	END IF;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_cohortinstance_table_index(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
  
--SELECT met.get_cohortinstance_table_index('covidcns','2021','idpukbb','2021');

CREATE OR REPLACE FUNCTION met._get_cohortinstance_table_index
(
	cohortinstance_id int,
	assessment_id int
) RETURNS int AS $$
DECLARE
    toreturn int=NULL;
	columncount int=NULL;
BEGIN

	SELECT COUNT(cohort_inventory.cohort_code), max(cohort_inventory.table_index) INTO columncount,toreturn FROM met.cohort_inventory
	WHERE
		cohort_inventory.cohortinstance_id=$1
	AND cohort_inventory.assessment_id=$2;
	
	IF columncount<500
	THEN RETURN toreturn;
	ELSE RETURN (toreturn+1);
	END IF;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_cohortinstance_table_index(
	cohortinstance_id int,
	assessment_id int
	)
  OWNER TO "phenodb_coworker";
  
 --SELECT met._get_cohortintance_table_index(1,1);

 
CREATE OR REPLACE FUNCTION met._check_cohortinstance_assessment_item_variable
(
	cohortinstance_id int,
	assessment_id int,
	assessment_item_id int,
	assessment_item_variable_id int
) RETURNS boolean AS $$
DECLARE
    toreturn boolean = FALSE;
BEGIN

	IF EXISTS
	(
		SELECT 1 assessment_item_variable_id
		FROM met.cohort_inventory
		WHERE cohort_inventory.cohortinstance_id=$1 AND cohort_inventory.assessment_id=$2 AND cohort_inventory.assessment_item_id=$3 AND cohort_inventory.assessment_item_variable_id=$4
	) THEN
		toreturn:=TRUE;
	END IF;

	RETURN toreturn;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._check_cohortinstance_assessment_item_variable(
	cohortinstance_id int,
	assessment_id int,
	assessment_item_id int,
	assessment_item_variable_id int
	)
  OWNER TO "phenodb_coworker";
  
 --SELECT met._check_cohortinstance_assessment_item_variable(1,1,1,1)
 
 
CREATE OR REPLACE FUNCTION met._check_cohortinstance_assessment_item_variable_from_column_name
(
	cohortinstance_id int,
	assessment_id int,
	column_name character varying
) RETURNS boolean AS $$
DECLARE
    toreturn boolean = FALSE;
BEGIN
	
	IF EXISTS
	(
		SELECT 1 assessment_item_variable_id
		FROM met.cohort_inventory
		WHERE cohort_inventory.cohortinstance_id=$1 AND cohort_inventory.assessment_id=$2 AND cohort_inventory.assessment_item_code=met.parse_assessment_item_code_from_column_name($3) AND cohort_inventory.assessment_item_variable_code=met.parse_assessment_item_variable_code_from_column_name($3)
	) THEN
		toreturn:=TRUE;
	END IF;

	RETURN toreturn;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._check_cohortinstance_assessment_item_variable_from_column_name(
	cohortinstance_id int,
	assessment_id int,
	column_name character varying
	)
  OWNER TO "phenodb_coworker";
  
 --SELECT met._check_cohortinstance_assessment_item_variable_from_column_name(1,1,"item1_variable1")
 

CREATE OR REPLACE FUNCTION sec._create_cohortinstance_individual
(
	cohortinstance_id int,
	identifier_cohort met.varcharcodesimple_lc,
	"name" character varying DEFAULT NULL,
	name_more character varying DEFAULT NULL,
	surname character varying DEFAULT NULL,
	sex met.sex DEFAULT NULL,
	time_birth TIMESTAMP WITH TIME ZONE DEFAULT NULL,
	country character(2) DEFAULT NULL,
	email character varying DEFAULT NULL,
	apartment character varying DEFAULT NULL,
	house character varying DEFAULT NULL,
	street character varying DEFAULT NULL,
	city character varying DEFAULT NULL,
	province character varying DEFAULT NULL,
	postal_code character varying DEFAULT NULL,
	cellphone character varying DEFAULT NULL,
	phone_other character varying DEFAULT NULL
) RETURNS uuid AS $$
DECLARE
    nid int = NULL;
	nuuid uuid = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM sec.individual_cohortinstance_identifier ici
	WHERE ici.cohortinstance=$1 AND (ici.identifier_cohort=$2 OR ici.identifier::text=$2);
	
	IF nid IS NOT NULL
	THEN
		RAISE EXCEPTION 'Cohort individual [%] already exists.', $2
      		USING HINT = 'Not possible to add already existing cohort individual relation.';
	END IF;
	
	--does not match existing individuals outside of the cohort (yet)
	INSERT INTO sec.individual(name,name_more,surname,sex,time_birth)VALUES($3,$4,$5,$6,$7) RETURNING id INTO nid;
	INSERT INTO sec.individual_cohortinstance_identifier(individual,cohortinstance,identifier_cohort,country,email,apartment,house,street,city,province,postal_code,cellphone,phone_other)VALUES(nid,$1,$2,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17) RETURNING identifier INTO nuuid;
	
	RETURN nuuid;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION sec._create_cohortinstance_individual(
	cohortinstance_id int,
	identifier_cohort met.varcharcodesimple_lc,
	"name" character varying,
	name_more character varying,
	surname character varying,
	sex met.sex,
	time_birth TIMESTAMP WITH TIME ZONE,
	country character(2),
	email character varying,
	apartment character varying,
	house character varying,
	street character varying,
	city character varying,
	province character varying,
	postal_code character varying,
	cellphone character varying,
	phone_other character varying
	)
  OWNER TO "phenodb_coworker";

/*
SELECT * FROM sec._create_cohortinstance_individual
(
	cohortinstance_id => 1::int,
	identifier_cohort => 'spid1'::met.varcharcodesimple_lc,
	name => 'Test1'::text,
	sex => 'male'::met.sex
);
 */
 
 
 
CREATE OR REPLACE FUNCTION coh.prepare_import
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_name met.varcharcodesimple,
	cohort_id_column_name met.varcharcodesimple[] DEFAULT '{}',
	annotation_table_name met.varcharcodesimple DEFAULT NULL
) RETURNS int AS $$
DECLARE
	ids int[];
	var_cohortinstance_id int;
	var_assessment_id int;
	string_query text;
    toreturn int;
BEGIN

	ids:=met.verify_cohortinstance_assessment(cohort_code,instance_code,assessment_code,assessment_version_code);
	var_cohortinstance_id:=ids[2];
	var_assessment_id:=ids[3];
	
	RAISE NOTICE 'var_cohortinstance_id %',var_cohortinstance_id;
	RAISE NOTICE 'var_assessment_id %',var_cohortinstance_id;
	
	DROP TABLE IF EXISTS t_import_data_cohort_settings CASCADE;
	CREATE TEMP TABLE IF NOT EXISTS t_import_data_cohort_settings AS
	SELECT
		var_cohortinstance_id cohortinstance_id,
		var_assessment_id assessment_id
	;
	GRANT ALL ON TABLE t_import_data_cohort_settings TO "phenodb_coworker";
	
	DROP TABLE IF EXISTS t_import_data_cohort_table_name CASCADE;
	CREATE TEMP TABLE IF NOT EXISTS t_import_data_cohort_table_name AS
	SELECT $5 table_name;
	GRANT ALL ON TABLE t_import_data_cohort_table_name TO "phenodb_coworker";
	
	DROP TABLE IF EXISTS t_import_data_cohort_id_column_names CASCADE;
	CREATE TEMP TABLE IF NOT EXISTS t_import_data_cohort_id_column_names AS
	SELECT UNNEST(cohort_id_column_name) id_column_name;
	GRANT ALL ON TABLE t_import_data_cohort_id_column_names TO "phenodb_coworker";
	
	--set permission to right user group
	string_query:= 'GRANT ALL ON TABLE ' || table_name || ' TO "phenodb_coworker" ';
	EXECUTE string_query;
	
	IF annotation_table_name IS NOT NULL
	THEN
		string_query:= 'GRANT ALL ON TABLE ' || annotation_table_name || ' TO "phenodb_coworker" ';
		EXECUTE string_query;
	END IF;
	
	--TODO - ADD CUSTOM SCHEMA CHOICE 
	CREATE OR REPLACE TEMP VIEW t_import_data_meta AS
	WITH imp AS (SELECT
					met.parse_assessment_item_code_from_column_name("column_name") assessment_item_code,
					met.parse_assessment_item_variable_code_from_column_name("column_name") assessment_item_variable_code,
					--CASE WHEN columns.column_name = ANY(cohort_id_column_name) THEN TRUE ELSE FALSE END cohort_id,
				 	COUNT(icn.id_column_name) > 0 is_cohort_id,
				 	columns.table_catalog,
				 	columns.table_schema,
					columns.table_name,
				 	tables.table_type,
				 	columns.column_name
				 FROM information_schema.columns
				 INNER JOIN information_schema.tables ON columns.table_catalog=tables.table_catalog AND columns.table_schema=tables.table_schema AND columns.table_name=tables.table_name
				 INNER JOIN t_import_data_cohort_table_name tn ON columns.table_name=tn.table_name
				 LEFT OUTER JOIN t_import_data_cohort_id_column_names icn ON columns.column_name = icn.id_column_name
				WHERE columns.table_catalog='phenodb' AND tables.table_type='LOCAL TEMPORARY'
				GROUP BY assessment_item_code,assessment_item_variable_code,columns.table_catalog,columns.table_schema,columns.table_name,tables.table_type,columns.column_name
				)
	SELECT
	imp.assessment_item_code,
	imp.assessment_item_variable_code,
	imp.is_cohort_id,
	(imp.is_cohort_id OR imp.is_cohort_id) meta, --it should look like this for now - add more conditions when needed
	inv.table_name n_table_name, inv.column_name n_column_name,
	columns.*
	FROM 
	imp
	LEFT OUTER JOIN t_import_data_cohort_settings s ON TRUE
	LEFT OUTER JOIN met.cohort_inventory inv ON inv.cohortinstance_id=s.cohortinstance_id AND inv.assessment_id=s.assessment_id AND imp.assessment_item_code=inv.assessment_item_code AND imp.assessment_item_variable_code = inv.assessment_item_variable_code
	LEFT OUTER JOIN information_schema.columns ON imp.table_catalog=columns.table_catalog AND imp.table_schema=columns.table_schema AND imp.table_name=columns.table_name AND imp.column_name=columns.column_name;
	GRANT SELECT ON t_import_data_meta TO "phenodb_coworker";
	
	SELECT COUNT(t_import_data_meta.*) INTO toreturn FROM t_import_data_meta;
	RAISE NOTICE 'nrows %',toreturn;
	
	CREATE OR REPLACE TEMP VIEW t_import_data_assessment_item_stats AS
	SELECT
	m.assessment_item_code,
	COUNT(m.assessment_item_variable_code) count_var,
	COUNT(CASE WHEN m.n_column_name IS NOT NULL THEN assessment_item_variable_code END) count_annotated_var,
	COUNT(CASE WHEN m.data_type IN ('integer','smallint','serial','smallserial') THEN assessment_item_variable_code END) count_datatype_integer,
	COUNT(CASE WHEN m.data_type IN ('double precision','real') THEN assessment_item_variable_code END) count_datatype_float,
	COUNT(CASE WHEN m.data_type IN ('text','character varying','character') THEN assessment_item_variable_code END) count_datatype_text,
	COUNT(CASE WHEN m.data_type IN ('boolean') THEN assessment_item_variable_code END) count_datatype_boolean,
	COUNT(CASE WHEN m.data_type IN ('timestamp','time') THEN assessment_item_variable_code END) count_datatype_time
	FROM t_import_data_meta m
	WHERE m.meta = FALSE
	GROUP BY m.assessment_item_code
	ORDER BY assessment_item_code;
	GRANT SELECT ON t_import_data_assessment_item_stats TO "phenodb_coworker";
	
	CREATE OR REPLACE TEMP VIEW t_import_data_assessment_item_variable_stats AS
	SELECT
	m.assessment_item_code,
	m.assessment_item_variable_code,
	m.column_name,
	m.data_type,
	(m.n_column_name IS NOT NULL) annotated
	FROM t_import_data_meta m
	WHERE m.meta = FALSE
	ORDER BY assessment_item_code, assessment_item_variable_code;
	GRANT SELECT ON t_import_data_assessment_item_variable_stats TO "phenodb_coworker";
	
	SELECT COUNT(t_import_data_assessment_item_variable_stats.*) INTO toreturn FROM t_import_data_assessment_item_variable_stats;
	RAISE NOTICE 'nrows t_import_data_assessment_item_variable_stats=%',toreturn;
	
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION coh.prepare_import(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_name met.varcharcodesimple,
	cohort_id_column_name met.varcharcodesimple[],
	annotation_table_name met.varcharcodesimple
	)
  OWNER TO "phenodb_coworker";
 
 
 
 
/*
--test input
DROP TABLE IF EXISTS ttest;
CREATE TEMP TABLE 
ttest(
	spid text, 
	item1_var1 int,
	item1_var2 text,
	item2_var1 double precision,
	item3_var1 int,
	item3_var2 character varying);
GRANT ALL ON TABLE ttest TO "phenodb_coworker";
INSERT INTO ttest(spid,item1_var1, item1_var2, item2_var1, item3_var1) VALUES('spid1',2,NULL,'34.7',1);
INSERT INTO ttest(spid,item1_var1, item1_var2, item2_var1, item3_var1) VALUES('spid2',1,'I did not want to do this.','31.8',1);
INSERT INTO ttest(spid,item1_var1, item1_var2, item2_var1, item3_var1) VALUES('spid3',1,NULL,'71.1',1);
INSERT INTO ttest(spid,item1_var1, item1_var2, item2_var1, item3_var1, item3_var2) VALUES('spid4',3,NULL,'71.1',2,'No comment.');

SELECT * FROM ttest;

*/

CREATE OR REPLACE FUNCTION coh.import_data
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	stage_code met.varcharcodeletnum_lc,
	table_name met.varcharcodesimple,
	do_annotate boolean DEFAULT FALSE,
	add_individuals boolean DEFAULT FALSE,
	do_insert boolean DEFAULT FALSE,
	annotation_table_name met.varcharcodesimple DEFAULT NULL
) RETURNS int AS $$
DECLARE
	ids int[];
	var_cohortinstance_id int;
	var_assessment_id int;
	var_cohortstage_id int;
    toreturn int;
	string_assessment_main_type text;
	n_table_names text[];
	c_n_table_name text;
	cohort_id_columns text[];
	c_cohort_id_column text;
	string_target_column_names text;
	string_source_column_names text;
	string_query text;
	r RECORD;
BEGIN

	ids:=met.verify_cohortinstance_assessment(cohort_code,instance_code,assessment_code,assessment_version_code,stage_code);
	var_cohortinstance_id:=ids[2];
	var_assessment_id:=ids[3];
	var_cohortstage_id:=ids[4];
	
	
	--SELECT assessment.assessment_type INTO string_assessment_main_type FROM met.assessment WHERE addessment.id=var_assessment_id;
	
	RAISE NOTICE 'var_cohortinstance_id %',var_cohortinstance_id;
	RAISE NOTICE 'var_assessment_id %',var_assessment_id;
	RAISE NOTICE 'var_cohortstage_id %',var_cohortstage_id;
	
	--data-individual view
	SELECT ARRAY(SELECT assessment_item_code FROM t_import_data_meta WHERE t_import_data_meta.is_cohort_id =TRUE ORDER BY t_import_data_meta.ordinal_position) INTO cohort_id_columns;
	c_cohort_id_column:=cohort_id_columns[1];
	
	string_query := 'CREATE OR REPLACE TEMP VIEW t_src_individual AS SELECT src.*, src.' || c_cohort_id_column || ' _spid, ici.identifier _individual_identifier FROM ' || table_name || ' src ' || ' LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici ON (src.' || c_cohort_id_column || '=ici.identifier_cohort OR src.' || c_cohort_id_column || '=ici.identifier::text) AND ici.cohortinstance=' || var_cohortinstance_id || ' LEFT OUTER JOIN sec.individual i ON ici.individual=i.id';
	RAISE NOTICE 'Q: %',string_query;
	EXECUTE string_query;
	
	
	IF do_annotate = FALSE AND EXISTS (SELECT 1 n_column_name FROM t_import_data_meta WHERE t_import_data_meta.n_column_name IS NULL AND t_import_data_meta.meta IS FALSE)
	THEN
		RAISE NOTICE 'Unknown columns present in the imported data.'
      		USING HINT = 'Please add and annotate all assessment item variables that are to be imported into the database.';
		RETURN -1;
	END IF;
	
	
	IF do_annotate
	THEN
		--fallback annotation
		CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_item_annotation AS --ON COMMIT DROP
		SELECT istats.assessment_item_code,
		--string_assessment_main_type assessment_type,
		'questionnaire' assessment_type,
		CASE
			WHEN istats.count_var <2 OR (istats.count_var<3 AND istats.count_datatype_integer=1) THEN 'single'
			WHEN istats.count_var >1 THEN 'multi'
			ELSE 'single'
		END assessment_item_type_code,
		ROW_NUMBER() OVER(ORDER BY istats.assessment_item_code) item_index,
		'' item_text,
		'fallback' item_documentation
		FROM t_import_data_assessment_item_stats istats;
		GRANT ALL ON TABLE t_import_data_assessment_item_annotation TO "phenodb_coworker";
	
		--add items
		FOR r IN 
		SELECT * FROM 
		t_import_data_assessment_item_stats istats 
		INNER JOIN t_import_data_assessment_item_annotation a 
		ON istats.assessment_item_code=a.assessment_item_code WHERE istats.count_annotated_var < istats.count_var
		LOOP
			RAISE NOTICE 'r.assessment_type %',r.assessment_type;
			PERFORM met._create_assessment_item_ignoresert(
				assessment => var_assessment_id,
				assessment_type => r.assessment_type,
				assessment_item_type_code => r.assessment_item_type_code,
				item_code => r.assessment_item_code,
				item_original_descriptor => r.assessment_item_code,
				item_name => r.assessment_item_code,
				item_index => CAST(r.item_index AS int),
				item_text => r.item_text,
				documentation => r.item_documentation
			);
		END LOOP;
		
		--add item variables and cohort table columns
		FOR r IN 
		SELECT * FROM 
		t_import_data_assessment_item_variable_stats vstats 
		--INNER JOIN t_import_data_assessment_item_variable_annotation a --not possible to manually annotate variables yet
		--ON istats.assessment_item_code=a.assessment_item_code 
		WHERE vstats.annotated = FALSE
		LOOP
			RAISE NOTICE 'r.assessment_item_code %',r.assessment_item_code;
			RAISE NOTICE 'met._get_assessment_item()= %',CAST(met._get_assessment_item(var_assessment_id,r.assessment_item_code) AS integer);
			RAISE NOTICE 'r.assessment_item_variable_code %',r.assessment_item_variable_code;
			RAISE NOTICE 'variable_original_descriptor=>r.column_name %',CAST(r.column_name AS character varying);
			RAISE NOTICE 'variable_index=>1 %',CAST(1 AS int);
			PERFORM met._create_assessment_item_variable_ignoresert
			(
				assessment_item => CAST(met._get_assessment_item(var_assessment_id,r.assessment_item_code) AS integer),
				variable_code => CAST(r.assessment_item_variable_code AS met.varcharcodesimple_lc),
				variable_original_descriptor => CAST(r.column_name AS character varying),
				variable_index => CAST(1 AS int),
				variable_name => CAST(r.assessment_item_variable_code AS character varying)
			);
			PERFORM coh.create_cohortinstance_table_column(cohort_code,instance_code,assessment_code,assessment_version_code,r.assessment_item_code,r.assessment_item_variable_code,r.data_type);
		END LOOP;
	END IF;
	
	
	IF add_individuals
	THEN
		FOR r IN SELECT src.* FROM t_src_individual src WHERE src._individual_identifier IS NULL
		LOOP
			PERFORM sec._create_cohortinstance_individual
			(
				cohortinstance_id => var_cohortinstance_id,
				identifier_cohort => r._spid
			);
		END LOOP;
	END IF;
	

	IF do_insert
	THEN
		SELECT ARRAY(SELECT DISTINCT n_table_name FROM t_import_data_meta WHERE t_import_data_meta.meta =FALSE) INTO n_table_names;
		

		RAISE NOTICE 'array %',array_length(n_table_names,1);
		RAISE NOTICE 'c_cohort_id_column %',c_cohort_id_column;

		FOREACH c_n_table_name IN ARRAY n_table_names LOOP
			RAISE NOTICE 'n_table_name %',c_n_table_name;

			string_target_column_names:='_stage,_user,_time_assessment,_individual_identifier';
			string_source_column_names:= E'\'' || var_cohortstage_id || E'\'';
			string_source_column_names:=string_source_column_names || ','  || E'\'' || session_user || E'\'';
			string_source_column_names:=string_source_column_names || ','  || E'\'' || now() || E'\''; 
			string_source_column_names:=string_source_column_names || ',src._individual_identifier';

			FOR r IN SELECT * FROM t_import_data_meta WHERE t_import_data_meta.n_table_name=c_n_table_name AND t_import_data_meta.n_column_name IS NOT NULL
			LOOP
				string_target_column_names:=string_target_column_names || ',' || r.n_column_name;
				string_source_column_names:=string_source_column_names || ',' || r.column_name;
			END LOOP;


			string_query := 'INSERT INTO coh.' || c_n_table_name || '(' || string_target_column_names || ')' || ' SELECT ' || string_source_column_names || ' FROM t_src_individual src WHERE src._individual_identifier IS NOT NULL';
			RAISE NOTICE 'Q: %',string_query;
			EXECUTE string_query;
		END LOOP;
	END IF;
	
	RETURN 1;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = coh, pg_temp;
ALTER FUNCTION coh.import_data(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	stage_code met.varcharcodeletnum_lc,
	table_name met.varcharcodesimple,
	do_annotate boolean,
	add_individuals boolean,
	do_insert boolean,
	annotation_table_name met.varcharcodesimple
	)
  OWNER TO "phenodb_owner";
  
  --SELECT * FROM met.get_cohortinstance('covidcns','2021');
  --SELECT * FROM met.get_assessment('atest','1');
  --SELECT * FROM met.get_cohortstage('covidcns','bl');
  -- SELECT * FROM coh.prepare_import('covidcns','2021','atest','1','ttest','{"spid"}');
  /*
 SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2021',
	assessment_code => 'atest',
	assessment_version_code => '1',
	stage_code => 'bl',
	table_name => 'ttest',
	do_annotate => TRUE,
	add_individuals => TRUE,
	do_insert => TRUE
 );
 */
 --SELECT * FROM t_import_data_meta;
 --SELECT * FROM t_import_data_assessment_item_stats;
 --SELECT * FROM t_import_data_assessment_item_variable_stats;
 -- DROP TABLE t_import_data_assessment_item_annotation
-- SELECT * FROM t_import_data_assessment_item_annotation;
--SELECT * FROM t_src_individual;
 
 --DELETE FROM coh.covidcns_2021_atest_1_1;