/*
 * Requires the extension fuzzystrmatch
 */

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
 
CREATE OR REPLACE FUNCTION met.get_phenotype_category
(
	code met.varcharcodesimple_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	SELECT id INTO nid FROM met.phenotype_category WHERE code=$1;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_phenotype_category(
	code met.varcharcodesimple_lc
	)
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
 
 
  --DROP FUNCTION met.get_assessment_item_variables;
CREATE OR REPLACE FUNCTION met.get_assessment_item_variables
(
	assessment_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_version_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_item_code met.varcharcodeletnum_lc[] DEFAULT ARRAY[]::met.varcharcodeletnum_lc[],
	assessment_variable_code_full met.varcharcodeletnum_lc[] DEFAULT ARRAY[]::met.varcharcodeletnum_lc[],
	assessment_variable_code_original character varying(100)[] DEFAULT ARRAY[]::character varying(100)[]
) RETURNS int[] AS $$
DECLARE
    toreturn int [] = NULL;
BEGIN
	
	IF $1 IS NULL || $2 IS NULL THEN RETURN '{}'; END IF;
	
	IF assessment_item_code IS NULL THEN assessment_item_code:=ARRAY[]::met.varcharcodeletnum_lc[]; END IF;
	IF assessment_variable_code_full IS NULL THEN assessment_variable_code_full:=ARRAY[]::met.varcharcodeletnum_lc[]; END IF;
	IF assessment_variable_code_original IS NULL THEN assessment_variable_code_original:=ARRAY[]::character varying(100)[]; END IF;
	
	toreturn:=ARRAY(
		SELECT assessment_item_variable.id FROM 
		met.assessment_item_variable INNER JOIN met.assessment_item ON assessment_item_variable.assessment_item=assessment_item.id
		LEFT OUTER JOIN (SELECT UNNEST($3) cassessment_item_code) aic ON aic.cassessment_item_code=assessment_item.item_code
		LEFT OUTER JOIN (SELECT UNNEST($4) cassessment_variable_code_full) avcf ON avcf.cassessment_variable_code_full=met.construct_cohortinstance_column_name(assessment_item.item_code,assessment_item_variable.variable_code)
		LEFT OUTER JOIN (SELECT UNNEST($5) cassessment_variable_code_original) avco ON avco.cassessment_variable_code_original=assessment_item_variable.variable_original_descriptor
		WHERE
			assessment_item.assessment=met.get_assessment($1,$2)
		AND ((cardinality($3)<1 AND aic.cassessment_item_code IS NULL) OR aic.cassessment_item_code IS NOT NULL)
		AND ((cardinality($4)<1 AND avcf.cassessment_variable_code_full IS NULL) OR avcf.cassessment_variable_code_full IS NOT NULL)
		AND ((cardinality($5)<1 AND avco.cassessment_variable_code_original IS NULL) OR avco.cassessment_variable_code_original IS NOT NULL)
		ORDER BY assessment_item.item_code, assessment_item_variable.variable_code, assessment_item_variable.id
	);
	RETURN toreturn;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_assessment_item_variables(
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc[],
	assessment_variable_code_full met.varcharcodeletnum_lc[],
	assessment_variable_code_original character varying(100)[]
	)
  OWNER TO "phenodb_coworker";

--SELECT * FROM met.get_assessment_item_variables('covidcnsdem','1',ARRAY['dobage','ethnicorigin']);
--SELECT * FROM met.get_assessment_item_variables('covidcnsdem','1');


CREATE OR REPLACE FUNCTION met.create_phenotype_ignoresert
(
	name character varying(100),
	code met.varcharcodeletnum_lc,
	phenotype_type met.varcharcodesimple_lc DEFAULT 'trt',
	documentation character varying DEFAULT ''
) RETURNS int AS $$
DECLARE
    nid int = -1;
BEGIN
	
	SELECT 1 id INTO nid FROM met.phenotype WHERE phenotype.code=$2 AND phenotype.phenotype_type=$3;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.phenotype(name,code,phenotype_type,documentation) VALUES($1,$2,$3,$4) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.create_phenotype_ignoresert(
	name character varying(100),
	code met.varcharcodeletnum_lc,
	phenotype_type met.varcharcodesimple_lc,
	documentation character varying
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
    variable_alt_text character varying(100)[]=NULL,
    documentation character varying = ''
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	
	SELECT 1 id INTO nid FROM met.assessment_item_variable
	WHERE assessment_item_variable.assessment_item=$1 AND assessment_item_variable.variable_code=$2 OR ($2 IS NULL AND assessment_item_variable.variable_code IS NULL);
	
	IF nid IS NULL
	THEN
		INSERT INTO met.assessment_item_variable(assessment_item,variable_code,variable_original_descriptor,variable_index,variable_name,variable_text,variable_int_min_limit,variable_int_max_limit,variable_float_min_limit,variable_float_max_limit,
												variable_unit,variable_alt_code,variable_alt_text,documentation)
		VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) RETURNING id INTO nid;
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
    variable_alt_text character varying(100)[],
    documentation character varying
	)
  OWNER TO "phenodb_coworker";
 
 
CREATE OR REPLACE FUNCTION met.construct_cohortinstance_table_name
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_index int default 1
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
	IF column_code IS NULL OR column_code=''
	THEN RETURN assessment_item_code;
	ELSE return assessment_item_code ||'_'|| column_code;
	END IF;
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
   	IF tindex IS NULL THEN tindex:=1; END IF;
	PERFORM coh.create_cohortinstance_table(cohort_code,instance_code,assessment_code,assessment_version_code,tindex);
	--TODO add verify assessment item and variable
	string_query := 'ALTER TABLE coh.' || met.construct_cohortinstance_table_name(cohort_code,instance_code,assessment_code,assessment_version_code,tindex) || ' ADD COLUMN IF NOT EXISTS ' || met.construct_cohortinstance_column_name(item_code,variable_code) || ' ' || pgsql_datatype_string || ';';
	RAISE NOTICE 'Q: %',string_query;
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

 

