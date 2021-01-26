BEGIN TRANSACTION;

--CREATE TYPE met.assessment_type AS ENUM ('q','si');
CREATE DOMAIN met.intpos AS integer CHECK (VALUE >= 0);
CREATE DOMAIN met.intoneindex AS integer CHECK (VALUE > 0);
CREATE DOMAIN met.intyearmodern AS integer CHECK (VALUE >= 1900 AND VALUE <=2199);
CREATE DOMAIN met.varcharcodeletnum AS character varying(100) CHECK (VALUE ~* '^[A-Za-z0-9]+');
CREATE DOMAIN met.varcharcodeletnum_lc AS character varying(100) CHECK (VALUE ~* '^[a-z0-9]+');
CREATE DOMAIN met.varcharcodeletnum_uc AS character varying(100) CHECK (VALUE ~* '^[A-Z0-9]+');
CREATE DOMAIN met.varcharcodesimple AS character varying(100) CHECK (VALUE ~* '^[A-Za-z0-9_\-\.]+');
CREATE DOMAIN met.varcharcodesimple_lc AS character varying(100) CHECK (VALUE ~* '^[a-z0-9_\-\.]+');
CREATE DOMAIN met.varcharcodesimple_uc AS character varying(100) CHECK (VALUE ~* '^[A-Z0-9_\-\.]+');


-- DROP TABLE met.assessment_type;
CREATE TABLE met.assessment_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL,
    CONSTRAINT assessment_type_pkey PRIMARY KEY (code),
    CONSTRAINT assessment_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.assessment_type IS 'The types of assessments defined in and referred to throughout the database.';

-- DROP TABLE met.assessment_item_type;
CREATE TABLE met.assessment_item_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL,
    CONSTRAINT assessment_item_type_pkey PRIMARY KEY (code),
    CONSTRAINT assessment_item_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.assessment_item_type IS 'The types of assessment items defined in and referred to throughout the database.';

-- DROP TABLE met.assessment;
CREATE TABLE met.assessment
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    version_year met.intyearmodern,
    version_major_integer met.intpos,
    version_minor_integer met.intpos,
    version_string met.varcharcodeletnum_lc,
    name character varying NOT NULL,
    assessment_type met.varcharcodesimple_lc NOT NULL,
    documentation character varying NOT NULL,
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT assessment_pkey PRIMARY KEY (_id),
    CONSTRAINT assessment_assessment_type_fk FOREIGN KEY (assessment_type) REFERENCES met.assessment_type(code)
);
COMMENT ON TABLE met.assessment IS 'Assessments defined in and referred to throughout the database.';
CREATE UNIQUE INDEX assessment_u_version_null_code ON met.assessment (code) WHERE version_year IS NULL AND version_major_integer IS NULL AND version_minor_integer IS NULL AND version_string IS NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_version_string ON met.assessment (code,version_string) WHERE version_string IS NOT NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_year ON met.assessment (code,version_year) WHERE version_year IS NOT NULL AND version_major_integer IS NULL AND version_minor_integer IS NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_major ON met.assessment (code,version_major_integer) WHERE version_year IS NULL AND version_major_integer IS NOT NULL AND version_minor_integer IS NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_major_minor ON met.assessment (code,version_major_integer,version_minor_integer) WHERE version_year IS NULL AND version_major_integer IS NOT NULL AND version_minor_integer IS NOT NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_year_major ON met.assessment (code,version_year,version_major_integer) WHERE version_year IS NOT NULL AND version_major_integer IS NOT NULL AND version_minor_integer IS NULL;
CREATE UNIQUE INDEX assessment_u_version_null_code_year_major_minor ON met.assessment (code,version_year,version_major_integer,version_minor_integer) WHERE version_year IS NOT NULL AND version_major_integer IS NOT NULL AND version_minor_integer IS NOT NULL;

-- DROP TABLE met.cohort;
CREATE TABLE met.cohort
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    name character varying NOT NULL,
	location_descriptor met.varcharcodesimple NOT NULL,
    documentation character varying NOT NULL,
	time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohort_pkey PRIMARY KEY (_id),
    CONSTRAINT cohort_code_u UNIQUE (code)
);
COMMENT ON TABLE met.cohort IS 'Cohorts referred to throughout the database.';


