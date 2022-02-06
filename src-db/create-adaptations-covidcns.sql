/*
 * Adaptations for the covidcns cohort study.
 */
 
 -- metadata entries

INSERT INTO met.cohort(code,name,abbreviation,data_collection_country,primary_targeted_phenotype,data_collection_sex,documentation) VALUES('covidcns','The COVID-19 Clinical Neuroscience Study','COVID-CNS','gb',1,'mix','The COVID-CNS cohort. To be updated.');
INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1136/bmj.m3871','33051183',2020,'Neuropsychiatric complications of covid-19');
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bl',met.get_cohort('covidcns'),'Baseline','BL',0);
INSERT INTO met.cohortinstance(code,cohort,name,abbreviation,reference) VALUES('2022',met.get_cohort('covidcns'),'First extraction in 2022','2022',met.get_reference_by_doi('10.1136/bmj.m3871'));
INSERT INTO met.assessment_item_type(assessment_type,code,name,abbreviation,documentation) VALUES('imaging','idp','Imaging-Derived Phenotype','IDP','Measurements based on imaging derived and QC metrics.');

SELECT met.create_assessment_ignoresert(
	assessment_type =>'imaging',
	assessment_code => 'idpukbb',
	assessment_version_code => '2022',
	name => 'Oxford server/UK Biobank type IDP collection, as of 2022',
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
CREATE TEMP TABLE timp AS SELECT * FROM public.ethnicity_covidcns_clean;
GRANT ALL ON TABLE timp TO "phenodb_coworker";
SELECT s.* FROM timp s;

DROP TABLE IF EXISTS tvan CASCADE;
CREATE TEMP TABLE tvan AS SELECT * FROM public."variable_annotation";
GRANT ALL ON TABLE tvan TO "phenodb_coworker";
SELECT s.* FROM tvan s;

DROP TABLE IF EXISTS tian CASCADE;
CREATE TEMP TABLE tian AS SELECT * FROM public."item_annotation";
GRANT ALL ON TABLE tian TO "phenodb_coworker";
SELECT s.* FROM tian s;

--SELECT met.parse_assessment_item_variable_code_from_column_name('ID')

--SELECT * FROM met.get_cohortinstance('covidcns','2021');
  --SELECT * FROM met.get_assessment('covidcnsdem','1');
  --SELECT * FROM met.get_cohortstage('covidcns','bl');
SELECT * FROM coh.prepare_import(
	cohort_code =>'covidcns',
	instance_code =>'2022',
	assessment_code =>'covidcnsdem',
	assessment_version_code =>'1',
	table_name =>'timp',
	cohort_id_column_name=>'id',
	varable_annotation_table_name =>'tvan',
	item_annotation_table_name =>'tian'
);
SELECT * FROM t_import_data_meta;
SELECT * FROM t_import_data_assessment_item_stats;
SELECT * FROM t_import_data_assessment_item_variable_stats;
SELECT * FROM t_import_data_assessment_variable_annotation;
SELECT * FROM t_import_data_assessment_item_annotation;

 
SELECT * FROM coh.import_data(
 	cohort_code => 'covidcns',
	instance_code => '2022',
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
	instance_code => '2022',
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
	instance_code => '2022',
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
	instance_code => '2022',
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
