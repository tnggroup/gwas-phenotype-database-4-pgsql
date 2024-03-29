
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
  time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
  CONSTRAINT country_pkey PRIMARY KEY (iso),
  CONSTRAINT country_idnum_u UNIQUE (idnum)
);

-- DROP TABLE met.population;
CREATE TABLE met.population
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT population_pkey PRIMARY KEY (code),
    CONSTRAINT population_code_u UNIQUE (code)
);
COMMENT ON TABLE met.population IS 'The populations referred to throughout the database for ancestry purposes or other. Initially includes groupings based on the NHGRI-EBI GWAS Catalog standard but can be expanded beyond.';

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

-- DROP TABLE met.phenotype_assessment_type;
CREATE TABLE met.phenotype_assessment_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT phenotype_assessment_type_pkey PRIMARY KEY (code),
    CONSTRAINT phenotype_assessment_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.phenotype_assessment_type IS 'A characteristic relating to if the phenotype is broadly or narrowly defined.';

-- DROP TABLE met.phenotype_category;
CREATE TABLE met.phenotype_category
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
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
ALTER TABLE met.phenotype ADD COLUMN IF NOT EXISTS sort_code met.varcharcodeletnum_uc;
ALTER TABLE met.phenotype ALTER COLUMN sort_code SET NOT NULL;
CREATE UNIQUE INDEX phenotype_u ON met.phenotype(phenotype_type,code);


-- DROP TABLE met.phenotype_phenotype_category;
CREATE TABLE met.phenotype_phenotype_category
(
    phenotype integer NOT NULL,
    phenotype_category integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
    CONSTRAINT phenotype_phenotype_category_phenotype_fk FOREIGN KEY (phenotype) REFERENCES met.phenotype(id),
    CONSTRAINT phenotype_phenotype_category_phenotype_category_fk FOREIGN KEY (phenotype_category) REFERENCES met.phenotype_category(id)
);
COMMENT ON TABLE met.phenotype_phenotype_category IS 'Links between phenotypes and phenotype categories. Multiple categories allowed for each phenotype';
CREATE UNIQUE INDEX phenotype_phenotype_category_u ON met.phenotype_phenotype_category (phenotype,phenotype_category);


-- DROP TABLE met.assessment_type;
CREATE TABLE met.assessment_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
    CONSTRAINT assessment_type_pkey PRIMARY KEY (code),
    CONSTRAINT assessment_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.assessment_type IS 'The types of assessments referred to throughout the database.';

-- DROP TABLE met.assessment_item_type;
CREATE TABLE met.assessment_item_type
(
	id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	assessment_type met.varcharcodesimple_lc NOT NULL,
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    abbreviation character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
    CONSTRAINT assessment_item_type_pkey PRIMARY KEY (id),
    CONSTRAINT assessment_item_type_fk FOREIGN KEY (assessment_type) REFERENCES met.assessment_type(code)
);
COMMENT ON TABLE met.assessment_item_type IS 'The types of assessment items, categorised by assessment type, referred to throughout the database.';
CREATE UNIQUE INDEX assessment_item_type_u ON met.assessment_item_type (assessment_type,code);

-- DROP TABLE met.assessment;
CREATE TABLE met.assessment
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    version_code met.varcharcodeletnum_lc NOT NULL DEFAULT '',
    name character varying NOT NULL,
    abbreviation character varying NOT NULL,
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
CREATE UNIQUE INDEX assessment_u_code_version_code ON met.assessment (code,version_code);

-- DROP TABLE met.cohort;
CREATE TABLE met.cohort
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
    name character varying NOT NULL,
    abbreviation CHARACTER VARYING NOT NULL,
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
CREATE UNIQUE INDEX cohort_u ON met.cohort (code);

-- DROP TABLE met.cohortstage;
CREATE TABLE met.cohortstage
(
	id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	code met.varcharcodeletnum_lc NOT NULL,
	cohort integer NOT NULL,
    name character varying NOT NULL,
    abbreviation CHARACTER VARYING NOT NULL,
    order_index integer,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortstage_pkey PRIMARY KEY (id),
    CONSTRAINT cohortstage_cohort_fk FOREIGN KEY (cohort) REFERENCES met.cohort (id)
);
COMMENT ON TABLE met.cohortstage IS 'Stages of a cohort data collection.';
CREATE UNIQUE INDEX cohortstage_u ON met.cohortstage (cohort,code);
CREATE UNIQUE INDEX cohortstage_u2 ON met.cohortstage (cohort,id);