CREATE OR REPLACE FUNCTION met.select_cohort_inventory() RETURNS SETOF met.cohort_inventory
AS $$
	SELECT * FROM met.cohort_inventory;
$$ LANGUAGE sql
SECURITY DEFINER
SET search_path = met, pg_temp;
ALTER FUNCTION met.select_cohort_inventory()
  OWNER TO "phenodb_owner";
--SELECT * FROM met.select_cohort_inventory();
 
CREATE OR REPLACE FUNCTION met.get_cohortinstance_table_index
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
) RETURNS int AS $$
DECLARE
    toreturn int=NULL;
BEGIN
	RETURN met._get_cohortinstance_table_index(met.get_cohortinstance(cohort_code,instance_code),met.get_assessment(assessment_code,assessment_version_code));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = met, pg_temp;
ALTER FUNCTION met.get_cohortinstance_table_index(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc
	)
  OWNER TO "phenodb_coworker";
  
--SELECT met.get_cohortinstance_table_index('covidcns','2022','covidcnsdem','1');
--SELECT * FROM met.get_cohortinstance_table_index('covidcns','2022','idpukbb','2022');
 /*
SELECT COUNT(cohort_inventory.cohort_code), max(cohort_inventory.table_index) FROM met.select_cohort_inventory() cohort_inventory
	WHERE
		cohort_inventory.cohort_code='covidcns'
	AND cohort_inventory.instance_code='2022'
	AND cohort_inventory.assessment_code='idpukbb'
	AND cohort_inventory.assessment_version_code='2022'
	*/

CREATE OR REPLACE FUNCTION met._get_cohortinstance_table_index
(
	cohortinstance_id int,
	assessment_id int
) RETURNS int AS $$
DECLARE
    toreturn int=NULL;
	columncount int=NULL;
BEGIN

	SELECT COUNT(cohort_inventory.cohort_code), max(cohort_inventory.table_index) INTO columncount,toreturn FROM met.select_cohort_inventory() cohort_inventory
	WHERE cohort_inventory.cohortinstance_id=$1 AND cohort_inventory.assessment_id=$2;

	RAISE NOTICE 'column count %',columncount;
	RAISE NOTICE 'max table index %',toreturn;
	RAISE NOTICE 'check %',(columncount / toreturn);
	
	IF (columncount / toreturn)<500
	THEN RETURN toreturn;
	ELSE RETURN (toreturn+1);
	END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = met, pg_temp;
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
		FROM met.select_cohort_inventory() cohort_inventory
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
		FROM met.select_cohort_inventory() cohort_inventory
		WHERE cohort_inventory.cohortinstance_id=$1 AND cohort_inventory.assessment_id=$2 AND cohort_inventory.assessment_item_code=met.parse_assessment_item_code_from_column_name($3) 
			AND (cohort_inventory.assessment_item_variable_code=met.parse_assessment_item_variable_code_from_column_name($3) OR cohort_inventory.assessment_item_variable_code IS NULL AND met.parse_assessment_item_variable_code_from_column_name($3) IS NULL)
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
  
 --SELECT met._check_cohortinstance_assessment_item_variable_from_column_name(1,1,'item1_variable1')
 --SELECT met._check_cohortinstance_assessment_item_variable_from_column_name(1,2,'moneyday')
 

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
 
CREATE OR REPLACE FUNCTION coh._create_current_assessment_item_variable_controlled_tview
(
	cohortinstance int
) RETURNS text AS $$
DECLARE
    string_query_full text:='';
BEGIN
	DROP VIEW IF EXISTS t_export_data_controlled CASCADE;
	string_query_full:='CREATE OR REPLACE TEMP VIEW t_export_data_controlled AS SELECT ici.identifier, ici.cohortinstance, ici.identifier_cohort, ici.participant_type FROM sec.individual_cohortinstance_identifier ici WHERE ici.cohortinstance=' || cohortinstance || ';';
	--RAISE NOTICE 'string_query_full: %',string_query_full;	
	EXECUTE string_query_full;
	GRANT SELECT ON t_export_data_controlled TO "phenodb_user";
	RETURN string_query_full;
END;
$$ LANGUAGE plpgsql
--SECURITY DEFINER -- This is the point of this function compared to the other view
SET search_path = coh, pg_temp;
ALTER FUNCTION coh._create_current_assessment_item_variable_controlled_tview(
	cohortinstance int
	)
  OWNER TO "phenodb_owner";
 

CREATE OR REPLACE FUNCTION coh._create_current_assessment_item_variable_select_query
(
	cohort int,
	cohortinstance int,
	assessment_item_variable int [],
	join_sec boolean = FALSE
) RETURNS text AS $$
DECLARE
    itable int = 1;
    string_query_full text:='';
    n_table_names text[];
	c_n_table_name text;
    string_query_columns text;
    string_query_from text;
    r RECORD;
