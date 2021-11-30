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

SELECT met.create_cohortinstance_table('covidcns','2021','atest','1');
SELECT met.create_cohortinstance_table_column('covidcns','2021','atest','1','item1','var1','integer');
SELECT met.create_cohortinstance_table_column('covidcns','2021','atest','1','item1','var2','text');
SELECT met.create_cohortinstance_table_column('covidcns','2021','atest','1','item2','var1','double precision');



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
	abbreviation => 'DEM1',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_item_ignoresert(
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	assessment_type => 'questionnaire',
	assessment_item_type_code => 'single',
	item_code => 'test',
    item_original_descriptor => 'test',
    item_name => 'Test',
    item_index => 1,
    item_text => 'Please answer the following.',
    documentation => 'A non-existing test-item.'
);


select met._create_assessment_item_variable_ignoresert(
	assessment_item => met.get_assessment_item('covidcnsdem','1','test'),
	variable_code => 'var1',
    variable_original_descriptor => 'var1',
    variable_index => 1,
	variable_name => 'Name',
	variable_text => 'What is your name?'
);

SELECT met.create_cohortinstance_table('covidcns','2021','idpukbb','2021');
SELECT met.create_cohortinstance_table('covidcns','2021','covidcnsdem','1');

SELECT met.create_cohortinstance_table_column('covidcns','2021','covidcnsdem','1','test','var1','character varying');


