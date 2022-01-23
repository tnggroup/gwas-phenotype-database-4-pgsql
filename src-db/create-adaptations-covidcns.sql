/*
 * Sketch dat_cohort data tables for the covidcns cohort study.
 * assessment_cohort_country_cohortinstance
 */
 
 -- metadata entries

INSERT INTO met.cohort(code,name,abbreviation,data_collection_country,primary_targeted_phenotype,data_collection_sex,documentation) VALUES('covidcns','The COVID-19 Clinical Neuroscience Study','COVID-CNS','gb',1,'mix','The COVID-CNS cohort. To be updated.');
INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1136/bmj.m3871','33051183',2020,'Neuropsychiatric complications of covid-19');
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bl',met.get_cohort('covidcns'),'Baseline','BL',0);
INSERT INTO met.cohortinstance(code,cohort,name,abbreviation,reference) VALUES('2021',met.get_cohort('covidcns'),'First extraction in 2021','2021',met.get_reference_by_doi('10.1136/bmj.m3871'));
INSERT INTO met.assessment_item_type(assessment_type,code,name,abbreviation,documentation) VALUES('imaging','idp','Imaging-Derived Phenotype','IDP','Measurements based on imaging derived and QC metrics.');

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'atest',
	assessment_version_code => '1',
	name => 'Databse test assessment',
	abbreviation => 'ATEST1',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => 'This is a test assessment for developing the database.'
	);

SELECT met.create_assessment_item_ignoresert(
	assessment_code => 'atest',
	assessment_version_code => '1',
	assessment_type => 'questionnaire',
	assessment_item_type_code => 'single',
	item_code => 'item1',
    item_original_descriptor => 'item1',
    item_name => 'Item 1',
    item_index => 1,
    item_text => 'Enter your age and name.',
    documentation => 'A non-existing test-item.'
);

select met._create_assessment_item_variable_ignoresert(
	assessment_item => met.get_assessment_item('atest','1','item1'),
	variable_code => 'var1',
    variable_original_descriptor => 'var1',
    variable_index => 1,
	variable_name => 'Age',
	variable_unit => 'year'
);

select met._create_assessment_item_variable_ignoresert(
	assessment_item => met.get_assessment_item('atest','1','item1'),
	variable_code => 'var2',
    variable_original_descriptor => 'var2',
    variable_index => 2,
	variable_name => 'Name'
);

SELECT met.create_assessment_item_ignoresert(
	assessment_code => 'atest',
	assessment_version_code => '1',
	assessment_type => 'questionnaire',
	assessment_item_type_code => 'single',
	item_code => 'item2',
    item_original_descriptor => 'item2',
    item_name => 'Item 2',
    item_index => 1,
    item_text => 'What is your weight in kg?',
    documentation => 'A non-existing test-item.'
);

select met._create_assessment_item_variable_ignoresert(
	assessment_item => met.get_assessment_item('atest','1','item2'),
	variable_code => 'var1',
    variable_original_descriptor => 'var1',
    variable_index => 1,
	variable_name => 'Weight',
	variable_unit => 'kg'
);

SELECT coh.create_cohortinstance_table('covidcns','2021','atest','1');
SELECT coh.create_cohortinstance_table_column('covidcns','2021','atest','1','item1','var1','integer');
SELECT coh.create_cohortinstance_table_column('covidcns','2021','atest','1','item1','var2','text');
SELECT coh.create_cohortinstance_table_column('covidcns','2021','atest','1','item2','var1','double precision');



SELECT met.create_assessment_ignoresert(
	assessment_type =>'imaging',
	assessment_code => 'idpukbb',
	assessment_version_code => '2021',
	name => 'Oxford server/UK Biobank type IDP collection',
	abbreviation => 'IDP UKBB',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	name => 'COVID-CNS demographics questionnaire',
	abbreviation => 'DEM',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => 'Contains both demographics blocks.'
	);


--IMPORT ATTEMPT 202201


DROP TABLE IF EXISTS timp CASCADE;
CREATE TEMP TABLE timp AS SELECT * FROM public.age_covidcns_clean;
GRANT ALL ON TABLE timp TO "phenodb_coworker";
SELECT s.* FROM timp s;

DROP TABLE IF EXISTS tan CASCADE;
CREATE TEMP TABLE tan AS SELECT * FROM public."variable_annotation";
GRANT ALL ON TABLE tan TO "phenodb_coworker";
SELECT s.* FROM tan s;

--SELECT met.parse_assessment_item_variable_code_from_column_name('ID')

--SELECT * FROM met.get_cohortinstance('covidcns','2021');
  --SELECT * FROM met.get_assessment('covidcnsdem','1');
  --SELECT * FROM met.get_cohortstage('covidcns','bl');
SELECT * FROM coh.prepare_import(
	cohort_code =>'covidcns',
	instance_code =>'2021',
	assessment_code =>'covidcnsdem',
	assessment_version_code =>'1',
	table_name =>'timp',
	cohort_id_column_name=>'ID',
	varable_annotation_table_name =>'tan');
SELECT * FROM t_import_data_meta;
SELECT * FROM t_import_data_assessment_item_stats;
SELECT * FROM t_import_data_assessment_item_variable_stats;
SELECT * FROM t_import_data_assessment_variable_annotation;
SELECT * FROM t_import_data_assessment_item_annotation;

 
SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2021',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	stage_code => 'bl',
	table_name => 'timp',
	do_annotate => FALSE,
	add_individuals => FALSE,
	do_insert => FALSE
 );
  
SELECT * FROM t_import_data_assessment_variable_annotation;
SELECT * FROM t_import_data_assessment_item_annotation;

SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2021',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	stage_code => 'bl',
	table_name => 'timp',
	do_annotate => TRUE,
	add_individuals => FALSE,
	do_insert => FALSE
 );
 
 SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2021',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	stage_code => 'bl',
	table_name => 'timp',
	do_annotate => FALSE,
	add_individuals => TRUE,
	do_insert => FALSE
 );
 
 SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2021',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	stage_code => 'bl',
	table_name => 'timp',
	do_annotate => FALSE,
	add_individuals => FALSE,
	do_insert => TRUE
 );
 
 /*
 INSERT INTO coh.covidcns_2021_covidcnsdem_1_1(_stage,_user,_time_assessment,_individual_identifier,startdate,enddate,sample,howoldareyounowtxt,dobage) 
 SELECT '1','postgres','2022-01-23 19:13:58.100937+00',src._individual_identifier,"startDate","endDate",sample,howoldareyounowtxt,dobage 
 FROM t_src_individual src WHERE src._individual_identifier IS NOT NULL
 */
 --SELECT * FROM t_import_data_meta WHERE t_import_data_meta.n_table_name='covidcns_2021_covidcnsdem_1_1' AND t_import_data_meta.n_column_name IS NOT NULL
 
 --SELECT met.construct_cohortinstance_column_name('citem','a')
 --SELECT met.get_cohortinstance_table_index('covidcns','2021','covidcnsdem','1');
 --SELECT coh.create_cohortinstance_table_column('covidcns','2021','covidcnsdem','1','dobage','','double precision');

 --SELECT * FROM t_import_data_meta;
 --SELECT * FROM t_import_data_assessment_item_stats;
 --SELECT * FROM t_import_data_assessment_item_variable_stats;
 -- DROP TABLE t_import_data_assessment_item_annotation
-- SELECT * FROM t_import_data_assessment_item_annotation;
--SELECT * FROM t_src_individual;