BEGIN
	
	SELECT ARRAY(SELECT DISTINCT table_name FROM (SELECT UNNEST($3) assessment_item_variable) aiv INNER JOIN met.cohort_inventory ci ON aiv.assessment_item_variable=ci.assessment_item_variable_id AND $1=ci.cohort_id AND $2=ci.cohortinstance_id ORDER BY table_name) INTO n_table_names;
		
	--RAISE NOTICE 'array %',array_length(n_table_names,1);
	
	string_query_columns:='CREATE OR REPLACE TEMP VIEW t_export_data AS SELECT d.*';
	string_query_from:='FROM (';
	FOREACH c_n_table_name IN ARRAY n_table_names
	LOOP
		IF itable>1 THEN string_query_from:=string_query_from || ' UNION '; END IF;
		string_query_from:=string_query_from || 'SELECT DISTINCT _stage,cohortstage.code _stage_code,_individual_identifier FROM coh.' || c_n_table_name || ',met.cohortstage WHERE ' || c_n_table_name || '._stage=cohortstage.id' ;
		itable:=itable+1;
	END LOOP;
	string_query_from:=string_query_from || ') d';

	IF join_sec 
		THEN 
			string_query_from:=string_query_from || ' LEFT OUTER JOIN t_export_data_controlled ici ON d._individual_identifier=ici.identifier AND ici.cohortinstance=' || cohortinstance || '';
			string_query_columns:=string_query_columns || ',ici.identifier_cohort _individual_identifier_cohort';
	END IF;

	--add participant (case/control) status
	string_query_from:=string_query_from || ' LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici2 ON d._individual_identifier=ici2.identifier AND ici2.cohortinstance=' || cohortinstance || '';
	string_query_columns:=string_query_columns || ',ici2.participant_type _participant_type';

	FOR r IN SELECT ci.* FROM (SELECT UNNEST($3) assessment_item_variable, generate_subscripts($3,1) rn) aiv INNER JOIN met.cohort_inventory ci ON aiv.assessment_item_variable=ci.assessment_item_variable_id AND $1=ci.cohort_id AND $2=ci.cohortinstance_id ORDER BY aiv.rn
	LOOP
		--RAISE NOTICE 'r.assessment_item_variable_id %',r.assessment_item_variable_id;
		string_query_columns := string_query_columns || ',q' || r.assessment_item_variable_id || '.' || r.column_name;
		string_query_from := string_query_from || ' LEFT OUTER JOIN LATERAL (
	SELECT _id,_time_entry,_time_assessment,_user,' || r.column_name ||' FROM coh.' || r.table_name || ' d1 where d._stage=d1._stage and d._individual_identifier=d1._individual_identifier and d1.'|| r.column_name ||' IS NOT NULL
	ORDER BY d1._time_entry desc, d1._id desc
	limit 1
	) q' || r.assessment_item_variable_id || ' ON TRUE';

	END LOOP;

	--RAISE NOTICE 'string_query_columns: %',string_query_columns;
	--RAISE NOTICE 'string_query_from: %',string_query_from;

    -- Join in shared data
	--string_query_from:=string_query_from || ' LEFT OUTER JOIN sec.';

	
	string_query_full:=string_query_full || string_query_columns || ' ' || string_query_from || '; ';

	RETURN string_query_full;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = coh, pg_temp;
ALTER FUNCTION coh._create_current_assessment_item_variable_select_query(
	cohort int,
	cohortinstance int,
	assessment_item_variable int [],
	join_sec boolean
	)
  OWNER TO "phenodb_owner";

/*SELECT * FROM coh._create_current_assessment_item_variable_select_query(
 1,
 34,
met.get_assessment_item_variables(
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1'
), 
TRUE)
 */
 

CREATE OR REPLACE FUNCTION coh._create_current_assessment_item_variable_tview
(
	cohort int,
	cohortinstance int,
	assessment_item_variable int [],
	join_sec boolean = FALSE
) RETURNS text AS $$
DECLARE
    string_query_full text:='';
BEGIN
	DROP VIEW IF EXISTS t_export_data CASCADE;
	PERFORM coh._create_current_assessment_item_variable_controlled_tview(cohortinstance);
	string_query_full:=coh._create_current_assessment_item_variable_select_query(cohort,cohortinstance,assessment_item_variable,join_sec);
	--RAISE NOTICE 'string_query_full: %',string_query_full;	
	EXECUTE string_query_full;
	GRANT SELECT ON t_export_data TO "phenodb_user";
	RETURN string_query_full;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = coh, pg_temp;
ALTER FUNCTION coh._create_current_assessment_item_variable_tview(
	cohort int,
	cohortinstance int,
	assessment_item_variable int [],
	join_sec boolean
	)
  OWNER TO "phenodb_owner";


 
--SELECT * FROM coh._create_current_assessment_item_variable_tview(1,1,ARRAY[137,138])
--SELECT * FROM coh._create_current_assessment_item_variable_tview(1,1,met.get_assessment_item_variables('covidcnsdem','1',ARRAY['dobage','ethnicorigin']));
--SELECT * FROM coh._create_current_assessment_item_variable_tview(1,1,met.get_assessment_item_variables('covidcnsdem','1',ARRAY['dobage','ethnicorigin'])
--||
--met.get_assessment_item_variables('cfq11','covidcns',ARRAY['correctworddifficultfind','feelweakweek','startsincecovid19questionrequi'])
--);
 /*SELECT * FROM coh._create_current_assessment_item_variable_tview(1,34,met.get_assessment_item_variables(
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1'
	--assessment_variable_code_original => ARRAY['dem_1.dob_age','dem_1.irish_numeric']
), TRUE);
SELECT * FROM t_export_data*/



CREATE OR REPLACE FUNCTION coh.create_current_assessment_item_variable_tview
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_full met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_original character varying(100)[] DEFAULT NULL,
	join_sec boolean = FALSE
) RETURNS text AS $$
DECLARE
    string_query_full text:='';
BEGIN
	string_query_full := coh._create_current_assessment_item_variable_tview(
		met.get_cohort($1),
		met.get_cohortinstance($1,$2),
		met.get_assessment_item_variables(
			assessment_code => $3,
			assessment_version_code => $4,
			assessment_item_code => $5,
			assessment_variable_code_full => $6,
			assessment_variable_code_original => $7
				),
			join_sec => $8
	);
	RETURN string_query_full;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION coh.create_current_assessment_item_variable_tview(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc[],
	assessment_variable_code_full met.varcharcodeletnum_lc[],
	assessment_variable_code_original character varying(100)[],
	join_sec boolean
	)
  OWNER TO "phenodb_coworker";
