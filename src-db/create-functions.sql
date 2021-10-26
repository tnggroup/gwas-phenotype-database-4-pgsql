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
	assessment_item_type int,
	source_text character varying(255)
) RETURNS TABLE(assessment_item_id int, _ldistance int) AS $$
	
	SELECT assessment_item.id, levenshtein($3,assessment_item.item_text) ld FROM met.assessment_item 
	WHERE assessment_item.assessment=$1 AND assessment_item.assessment_item_type=$2 order by ld

$$ LANGUAGE sql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._select_assessment_item_by_fuzzy_item_text(
	assessment_id int,
	assessment_item_type int,
	source_text character varying(255)
	)
  OWNER TO "phenodb_coworker";
--select met._select_assessment_item_by_fuzzy_item_text(1,3,'What is name?')
 
 --DROP FUNCTION met._get_assessment_item;
CREATE OR REPLACE FUNCTION met._get_assessment_item
(
	assessment_id int,
    assessment_item_type int,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	SELECT assessment_item.id INTO nid FROM met.assessment_item 
	WHERE assessment_item.assessment=$1 AND assessment_item.assessment_item_type=$2
	AND assessment_item.code=$4;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met._get_assessment_item(
	assessment_id int,
    assessment_item_type int,
	assessment_item_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
--select met._get_assessment_item(1,3,'myitem')

 --DROP FUNCTION met.get_assessment_item;
CREATE OR REPLACE FUNCTION met.get_assessment_item
(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
	assessment_item_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	SELECT _get_assessment_item(met.get_assessment($2,$3),met.get_assessment_item_type($1,$4),$5) INTO nid;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment_item(
	assessment_type met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_type_code met.varcharcodesimple_lc,
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
 
 
CREATE OR REPLACE FUNCTION met.verify_cohortinstance_assessment
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
) RETURNS BOOLEAN AS $$
DECLARE
    nid int = NULL;
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

	return true;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.verify_cohortinstance_assessment(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
--select met.verify_cohortinstance_assessment('covidcns','2021','idpukbb','2021');

CREATE OR REPLACE FUNCTION met.create_cohortinstance_table
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

	execute 'CREATE TABLE IF NOT EXISTS coh.' || tname || '(_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),_stage met.varcharcodeletnum_lc NOT NULL,_individual_identifier uuid NOT NULL);';

	RETURN nid;
END;
$$ LANGUAGE plpgsql;
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

 --SELECT met.create_cohortinstance_table('covidcns','2021','idpukbb','2021');

/*DROP FUNCTION met.select_cohort_inventory(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	);
	*/
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
	OUT data_type information_schema.character_data
	
) AS $$

	SELECT substring(table_name from '^(.+?)_') cohort_code, substring(table_name from '^.+?_(.*?)_') instance_code, substring(table_name from '^.+?_.*?_(.+?)_') assessment_code, substring(table_name from '^.+?_.*?_.+?_(.*?)_') assessment_version_code, substring(table_name from '_(\d+)$')::int table_index,
	substring(column_name from '^([^_\n\r]+?)(_|$)') assessment_item_code,
	substring(column_name from '^[^_\n\r]+?_(.+)$') assessment_item_variable_code,
	columns.column_default,
	columns.is_nullable,
	columns.data_type
	FROM information_schema.columns 
	where table_schema='coh' AND ($1=cohort_code OR $1 IS NULL) AND ($2=instance_code OR $2 IS NULL) AND ($3=assessment_code OR $3 IS NULL) AND ($4=assessment_version_code OR $4 IS NULL)
	ORDER BY table_name


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


CREATE OR REPLACE FUNCTION met.get_cohortintance_table_number
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    toreturn int=NULL;
BEGIN


	SELECT max();


	RETURN toreturn;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.check_assessment_item_variable(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
 
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
$$ LANGUAGE plpgsql;
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
 