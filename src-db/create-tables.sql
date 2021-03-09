
BEGIN TRANSACTION;

-- DROP TABLE met.reference;
CREATE TABLE met.reference
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    doi character varying(100) NOT NULL,
    pmid character varying(8),
    year met.intyearmodern NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT reference_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE met.reference IS 'References to publications.';
CREATE UNIQUE INDEX reference_u ON met.reference (doi);

CREATE TABLE IF NOT EXISTS met.country (
  idnum integer NOT NULL,
  iso met.countryiso_uc NOT NULL,
  name varchar(80) NOT NULL,
  nicename varchar(80) NOT NULL,
  iso3 char(3),
  numcode integer,
  phonecode integer NOT NULL,
  CONSTRAINT country_pkey PRIMARY KEY (iso),
  CONSTRAINT country_idnum_u UNIQUE (idnum)
);

-- DROP TABLE met.population;
CREATE TABLE met.population
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT population_pkey PRIMARY KEY (code),
    CONSTRAINT population_code_u UNIQUE (code)
);
COMMENT ON TABLE met.population IS 'The populations referred to throughout the database for ancestry purposes or other. Initially includes groupings based on the NHGRI-EBI GWAS Catalog standard as well as the HapMap 3 populations but can be expanded beyond.';

-- DROP TABLE met.phenotype_type;
CREATE TABLE met.phenotype_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT phenotype_type_pkey PRIMARY KEY (code),
    CONSTRAINT phenotype_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.phenotype_type IS 'The primary unique types of phenotypes/traits referred to throughout the database.';

-- DROP TABLE met.phenotype_category;
CREATE TABLE met.phenotype_category
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT phenotype_category_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE met.phenotype_category IS 'Categories of phenotypes/traits referred to throughout the database.';

-- DROP TABLE met.phenotype;
CREATE TABLE met.phenotype
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    name character varying NOT NULL,
    phenotype_type met.varcharcodesimple_lc NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
    CONSTRAINT phenotype_pkey PRIMARY KEY (id),
    CONSTRAINT phenotype_phenotype_type_fk FOREIGN KEY (phenotype_type) REFERENCES met.phenotype_type(code)
);
CREATE UNIQUE INDEX phenotype_code_u ON met.phenotype (phenotype_type,code);
ALTER TABLE met.phenotype ADD COLUMN IF NOT EXISTS id_gwasdb integer;
ALTER TABLE met.phenotype ADD COLUMN IF NOT EXISTS code_gwasdb character varying(10);

-- DROP TABLE met.phenotype_phenotype_category;
CREATE TABLE met.phenotype_phenotype_category
(
    phenotype integer NOT NULL,
    phenotype_category integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT phenotype_phenotype_category_phenotype_fk FOREIGN KEY (phenotype) REFERENCES met.phenotype(id),
    CONSTRAINT phenotype_phenotype_category_phenotype_category_fk FOREIGN KEY (phenotype_category) REFERENCES met.phenotype_category(id)
);
COMMENT ON TABLE met.phenotype_phenotype_category IS 'Links between phenotypes and phenotype categories. Multiple categories allowed for each phenotype';
CREATE UNIQUE INDEX phenotype_phenotype_category_u ON met.phenotype_phenotype_category (phenotype,phenotype_category);

-- DROP TABLE met.phenotype_population_prevalence;
CREATE TABLE met.phenotype_population_prevalence
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    phenotype integer NOT NULL,
    ancestry_population met.varcharcodesimple_lc NOT NULL,
    sex met.sex NOT NULL,
    country_reference character(2),
    age_min met.intpos NOT NULL,
    age_max met.intpos NOT NULL,
	estimate double precision NOT NULL,
	sd double precision,
	n integer,
	is_meta_analysis boolean,
	needs_update boolean,
    reference integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),    
    CONSTRAINT phenotype_population_prevalence_pkey PRIMARY KEY (id),
	CONSTRAINT phenotype_population_prevalence_ancestry_population_fk FOREIGN KEY (ancestry_population) REFERENCES met.population(code),
	CONSTRAINT phenotype_population_prevalence_country_reference_fk FOREIGN KEY (country_reference) REFERENCES met.country(iso),
    CONSTRAINT phenotype_population_prevalence_reference_fk FOREIGN KEY (reference) REFERENCES met.reference(id)
);
COMMENT ON TABLE met.phenotype_type IS 'Phenotype population prevalence estimates.';
CREATE UNIQUE INDEX phenotype_population_prevalence_nocountry_u ON met.phenotype_population_prevalence(phenotype,ancestry_population,sex,age_min,age_max,reference) WHERE country_reference IS NULL;
CREATE UNIQUE INDEX phenotype_population_prevalence_country_u ON met.phenotype_population_prevalence(phenotype,ancestry_population,sex,country_reference,age_min,age_max,reference) WHERE country_reference IS NOT NULL;

-- DROP TABLE met.assessment_type;
CREATE TABLE met.assessment_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT assessment_type_pkey PRIMARY KEY (code),
    CONSTRAINT assessment_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.assessment_type IS 'The types of assessments referred to throughout the database.';

-- DROP TABLE met.assessment_item_type;
CREATE TABLE met.assessment_item_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT assessment_item_type_pkey PRIMARY KEY (code),
    CONSTRAINT assessment_item_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.assessment_item_type IS 'The types of assessment items referred to throughout the database.';