/*
SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	join_sec => TRUE
);
SELECT * FROM t_export_data;

SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'radrep',
	assessment_version_code => '1'
	--join_sec => TRUE
);
SELECT * FROM t_export_data;
*/

/*
SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'radrep',
	assessment_version_code => '1'
--	assessment_item_code => ARRAY['followingqualificationsdoyou','ethnicorigin']
--	--assessment_variable_code_full => NULL,
--	--assessment_variable_code_original => NULL
);
SELECT * FROM t_export_data;
*/
 
CREATE OR REPLACE FUNCTION met._select_assessment_item_variable_meta
(
	cohort int,
	cohortinstance int,
	assessment_item_variable int [] DEFAULT '{}'
) RETURNS TABLE (assessment_id int, assessment_item_id int, assessment_item_variable_id int, assessment_code text, assessment_version_code text, assessment_item_code text, assessment_item_variable_code text, assessment_item_variable_code_full text, variable_alt_code text, variable_original_descriptor text, variable_name text, udt_name text, variable_index int, variable_text text, variable_alt_text text, variable_unit text, variable_documentation text)
AS $$
	SELECT ci.assessment_id, ci.assessment_item_id, ci.assessment_item_variable_id, ass.code, ass.version_code, ci.assessment_item_code, ci.assessment_item_variable_code, met.construct_cohortinstance_column_name(ci.assessment_item_code,ci.assessment_item_variable_code) assessment_item_variable_code_full, aiv.variable_alt_code,  ci.variable_original_descriptor, aiv.variable_name, ci.udt_name, aiv.variable_index, aiv.variable_text, aiv.variable_alt_text, aiv.variable_unit, aiv.documentation 
	FROM met.select_cohort_inventory() ci 
	INNER JOIN met.assessment_item_variable aiv ON ci.assessment_item_variable_id = aiv.id
	INNER JOIN met.assessment ass ON ci.assessment_id = ass.id
	WHERE ci.cohort_id = $1 AND ci.cohortinstance_id = $2 AND (cardinality($3)<1 OR ci.assessment_item_variable_id = ANY($3));
$$ LANGUAGE sql;
ALTER FUNCTION met._select_assessment_item_variable_meta(
	cohort int,
	cohortinstance int,
	assessment_item_variable int []
	)
  OWNER TO "phenodb_coworker";

/*
SELECT * FROM met._select_assessment_item_variable_meta(1,34);

SELECT * FROM met._select_assessment_item_variable_meta(1,34,met.get_assessment_item_variables(
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1'
	--assessment_variable_code_original => ARRAY['dem.year','dem.polish_numeric']
));

SELECT * FROM met._select_assessment_item_variable_meta(1,34,met.get_assessment_item_variables(
	assessment_code => 'covidcnsncrf',
	assessment_version_code => 'm1'
	--assessment_variable_code_original => ARRAY['dem.year','dem.polish_numeric']
));
*/
 
CREATE OR REPLACE FUNCTION met.select_assessment_item_variable_meta
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_version_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_item_code met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_full met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_original character varying(100)[] DEFAULT NULL
) RETURNS TABLE (assessment_id int, assessment_item_id int, assessment_item_variable_id int, assessment_code text, assessment_version_code text, assessment_item_code text, assessment_item_variable_code text, assessment_item_variable_code_full text, variable_alt_code text, variable_original_descriptor text, variable_name text, udt_name text, variable_index int, variable_text text, variable_alt_text text, variable_unit text, variable_documentation text)
AS $$
	SELECT * FROM met._select_assessment_item_variable_meta(
		met.get_cohort($1),
		met.get_cohortinstance($1,$2),
		met.get_assessment_item_variables(
			assessment_code => $3,
			assessment_version_code => $4,
			assessment_item_code => $5,
			assessment_variable_code_full => $6,
			assessment_variable_code_original => $7
			)
			);
$$ LANGUAGE sql;
ALTER FUNCTION met.select_assessment_item_variable_meta(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc[],
	assessment_variable_code_full met.varcharcodeletnum_lc[],
	assessment_variable_code_original character varying(100)[]
	)
  OWNER TO "phenodb_coworker";
/* 
SELECT * FROM met.select_assessment_item_variable_meta(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'radrep',
	assessment_version_code => '1'
--	assessment_item_code => ARRAY['followingqualificationsdoyou','ethnicorigin']
--	--assessment_variable_code_full => NULL,
--	--assessment_variable_code_original => NULL
);
*/
 
CREATE OR REPLACE FUNCTION met._select_assessment_item_meta
(
	cohort int,
	cohortinstance int,
	assessment_item int [] DEFAULT '{}'
) RETURNS TABLE (assessment_id int, assessment_item_id int, assessment_item_type int, assessment_code text, assessment_version_code text, assessment_item_type_code text, assessment_item_code text, item_original_descriptor text, item_name text, item_index int, item_text text, item_documentation text)
AS $$
	SELECT ass.id, ai.id, ai.assessment_item_type, ass.code, ass.version_code, ait.code, ai.item_code, ai.item_original_descriptor, ai.item_name, ai.item_index, ai.item_text, ai.documentation 
	FROM (SELECT DISTINCT(ci.assessment_item_id) FROM met.select_cohort_inventory() ci WHERE ci.cohort_id = $1 AND ci.cohortinstance_id = $2) cii 
	INNER JOIN met.assessment_item ai ON cii.assessment_item_id = ai.id
	INNER JOIN met.assessment_item_type ait ON ai.assessment_item_type = ait.id
	INNER JOIN met.assessment ass ON ai.assessment = ass.id
	WHERE (cardinality($3)<1 OR ai.id = ANY($3));