-- DROP TABLE met.cohortinstance;
CREATE TABLE met.cohortinstance
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohort integer NOT NULL,
	code met.varcharcodeletnum_lc NOT NULL,
	time_extraction TIMESTAMP WITH TIME ZONE NOT NULL,
    documentation character varying NOT NULL,
	time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortinstance_pkey PRIMARY KEY (_id),
    CONSTRAINT cohortinstance_cohort_fk FOREIGN KEY (cohort) REFERENCES met.cohort (_id)
);
COMMENT ON TABLE met.cohortinstance IS 'Instances of cohort data referring to specific phenotype data tables in the database for the assessments made.';
CREATE UNIQUE INDEX cohortinstance_cohort_code_u ON met.cohortinstance (cohort,code);

-- DROP TABLE met.cohortinstance_assessment_item;
CREATE TABLE met.cohortinstance_assessment_item
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohortinstance integer NOT NULL,
    assessment integer NOT NULL,
    item_descriptor met.varcharcodeletnum_lc NOT NULL,
    item_original_descriptor character varying(100) NOT NULL,
    item_original_name character varying NOT NULL,
    item_index met.intoneindex NOT NULL,
    assessment_item_type met.varcharcodeletnum_lc NOT NULL,
    item_text character varying NOT NULL,
    documentation character varying NOT NULL,
    CONSTRAINT cohortinstance_assessment_item_pkey PRIMARY KEY (_id),
    CONSTRAINT cohortinstance_assessment_item_assessment_item_type_fk FOREIGN KEY (assessment_item_type) REFERENCES met.assessment_item_type (code)
);
COMMENT ON TABLE met.cohortinstance_assessment_item IS 'Describes cohortinstance assessment items(can contain multiple variables/columns).';
CREATE UNIQUE INDEX cohortinstance_assessment_item_cohortinstance_assessment_item_descriptor_u ON met.cohortinstance_assessment_item (cohortinstance,assessment,item_descriptor);

-- DROP TABLE met.cohortinstance_assessment_item_variable;
CREATE TABLE met.cohortinstance_assessment_item_variable
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohortinstance_assessment_item integer NOT NULL,
    variable_descriptor met.varcharcodeletnum_lc NOT NULL,
    variable_original_descriptor character varying(100),
    variable_min integer,
    variable_max integer,
    variable_alt_int integer[],
    variable_alt_string character varying(100)[],
    CONSTRAINT cohortinstance_assessment_item_variable_pkey PRIMARY KEY (_id),
    CONSTRAINT cohortinstance_assessment_item_variable_cohortinstance_assessment_item_fk FOREIGN KEY (cohortinstance_assessment_item) REFERENCES met.cohortinstance_assessment_item(_id)
);
COMMENT ON TABLE met.cohortinstance_assessment_item_variable IS 'Describes variables relating to each assessment item in a cohortinstance extraction and a table column in a corresponding phenotypic data table.';
CREATE UNIQUE INDEX cohortinstance_assessment_item_variable_cohortinstance_assessment_item_variable_descriptor_u ON met.cohortinstance_assessment_item_variable (cohortinstance_assessment_item,variable_descriptor);

/*
 * Convention for item columns in data tables:
 * [ITEM_CODE]_[ITEM_VARIABLE_SUB_CODE]
 * 
 * Columns with underscore in front are special purpose non-data item meta columns, for example the _id column used for row id in the table.
 */

/*
 * A template and test phenotype data concept table.
 */
-- DROP TABLE phe.tassessment_tcohort_tcohortinstance;
CREATE TABLE phe.tassessment_tcohort_tcohortinstance
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    spid character varying(9) NOT NULL,
    sex integer NOT NULL,
    var_time timestamp with time zone,
    var_alt_single1 integer,
    var_alt_single1_comment character varying(600),
   	var_alt_multi1 integer[],
   	--var_alt_multi1_selection integer[5], --boolean encoding 0 - false, 1 - true, BUT expanded with space for additional codes
    var_alt_multi1_comment character varying(600)[],
    CONSTRAINT tassessment_tcohort_tcohortinstance_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE phe.tassessment_tcohort_tcohortinstance IS 'Template and test concept table.';

--INSERT INTO phe.tassessment_tcohort_tcohortinstance(spid,sex,varTime,varAltSingle1,varAltSingle1_comment,varAltMulti1,varAltMulti1_comment) VALUES('QQ19139',1,'2020-01-03 04:05:06+02',3,'Other choice','{1,3,4}','{NULL,NULL,"A comment. Some text."}')



COMMIT;