-- DROP TABLE met.assessment;
CREATE TABLE met.assessment
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    version_year met.intyearmodern,
    version_major_integer met.intpos,
    version_minor_integer met.intpos,
    version_string met.varcharcodeletnum_lc,
    name character varying NOT NULL,
    assessment_type met.varcharcodesimple_lc NOT NULL,
    reference integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT assessment_pkey PRIMARY KEY (id),
    CONSTRAINT assessment_assessment_type_fk FOREIGN KEY (assessment_type) REFERENCES met.assessment_type(code),
    CONSTRAINT assessment_reference_fk FOREIGN KEY (reference) REFERENCES met.reference(id)
);
COMMENT ON TABLE met.assessment IS 'Assessments referred to throughout the database.';
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
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    name character varying NOT NULL,
    data_collection_country character(2) NOT NULL, 
    primary_targeted_phenotype integer NOT NULL,
    data_collection_sex met.sex NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohort_pkey PRIMARY KEY (id),
    CONSTRAINT cohort_primary_targeted_phenotype FOREIGN KEY (primary_targeted_phenotype) REFERENCES met.phenotype(id)
);
COMMENT ON TABLE met.cohort IS 'Cohorts referred to throughout the database.';
CREATE UNIQUE INDEX cohort_u ON met.cohort (code,data_collection_country);

-- DROP TABLE met.cohortinstance;
CREATE TABLE met.cohortinstance
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohort integer NOT NULL,
    code met.varcharcodeletnum_lc NOT NULL,
    time_extraction TIMESTAMP WITH TIME ZONE NOT NULL,
    reference integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortinstance_pkey PRIMARY KEY (id),
    CONSTRAINT cohortinstance_cohort_fk FOREIGN KEY (cohort) REFERENCES met.cohort (id),
    CONSTRAINT cohortinstance_reference_fk FOREIGN KEY (reference) REFERENCES met.reference(id)
);
COMMENT ON TABLE met.cohortinstance IS 'Instances of cohort data referring to specific phenotype data tables in the database for the assessments made.';
CREATE UNIQUE INDEX cohortinstance_cohort_code_u ON met.cohortinstance (cohort,code);

-- DROP TABLE met.cohortinstance_phenotype_sex_population;
CREATE TABLE met.cohortinstance_phenotype_sex_population
(
    cohortinstance integer NOT NULL,
    phenotype integer NOT NULL,
    sex met.sex NOT NULL,
    population met.varcharcodesimple_lc NOT NULL,
    n met.intpos NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortinstance_phenotype_sex_population_fk1 FOREIGN KEY (cohortinstance) REFERENCES met.cohortinstance(id),
    CONSTRAINT cohortinstance_phenotype_sex_population_fk2 FOREIGN KEY (phenotype) REFERENCES met.phenotype(id),
    CONSTRAINT cohortinstance_phenotype_sex_population_fk3 FOREIGN KEY (population) REFERENCES met.population(code)
);
COMMENT ON TABLE met.cohortinstance_phenotype_sex_population IS 'Documented occurences of phenotypes for cohortinstances. Multiple phenotypes allowed for each cohortinstance.';
CREATE UNIQUE INDEX cohortinstance_phenotype_sex_population_u ON met.cohortinstance_phenotype_sex_population(cohortinstance,phenotype,sex,population);

-- DROP TABLE met.cohortinstance_assessment_item;
CREATE TABLE met.cohortinstance_assessment_item
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohortinstance integer NOT NULL,
    assessment integer NOT NULL,
    item_descriptor met.varcharcodeletnum_lc NOT NULL,
    item_original_descriptor character varying(100) NOT NULL,
    item_original_name character varying NOT NULL,
    item_index met.intoneindex NOT NULL,
    assessment_item_type met.varcharcodeletnum_lc NOT NULL,
    item_text character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortinstance_assessment_item_pkey PRIMARY KEY (id),
    CONSTRAINT cohortinstance_assessment_item_assessment_item_type_fk FOREIGN KEY (assessment_item_type) REFERENCES met.assessment_item_type (code)
);
COMMENT ON TABLE met.cohortinstance_assessment_item IS 'Describes cohortinstance assessment items(can contain multiple variables/columns).';
CREATE UNIQUE INDEX cohortinstance_assessment_item_cohortinstance_assessment_item_descriptor_u ON met.cohortinstance_assessment_item (cohortinstance,assessment,item_descriptor);

-- DROP TABLE met.cohortinstance_assessment_item_variable;
CREATE TABLE met.cohortinstance_assessment_item_variable
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    cohortinstance_assessment_item integer NOT NULL,
    variable_descriptor met.varcharcodeletnum_lc NOT NULL,
    variable_original_descriptor character varying(100),
    variable_min integer,
    variable_max integer,
    variable_alt_int integer[],
    variable_alt_string character varying(100)[],
    CONSTRAINT cohortinstance_assessment_item_variable_pkey PRIMARY KEY (id),
    CONSTRAINT cohortinstance_assessment_item_variable_cohortinstance_assessment_item_fk FOREIGN KEY (cohortinstance_assessment_item) REFERENCES met.cohortinstance_assessment_item(id)
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