$$ LANGUAGE sql;
ALTER FUNCTION met._select_assessment_item_meta(
	cohort int,
	cohortinstance int,
	assessment_item int []
	)
  OWNER TO "phenodb_coworker";
 
/* 
SELECT * FROM met._select_assessment_item_meta(1,34);
 */
 
CREATE OR REPLACE FUNCTION met.select_assessment_item_meta
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_version_code met.varcharcodeletnum_lc DEFAULT NULL,
	assessment_item_code met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_full met.varcharcodeletnum_lc[] DEFAULT NULL,
	assessment_variable_code_original character varying(100)[] DEFAULT NULL
) RETURNS TABLE (assessment_id int, assessment_item_id int, assessment_item_type int, assessment_code text, assessment_version_code text, assessment_item_type_code text, assessment_item_code text, item_original_descriptor text, item_name text, item_index int, item_text text, item_documentation text)
AS $$
	SELECT * FROM met._select_assessment_item_meta(
		met.get_cohort($1),
		met.get_cohortinstance($1,$2),
		ARRAY(
			SELECT DISTINCT(aiv.assessment_item) FROM met.get_assessment_item_variables(
				assessment_code => $3,
				assessment_version_code => $4,
				assessment_item_code => $5,
				assessment_variable_code_full => $6,
				assessment_variable_code_original => $7
				) iv INNER JOIN met.assessment_item_variable aiv ON aiv.id = ANY(iv)
			)
			);
$$ LANGUAGE sql;
ALTER FUNCTION met.select_assessment_item_meta(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	assessment_item_code met.varcharcodeletnum_lc[],
	assessment_variable_code_full met.varcharcodeletnum_lc[],
	assessment_variable_code_original character varying(100)[]
	)
  OWNER TO "phenodb_coworker";

 /*
SELECT * FROM met.select_assessment_item_meta(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'radrep',
	assessment_version_code => '1'
--	assessment_item_code => ARRAY['followingqualificationsdoyou','ethnicorigin']
--	--assessment_variable_code_full => NULL,
--	--assessment_variable_code_original => NULL
);
 */
 
/* 
SELECT * FROM met.select_assessment_item_meta(
	cohort_code => 'covidcns',
	instance_code => '2023'
);
*/
 
CREATE OR REPLACE FUNCTION coh.create_template_temporary_variable_annotation_table
(
	schema_name met.varcharcodesimple,
	table_name met.varcharcodesimple
)
RETURNS int AS $$
DECLARE
    toreturn text = NULL;
   	string_query text;
BEGIN
	
	DROP TABLE IF EXISTS t_import_data_assessment_variable_annotation; --CASCADE;
	CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_variable_annotation AS
	SELECT
	column_name,
	'' variable_code,
	column_name variable_original_descriptor,
	column_name variable_label,
	ordinal_position variable_index,
	data_type variable_data_type,
	regexp_replace(LOWER(column_name),'[^abcdefghijklmnopqrstuvwxyz1234567890]','','g') item_code,
	'' variable_documentation,
	NULL variable_unit
	FROM 
	information_schema.tables
	INNER JOIN information_schema.columns ON columns.table_catalog=tables.table_catalog AND columns.table_schema=tables.table_schema AND columns.table_name=tables.table_name
	WHERE tables.table_catalog='phenodb' AND tables.table_schema=LOWER($1) AND tables.table_name=LOWER($2);
	GRANT ALL ON TABLE t_import_data_assessment_variable_annotation TO "phenodb_coworker";

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION coh.create_template_temporary_variable_annotation_table(
	schema_name met.varcharcodesimple,
	table_name met.varcharcodesimple
	)
  OWNER TO "phenodb_coworker";
 
--SELECT * FROM coh.create_template_temporary_variable_annotation_table('tng2215','covid_cns_liverpool_xnat_report');
--SELECT * FROM t_import_data_assessment_variable_annotation;