-- DROP TABLE met.cohortinstance;
CREATE TABLE met.cohortinstance
(
	id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    code met.varcharcodeletnum_lc NOT NULL,
	cohort integer NOT NULL,
	name character varying NOT NULL,
    abbreviation CHARACTER VARYING NOT NULL,
    time_extraction TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    reference integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohortinstance_pkey PRIMARY KEY (id),
    CONSTRAINT cohortinstance_cohort_fk FOREIGN KEY (cohort) REFERENCES met.cohort (id),
    CONSTRAINT cohortinstance_reference_fk FOREIGN KEY (reference) REFERENCES met.reference(id)
);
COMMENT ON TABLE met.cohortinstance IS 'Instances of cohort data referring to specific phenotype data tables in the database for the assessments made.';
CREATE UNIQUE INDEX cohortinstance_u ON met.cohortinstance (cohort,code);
CREATE UNIQUE INDEX cohortinstance_u2 ON met.cohortinstance (cohort,id);

-- DROP TABLE met.cohort_phenotype_sex_population;
/*
CREATE TABLE met.cohort_phenotype_sex_population
(
	cohort integer NOT NULL,
    cohortstage integer NOT NULL,
    cohortinstance integer NOT NULL,
    phenotype integer NOT NULL,
    population met.varcharcodesimple_lc NOT NULL,
    sex met.sex NOT NULL,
    n met.intpos NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT cohort_phenotype_sex_population_cohortstage_fk FOREIGN KEY (cohort,cohortstage) REFERENCES met.cohortstage(cohort,id),
    CONSTRAINT cohort_phenotype_sex_population_cohortinstance_fk FOREIGN KEY (cohort,cohortinstance) REFERENCES met.cohortinstance(cohort,id),
    CONSTRAINT cohort_phenotype_sex_population_phenotype_fk FOREIGN KEY (phenotype) REFERENCES met.phenotype(id),
    CONSTRAINT cohort_phenotype_sex_population_population_fk FOREIGN KEY (population) REFERENCES met.population(code)
);
COMMENT ON TABLE met.cohort_phenotype_sex_population IS 'Documented occurences of phenotypes for cohorts. Multiple phenotypes, populations, and sex allowed for each stage and instance.';
CREATE UNIQUE INDEX cohort_phenotype_sex_population_u ON met.cohort_phenotype_sex_population(cohort,cohortstage,cohortinstance,phenotype,population,sex);
*/

-- DROP TABLE met.assessment_item;
CREATE TABLE met.assessment_item
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    assessment integer NOT NULL,
    assessment_item_type integer NOT NULL,
    item_code met.varcharcodeletnum_lc NOT NULL,
    item_original_descriptor character varying(100) NOT NULL,
    item_name character varying NOT NULL,
    item_index met.intoneindex NOT NULL,
    item_text character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT assessment_item_pkey PRIMARY KEY (id),
    CONSTRAINT assessment_item_assessment_fk FOREIGN KEY (assessment) REFERENCES met.assessment (id),
    CONSTRAINT assessment_item_assessment_item_type_fk FOREIGN KEY (assessment_item_type) REFERENCES met.assessment_item_type (id)
);
COMMENT ON TABLE met.assessment_item IS 'Describes assessment items(can contain multiple variables/columns).';
CREATE UNIQUE INDEX assessment_item_u ON met.assessment_item (assessment,item_code);

-- DROP TABLE met.data_storage_type;  --Do not use if using table setup
/*
CREATE TABLE met.data_storage_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), 
    CONSTRAINT data_storage_type_pkey PRIMARY KEY (code),
    CONSTRAINT data_storage_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.data_storage_type IS 'The data types used for storing primarily cohort data.';
*/

-- DROP TABLE met.assessment_item_variable;
CREATE TABLE met.assessment_item_variable
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    assessment_item integer NOT NULL,
    variable_code met.varcharcodeletnum_lc, --NOT NULL,
    variable_original_descriptor character varying(300),
    variable_index met.intoneindex NOT NULL,
	variable_name character varying,
	variable_text character varying,
	--variable_data_storage_type met.varcharcodesimple_lc NOT NULL,
    variable_int_min_limit integer,
    variable_int_max_limit integer,
    variable_float_min_limit double precision,
    variable_float_max_limit double precision,
    variable_unit CHARACTER VARYING,
    variable_alt_code character varying(100)[], --if the variable has alternatives to choose from, code
    variable_alt_text character varying(100)[], --corresponding descriptive texts of the variable alternatives
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT assessment_item_variable_pkey PRIMARY KEY (id),
    CONSTRAINT assessment_item_variable_assessment_item_fk FOREIGN KEY (assessment_item) REFERENCES met.assessment_item(id)
    --CONSTRAINT assessment_item_variable_data_storage_type_fk FOREIGN KEY (variable_data_storage_type) REFERENCES met.data_storage_type(code)
);
COMMENT ON TABLE met.assessment_item_variable IS 'Describes variables relating to each assessment item in a cohortinstance extraction and a table column in a corresponding phenotypic data table.';
CREATE UNIQUE INDEX assessment_item_variable_u ON met.assessment_item_variable (assessment_item,variable_code) WHERE variable_code IS NOT NULL;
CREATE UNIQUE INDEX assessment_item_variable_u2 ON met.assessment_item_variable (assessment_item) WHERE variable_code IS NULL;
CREATE INDEX assessment_item_variable_i ON met.assessment_item_variable (id,assessment_item,variable_code,variable_index);