--This now needs a variable annotation table
CREATE OR REPLACE FUNCTION coh.prepare_import
(
	cohort_code met.varcharcodeletnum_lc,
	instance_code met.varcharcodeletnum_lc,
	assessment_code met.varcharcodeletnum_lc,
	assessment_version_code met.varcharcodeletnum_lc,
	table_name met.varcharcodesimple,
	cohort_id_column_name met.varcharcodesimple DEFAULT NULL,
	variable_annotation_table_name met.varcharcodesimple DEFAULT NULL,
	item_annotation_table_name met.varcharcodesimple DEFAULT NULL
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
	
	DROP TABLE IF EXISTS t_prepare_import_data_settings CASCADE;
	CREATE TEMP TABLE t_prepare_import_data_settings AS
	SELECT
		var_cohortinstance_id cohortinstance_id,
		var_assessment_id assessment_id,
		$5 table_name,
		$6 cohort_id_column_name
	;
	GRANT ALL ON TABLE t_prepare_import_data_settings TO "phenodb_coworker";
	SELECT COUNT(t_prepare_import_data_settings.*) INTO toreturn FROM t_prepare_import_data_settings;
	RAISE NOTICE 'nrows t_prepare_import_data_settings (THIS SHOULD BE POSITIVE - OTHERWISE YOU MAY HAVE PRIVILEGE OR PATH PROBLEMS) %',toreturn;
	
	/*
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
	*/
	
	--set permission to right user group
	string_query:= 'GRANT ALL ON TABLE ' || table_name || ' TO "phenodb_coworker" ';
	EXECUTE string_query;
	
	IF variable_annotation_table_name IS NOT NULL
	THEN
		DROP TABLE IF EXISTS t_import_data_assessment_variable_annotation; --CASCADE;
		string_query:= 'CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_variable_annotation AS SELECT * FROM ' || variable_annotation_table_name ;
		EXECUTE string_query;
	/*
	ELSE
		CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_variable_annotation AS
		SELECT NULL variable_code, NULL variable_original_descriptor, NULL item_code;
		*/
		GRANT ALL ON TABLE t_import_data_assessment_variable_annotation TO "phenodb_coworker";
	END IF;
	SELECT COUNT(t_import_data_assessment_variable_annotation.*) INTO toreturn FROM t_import_data_assessment_variable_annotation;
	RAISE NOTICE 'nrows t_import_data_assessment_variable_annotation (THIS SHOULD BE POSITIVE - OTHERWISE YOU MAY HAVE PRIVILEGE OR PATH PROBLEMS) %',toreturn;
	

	IF item_annotation_table_name IS NOT NULL
	THEN
		DROP TABLE IF EXISTS t_import_data_assessment_item_annotation; --CASCADE;
		string_query:= 'CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_item_annotation AS SELECT * FROM ' || item_annotation_table_name ;
		EXECUTE string_query;
	/*
	ELSE
		CREATE TEMP TABLE IF NOT EXISTS t_import_data_assessment_item_annotation AS
		SELECT NULL item_index, NULL item_code, NULL assessment_type_code, NULL assessment_item_type_code, NULL item_text, NULL item_documentation;
		*/
		GRANT ALL ON TABLE t_import_data_assessment_item_annotation TO "phenodb_coworker";
	END IF;

	--TODO - ADD CUSTOM SCHEMA CHOICE 
	DROP VIEW IF EXISTS t_import_data_meta; --CASCADE;
	CREATE OR REPLACE TEMP VIEW t_import_data_meta AS
	SELECT
		LOWER(van.item_code) assessment_item_code,
		LOWER(van.variable_code) assessment_item_variable_code,
		van.variable_original_descriptor,
		van.variable_label,
		van.variable_index,
		van.variable_documentation,
		van.variable_unit,
		van.variable_data_type,
		isettings.cohortinstance_id,
		isettings.assessment_id,
		inv.table_schema n_table_schema, inv.table_name n_table_name, inv.column_name n_column_name, inv.variable_original_descriptor n_variable_original_descriptor, inv.data_type n_data_type, inv.assessment_item_code n_assessment_item_code, inv.assessment_item_variable_code n_assessment_item_variable_code, inv.assessment_item_variable_id n_assessment_item_variable_id,
		(columns.column_name = isettings.cohort_id_column_name) is_cohort_id,
		(van.variable_original_descriptor = inv.variable_original_descriptor OR van.variable_original_descriptor IS NULL OR inv.variable_original_descriptor IS NULL) variable_original_descriptor_check,
		(columns.data_type = inv.data_type OR inv.data_type IS NULL) data_type_check,
		columns.*
	FROM t_import_data_assessment_variable_annotation van
	INNER JOIN t_prepare_import_data_settings isettings ON TRUE
	INNER JOIN information_schema.tables ON tables.table_catalog='phenodb' AND tables.table_name=LOWER(isettings.table_name)
	INNER JOIN pg_namespace ns ON ns.oid = pg_my_temp_schema() AND tables.table_schema = ns.nspname --tables.table_type='LOCAL TEMPORARY'
	INNER JOIN information_schema.columns ON columns.table_catalog=tables.table_catalog AND columns.table_schema=tables.table_schema AND columns.table_name=tables.table_name AND columns.column_name=van.column_name
	LEFT OUTER JOIN met.select_cohort_inventory() inv ON inv.cohortinstance_id=isettings.cohortinstance_id AND inv.assessment_id=isettings.assessment_id AND LOWER(van.item_code)=inv.assessment_item_code AND (LOWER(van.variable_code) = inv.assessment_item_variable_code OR (van.variable_code IS NULL AND inv.assessment_item_variable_code IS NULL))
	ORDER BY assessment_id,cohortinstance_id,assessment_item_code,assessment_item_variable_code;
	GRANT SELECT ON t_import_data_meta TO "phenodb_coworker";
	SELECT COUNT(t_import_data_meta.*) INTO toreturn FROM t_import_data_meta;
	RAISE NOTICE 'nrows t_import_data_meta (THIS SHOULD BE POSITIVE - OTHERWISE YOU MAY HAVE PRIVILEGE OR PATH PROBLEMS) %',toreturn;
	
	--TODO: The duplicate ordering is fishy
	DROP VIEW IF EXISTS t_import_data_meta_selected; --CASCADE;
	CREATE OR REPLACE TEMP VIEW t_import_data_meta_selected AS
	WITH mord AS(SELECT * FROM t_import_data_meta ORDER BY data_type_check DESC, variable_original_descriptor_check DESC, ordinal_position)
	SELECT DISTINCT ON (mord.assessment_item_code, mord.assessment_item_variable_code, mord.column_name)
		mord.*,
		(mord.is_cohort_id OR mord.is_cohort_id) meta --check for meta-type columns, it should look like this for now - add more conditions when needed
	FROM mord
	ORDER BY assessment_item_code,assessment_item_variable_code, column_name;
	GRANT SELECT ON t_import_data_meta_selected TO "phenodb_coworker";
	SELECT COUNT(t_import_data_meta_selected.*) INTO toreturn FROM t_import_data_meta_selected;
	RAISE NOTICE 'nrows t_import_data_meta_selected (THIS SHOULD BE POSITIVE - OTHERWISE YOU MAY HAVE PRIVILEGE OR PATH PROBLEMS) %',toreturn;
	
	CREATE OR REPLACE TEMP VIEW t_import_data_assessment_item_stats AS
	SELECT
	m.assessment_item_code,
	COUNT(m.column_name) count_var,
	COUNT(CASE WHEN m.n_column_name IS NOT NULL THEN assessment_item_variable_code END) count_annotated_var,
	COUNT(CASE WHEN m.data_type IN ('integer','smallint','serial','smallserial') THEN assessment_item_variable_code END) count_datatype_integer,
	COUNT(CASE WHEN m.data_type IN ('double precision','real') THEN assessment_item_variable_code END) count_datatype_float,
	COUNT(CASE WHEN m.data_type IN ('text','character varying','character') THEN assessment_item_variable_code END) count_datatype_text,
	COUNT(CASE WHEN m.data_type IN ('boolean') THEN assessment_item_variable_code END) count_datatype_boolean,
	COUNT(CASE WHEN m.data_type IN ('timestamp','timestamp with time zone','time') THEN assessment_item_variable_code END) count_datatype_time
	FROM t_import_data_meta_selected m
	WHERE m.meta = FALSE
	GROUP BY m.assessment_item_code
	ORDER BY m.assessment_item_code;
	GRANT SELECT ON t_import_data_assessment_item_stats TO "phenodb_coworker";
	
	CREATE OR REPLACE TEMP VIEW t_import_data_assessment_item_variable_stats AS
	SELECT
	m.assessment_item_code,
	m.assessment_item_variable_code,
	m.variable_original_descriptor,
	m.variable_label,
	m.variable_index,
	m.variable_documentation,
	m.variable_unit,
	m.variable_data_type,
	m.column_name,
	m.data_type,
	(m.n_column_name IS NOT NULL) annotated
	FROM t_import_data_meta_selected m
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
	cohort_id_column_name met.varcharcodesimple,
	variable_annotation_table_name met.varcharcodesimple,
	item_annotation_table_name met.varcharcodesimple
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
--TODO - Chnages to the annotation part is ongoing!! WIP!!
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
	do_insert boolean DEFAULT FALSE
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
	SELECT ARRAY(SELECT column_name FROM t_import_data_meta_selected WHERE t_import_data_meta_selected.is_cohort_id =TRUE ORDER BY t_import_data_meta_selected.ordinal_position) INTO cohort_id_columns;
	c_cohort_id_column:=cohort_id_columns[1];
	
	string_query := 'CREATE OR REPLACE TEMP VIEW t_src_individual AS SELECT src.*, src."' || c_cohort_id_column || '" _spid, ici.identifier _individual_identifier FROM ' || table_name || ' src ' || ' LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici ON (src."' || c_cohort_id_column || '"=ici.identifier_cohort OR src."' || c_cohort_id_column || '"=ici.identifier::text) AND ici.cohortinstance=' || var_cohortinstance_id || ' LEFT OUTER JOIN sec.individual i ON ici.individual=i.id';
	--RAISE NOTICE 'Q: %',string_query;
	EXECUTE string_query;

	--fallback/template annotation - --TODO - SEPARATE THE ANNOTATION TABLES FROM THE STATS-VIEWS!
	IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE tables.table_catalog='phenodb' AND tables.table_name='t_import_data_assessment_item_annotation') -- AND tables.table_type='LOCAL_TEMPORARY' AND NOT EXISTS (SELECT FROM t_import_data_assessment_item_annotation)
	THEN
		DROP TABLE IF EXISTS t_import_data_assessment_item_annotation; --CASCADE;
		CREATE TEMP TABLE t_import_data_assessment_item_annotation AS
		SELECT istats.assessment_item_code item_code,
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
	END IF;
	
	IF do_annotate = FALSE AND EXISTS (SELECT 1 n_column_name FROM t_import_data_meta_selected WHERE t_import_data_meta_selected.n_column_name IS NULL AND t_import_data_meta_selected.meta IS FALSE)
	THEN
		RAISE NOTICE 'Unknown columns present in the imported data.'
      		USING HINT = 'Please add and annotate all assessment item variables that are to be imported into the database.';
		RETURN -1;
	END IF;
	
	
	IF do_annotate
	THEN
		--TODO - AFTER SEPARATING THE VARIABLE ANNOTATION TABLE FROM THE STATS VIEW ABOVE, JOIN IN THE ANNOTATION TABLES HERE
		--add items
		FOR r IN 
		SELECT * FROM 
		t_import_data_assessment_item_stats istats 
		INNER JOIN t_import_data_assessment_item_annotation a 
		ON istats.assessment_item_code=a.item_code WHERE istats.count_annotated_var < istats.count_var
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
				documentation => CASE 
									WHEN r.item_documentation IS NULL THEN ''
									ELSE r.item_documentation END
			);
		END LOOP;
		
		--add item variables and cohort table columns
		FOR r IN 
		SELECT * FROM 
		t_import_data_assessment_item_variable_stats vstats --the business variables
		INNER JOIN t_import_data_assessment_variable_annotation a
		ON vstats.column_name=a.column_name 
		WHERE vstats.annotated = FALSE
		LOOP
			RAISE NOTICE 'cohort_code %',cohort_code;
			RAISE NOTICE 'instance_code %',instance_code;
			RAISE NOTICE 'assessment_version_code %',assessment_version_code;
			RAISE NOTICE 'r.assessment_item_code %',r.assessment_item_code;
			RAISE NOTICE 'r.assessment_item_variable_code %',r.assessment_item_variable_code;
			RAISE NOTICE 'r.variable_original_descriptor %',CAST(r.column_name AS character varying);
			RAISE NOTICE 'r.variable_index %',CAST(r.variable_index AS int);
			RAISE NOTICE 'r.variable_data_type %',r.variable_data_type;
			RAISE NOTICE 'r.data_type %',r.data_type;
			PERFORM met._create_assessment_item_variable_ignoresert
			(
				assessment_item => CAST(met._get_assessment_item(var_assessment_id,r.assessment_item_code) AS integer),
				variable_code => CASE 
									WHEN r.assessment_item_variable_code IS NULL THEN ''
									ELSE CAST(r.assessment_item_variable_code AS met.varcharcodesimple_lc) END,
				variable_original_descriptor => CAST(r.variable_original_descriptor AS character varying),
				variable_index => CAST(r.variable_index AS int),
				variable_name => CASE 
									WHEN r.variable_label IS NOT NULL THEN CAST(r.variable_label AS character varying)
									ELSE CAST(r.assessment_item_variable_code AS character varying) END,
				variable_unit => CAST(r.variable_unit AS character varying),
				documentation => CASE 
									WHEN r.variable_documentation IS NULL THEN ''
									ELSE CAST(r.variable_documentation AS character varying) END
			);
			PERFORM coh.create_cohortinstance_table_column(cohort_code,instance_code,assessment_code,assessment_version_code,r.assessment_item_code,r.assessment_item_variable_code,CASE WHEN r.variable_data_type IS NULL THEN r.data_type ELSE r.variable_data_type END); -- Use the annotated datatype to allow for setting final datatype through annotation.
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
		SELECT ARRAY(SELECT DISTINCT n_table_name FROM t_import_data_meta_selected WHERE t_import_data_meta_selected.meta =FALSE) INTO n_table_names;
		

		RAISE NOTICE 'array %',array_length(n_table_names,1);
		RAISE NOTICE 'c_cohort_id_column %',c_cohort_id_column;

		FOREACH c_n_table_name IN ARRAY n_table_names LOOP
			RAISE NOTICE 'n_table_name %',c_n_table_name;

			string_target_column_names:='_stage,_user,_time_assessment,_individual_identifier';
			string_source_column_names:= E'\'' || var_cohortstage_id || E'\'';
			string_source_column_names:=string_source_column_names || ','  || E'\'' || session_user || E'\'';
			string_source_column_names:=string_source_column_names || ','  || E'\'' || now() || E'\''; 
			string_source_column_names:=string_source_column_names || ',src._individual_identifier';

			FOR r IN SELECT * FROM t_import_data_meta_selected v
			INNER JOIN t_import_data_assessment_variable_annotation a ON v.column_name=a.column_name 
			WHERE v.n_table_name=c_n_table_name AND v.n_column_name IS NOT NULL
			LOOP
				string_target_column_names:=string_target_column_names || ',' || r.n_column_name;
				string_source_column_names:=string_source_column_names || ',CAST("' || r.column_name || '" AS '|| (CASE WHEN r.variable_data_type IS NULL THEN r.data_type ELSE r.variable_data_type END) ||')';
			END LOOP;
		
			--RAISE NOTICE 'STCN-string: %',string_target_column_names;
			--RAISE NOTICE 'STSN-string: %',string_source_column_names;

			string_query := 'INSERT INTO coh.' || c_n_table_name || '(' || string_target_column_names || ')' || ' SELECT ' || string_source_column_names || ' FROM t_src_individual src WHERE src._individual_identifier IS NOT NULL';
			--RAISE NOTICE 'Q: %',string_query;
			EXECUTE string_query;
		END LOOP;
	END IF;

	--CLEANUP!! this was still connected to the temporary import tables
	DROP VIEW IF EXISTS t_src_individual;
	
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
	do_insert boolean
	)
  OWNER TO "phenodb_owner";
 
 --SELECT * FROM coh.create_cohortinstance_table_column('covidcns','2022','idpukbb','2022','braincogx',NULL,'double precision');

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
 --SELECT * FROM t_import_data_meta_selected;
 --SELECT * FROM t_import_data_assessment_item_stats;
 --SELECT * FROM t_import_data_assessment_item_variable_stats;
 -- DROP TABLE t_import_data_assessment_item_annotation
-- SELECT * FROM t_import_data_assessment_item_annotation;
--SELECT * FROM t_src_individual;
 
 --DELETE FROM coh.covidcns_2021_atest_1_1;
 
 
 --DROP FUNCTION met.get_phenotype;
CREATE OR REPLACE FUNCTION met.get_summary
(
	sort_code met.varcharcodeletnum_uc,
	sort_counter met.intpos,
	summary_type met.varcharcodesimple_lc
) RETURNS int AS $$
DECLARE
    nid int = NULL;
BEGIN
	--use $ -notation if there is a collision between argument names and column names
	SELECT id INTO nid FROM met.summary WHERE sort_code=$1 AND sort_counter = $2 AND summary_type = $3;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
--SECURITY DEFINER
--SET search_path = met, pg_temp;
ALTER FUNCTION met.get_summary(
	sort_code met.varcharcodeletnum_uc,
	sort_counter met.intpos,
	summary_type met.varcharcodesimple_lc)
  OWNER TO "phenodb_coworker";
 
 --HERE!!!! NOT FINISHED!!
 /*
CREATE OR REPLACE FUNCTION sum.create_gwas_ignoresert
(
	sort_code met.varcharcodeletnum_uc,
	sort_counter met.intpos,
	phenotype_code 
	name character varying,
	sex met.sex,
	is_meta_analysis boolean,
	
	documentation character varying DEFAULT ''
) RETURNS int AS $$
DECLARE
    nid int = -1;
BEGIN
	
	SELECT 1 id INTO nid FROM met.phenotype WHERE phenotype.code=$2 AND phenotype.phenotype_type=$3;
	
	IF nid IS NULL
	THEN
		INSERT INTO met.phenotype(name,code,phenotype_type,documentation) VALUES($1,$2,$3,$4) RETURNING id INTO nid;
	END IF;
	RETURN nid;
END;
$$ LANGUAGE plpgsql;
ALTER FUNCTION met.create_phenotype_ignoresert(
	name character varying(100),
	code met.varcharcodeletnum_lc,
	phenotype_type met.varcharcodesimple_lc,
	documentation character varying
	)
  OWNER TO "phenodb_coworker"; 
 */