-- DROP TABLE met.summary_type;
CREATE TABLE met.summary_type
(
    code met.varcharcodesimple_lc NOT NULL,
    name character varying NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    CONSTRAINT summary_type_pkey PRIMARY KEY (code),
    CONSTRAINT summary_type_code_u UNIQUE (code)
);
COMMENT ON TABLE met.summary_type IS 'The primary unique types of summary level data referred to throughout the database.';

-- DROP TABLE met.summary;
CREATE TABLE met.summary
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	--code met.varcharcodeletnum_lc NOT NULL, --delete this??
	sort_code met.varcharcodeletnum_uc NOT NULL,
	sort_counter met.intpos NOT NULL DEFAULT 1,
    name character varying NOT NULL,
	summary_type met.varcharcodesimple_lc NOT NULL,
	sex met.sex NOT NULL,
	is_meta_analysis boolean NOT NULL DEFAULT FALSE,
	phenotype integer NOT NULL,
    phenotype_assessment_type met.varcharcodeletnum_lc NOT NULL,
    ancestry_population met.varcharcodesimple_lc NOT NULL,
    ancestry_details met.varcharcodesimple_lc[],
    ancestry_details_fraction double precision[],
    country_reference character(2),
	age_min_years met.intpos,
    age_mean_years met.intpos,
    age_max_years met.intpos,
	sample_case_n integer,
	sample_control_n integer,
	time_est_mean_measurement TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    reference integer NOT NULL,
    documentation character varying NOT NULL DEFAULT '',
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT summary_pkey PRIMARY KEY (id),
	CONSTRAINT summary_summary_type FOREIGN KEY (summary_type) REFERENCES met.summary_type(code),
    CONSTRAINT summary_phenotype FOREIGN KEY (phenotype) REFERENCES met.phenotype(id),
	CONSTRAINT summary_phenotype_assessment_type FOREIGN KEY (phenotype_assessment_type) REFERENCES met.phenotype_assessment_type(code)
);
COMMENT ON TABLE met.summary IS 'Summary level datasets referred to throughout the database.';
--CREATE UNIQUE INDEX summary_u ON met.summary (code,summary_type);
CREATE UNIQUE INDEX summary_u2 ON met.summary (sort_code,sort_counter,summary_type);
CREATE INDEX summary_i ON met.summary (id,sort_code,sort_counter,summary_type,sex,is_meta_analysis,phenotype,phenotype_assessment_type,ancestry_population,country_reference);

-- DROP TABLE sec.individual;
CREATE TABLE sec.individual
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying,
	name_more character varying,
	surname character varying,
	sex met.sex,
	time_birth TIMESTAMP WITH TIME ZONE,
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT individual_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE sec.individual IS 'Individual persons referred throughout the database.';
CREATE INDEX individual_i ON sec.individual (id,name,name_more,surname,sex,time_birth);

-- DROP TABLE sec.individual_cohortinstance_identifier;
CREATE TABLE sec.individual_cohortinstance_identifier
(
    individual integer NOT NULL,
	cohortinstance integer NOT NULL,
	identifier uuid NOT NULL DEFAULT gen_random_uuid(),
	identifier_cohort met.varcharcodesimple_lc,
	name_updated character varying,
	name_more_updated character varying,
	surname_updated character varying,
	country character(2),
	email character varying,
	apartment character varying,
	house character varying,
	street character varying,
	city character varying,
	province character varying,
	postal_code character varying,
	cellphone character varying,
	phone_other character varying,
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT individual_cohortinstance_identifier_pkey PRIMARY KEY (individual,cohortinstance,identifier),
	CONSTRAINT individual_cohortinstance_identifier_individual_fk FOREIGN KEY (individual) REFERENCES sec.individual(id),
	CONSTRAINT individual_cohortinstance_identifier_cohortinstance_fk FOREIGN KEY (cohortinstance) REFERENCES met.cohortinstance(id)
);
COMMENT ON TABLE sec.individual_cohortinstance_identifier IS 'Individual person identifiers for use in database tables or elsewhere. These should be deleted to sever any associations with protected individual data across cohorts.';
CREATE UNIQUE INDEX individual_cohortinstance_identifier_u ON sec.individual_cohortinstance_identifier (individual,cohortinstance,identifier,identifier_cohort);

ALTER TABLE sec.individual_cohortinstance_identifier ADD COLUMN IF NOT EXISTS nhs_id character varying(20);
ALTER TABLE sec.individual_cohortinstance_identifier ADD COLUMN IF NOT EXISTS participant_type character varying(200);


COMMIT;


BEGIN TRANSACTION;
-- DROP TABLE sum.phenotype_population_prevalence;
CREATE TABLE sum.phenotype_population_prevalence
(
	summary integer NOT NULL,
    prevalence_life double precision,
    prevalence_life_sd double precision,
    prevalence_point double precision,
    prevalence_point_se double precision,
    prevalence_6_month double precision,
    prevalence_6_month_se double precision,
    prevalence_12_month double precision,
    prevalence_12_month_se double precision,
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),    
    CONSTRAINT phenotype_population_prevalence_sum_fk FOREIGN KEY (summary) REFERENCES met.summary(id)
);
COMMENT ON TABLE sum.phenotype_population_prevalence IS 'Phenotype population prevalence estimates.';


CREATE TABLE sum.gwas
(
	summary integer NOT NULL,
	assembly int NOT NULL, --36,37,38 etc corresponding to the GRCh version number
	dependent_variable_binary boolean NOT NULL,
	download_link text,
    filename text,
    platform text,
    n_details text,
    consortium text,
    permissions text,
    uk_biobank boolean,
    time_entry TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    time_change TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),    
    CONSTRAINT gwas_sum_fk FOREIGN KEY (summary) REFERENCES met.summary(id)
);
COMMENT ON TABLE sum.gwas IS 'Genome-Wide Association Study (GWAS) summary statistcis in the TNG GWAS sumstat repository.';


--TODO- Add the gwas_summary_statistic table
COMMIT;


/*
 * Convention for item columns in cohort data tables:
 * [ITEM CODE]_[ITEM VARIABLE CODE]
 * 
 * Columns with underscore in front are special purpose non-data item meta columns, for example the _id column used for row id in the table.
 */

BEGIN TRANSACTION;
/*
 * A template and test coh data concept table.
 */
-- DROP TABLE coh.tcohort_tcohortinstance_tassessment_tassessmentversion;

CREATE TABLE coh.tcohort_tcohortinstance_tassessment_tassessmentversion_1
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --spid character varying(9) NOT NULL, --this should go into the individual_cohortinstance_identifier table
    --sex integer NOT NULL, --this should go into the individual table
    var_time timestamp with time zone,
    var_alt_single1 integer,
    var_alt_single1_comment character varying(600),
   	var_alt_multi1 integer[],
   	--var_alt_multi1_selection integer[5], --boolean encoding 0 - false, 1 - true, BUT expanded with space for additional codes
    var_alt_multi1_comment character varying(600)[],
    CONSTRAINT tcohort_tcohortinstance_tassessment_tassessmentversion_1_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE coh.tcohort_tcohortinstance_tassessment_tassessmentversion_1 IS 'Template and test cohortdata concept table.';

--INSERT INTO coh.tcohort_tcohortinstance_tassessment(_stage,spid,sex,var_time,var_alt_single1,var_alt_single1_comment,var_alt_multi1,var_alt_multi1_comment) VALUES('bl','CCNS19139',1,'2020-01-03 04:05:06+02',3,'Other choice','{1,3,4}','{NULL,NULL,"A comment. Some text."}')

-- DROP TABLE coh.tcohort_tcohortinstance_tassessment;
/*
CREATE TABLE coh.tcohort_tcohortinstance_tassessment
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    stage met.varcharcodeletnum_lc NOT NULL,
	individual_identifier uuid NOT NULL,
	assessment_item_variable int NOT NULL,
	d_float double PRECISION,
	d_int integer,
	d_text CHARACTER VARYING,
	d_timepoint TIMESTAMP WITH TIME ZONE,
    CONSTRAINT tcohort_tcohortinstance_tassessment_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE coh.tcohort_tcohortinstance_tassessment IS 'Template and test cohortdata concept table.';
CREATE INDEX tcohort_tcohortinstance_tassessment_i ON coh.tcohort_tcohortinstance_tassessment (id,stage,individual_identifier);
CREATE INDEX tcohort_tcohortinstance_tassessment_i2 ON coh.tcohort_tcohortinstance_tassessment (id,d_float,d_int,d_text,d_timepoint);
*/

COMMIT;






