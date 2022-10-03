/*
 * Adaptations for the covidcns cohort study.
 */

--TODO!
-- Log functions using --select * from pg_stat_activity 

-- private schema for covidcns private stuff

CREATE SCHEMA coh_covidcns
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA coh_covidcns
    IS 'Schema for the COVID-CNS cohort, for holding private procedures.';

 
 -- metadata entries


INSERT INTO met.cohort(code,name,abbreviation,data_collection_country,primary_targeted_phenotype,data_collection_sex,documentation) VALUES('covidcns','The COVID-19 Clinical Neuroscience Study','COVID-CNS','gb',1,'mix','The COVID-CNS cohort. To be updated.');
INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1136/bmj.m3871','33051183',2020,'Neuropsychiatric complications of covid-19');
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bl',met.get_cohort('covidcns'),'Baseline','BL',0);
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('blinp',met.get_cohort('covidcns'),'Baseline, inpatients only','BL INP',0);
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bloutp',met.get_cohort('covidcns'),'Baseline, outpatients only','BL OUTP',0);
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

--Baseline

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsals',
	assessment_version_code => '1',
	name => 'COVID-CNS ALS Limb Weakness',
	abbreviation => 'ALS',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --NEEDS REFERENCE
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1001/jama.252.14.1905','6471323',1984,'Detecting alcoholism. The CAGE questionnaire');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'cage',
	assessment_version_code => 'covidcns',
	name => 'COVID-CNS Alcohol CAGE',
	abbreviation => 'CAGE',
	reference_id => met.get_reference_by_doi('10.1001/jama.252.14.1905'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'rogers',
	assessment_version_code => '1',
	name => 'Rogers Self-Assessed Catatonia Scale',
	abbreviation => 'ROGERS',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --NEEDS REFERENCE
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1093/occmed/kqu168','25559796',2015,'The Chalder Fatigue Scale (CFQ 11)');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'cfq11',
	assessment_version_code => 'covidcns',
	name => 'COVID-CNS The Chalder Fatigue Scale',
	abbreviation => 'CFQ 11',
	reference_id => met.get_reference_by_doi('10.1093/occmed/kqu168'),
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

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsfacial',
	assessment_version_code => '1',
	name => 'COVID-CNS facial weakness questionnaire',
	abbreviation => 'FACIAL',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --NEEDS REFERENCE
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsfam',
	assessment_version_code => '1',
	name => 'COVID-CNS family history questionnaire',
	abbreviation => 'FAM',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --NEEDS REFERENCE
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1001/archinte.166.10.1092','16717171',2006,'A brief measure for assessing generalized anxiety disorder: the GAD-7');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'gad7',
	assessment_version_code => '1',
	name => 'A brief measure for assessing generalized anxiety disorder: the GAD-7',
	abbreviation => 'GAD-7',
	reference_id => met.get_reference_by_doi('10.1001/archinte.166.10.1092'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsimpact',
	assessment_version_code => '1',
	name => 'COVID-CNS Impact of COVID',
	abbreviation => 'IMPACT',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsmhd',
	assessment_version_code => '1',
	name => 'COVID-CNS Mental Health History',
	abbreviation => 'MHD',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsnonmotor',
	assessment_version_code => '1',
	name => 'COVID-CNS General Neuro Non-Motor Symptoms',
	abbreviation => 'NONMOTOR',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1002/jts.22059','26606250',2015,'The Posttraumatic Stress Disorder Checklist for DSM-5 (PCL-5): Development and Initial Psychometric Evaluation');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'pcl5',
	assessment_version_code => '1',
	name => 'The Posttraumatic Stress Disorder Checklist for DSM-5',
	abbreviation => 'PCL-5',
	reference_id => met.get_reference_by_doi('10.1002/jts.22059'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1046/j.1525-1497.2001.016009606.x','11556941',2001,'The PHQ-9: validity of a brief depression severity measure');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'phq9',
	assessment_version_code => '1',
	name => 'The Patient Health Questionnaire, depression module',
	abbreviation => 'PHQ-9',
	reference_id => met.get_reference_by_doi('10.1046/j.1525-1497.2001.016009606.x'),
	documentation => ''
	);


SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnssmelltaste',
	assessment_version_code => '1',
	name => 'COVID-CNS Sense of smell and taste',
	abbreviation => 'SMELLTASTE',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnstrauma',
	assessment_version_code => '1',
	name => 'COVID-CNS Trauma section',
	abbreviation => 'TRAUMA',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1002/mds.10473','12815652',2003,'The Unified Parkinson''s Disease Rating Scale (UPDRS): status and recommendations');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'updrs',
	assessment_version_code => 'covidcns',
	name => 'The Unified Parkinson''s Disease Rating Scale',
	abbreviation => 'UPDRS',
	reference_id => met.get_reference_by_doi('10.1002/mds.10473'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsvaccine',
	assessment_version_code => '1',
	name => 'COVID-CNS Vaccine questionnaire',
	abbreviation => 'VACCINE',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'cognitive',
	assessment_code => 'covidcnsna',
	assessment_version_code => '1',
	name => 'COVID-CNS Clinical neurological assessment',
	abbreviation => 'CLINICAL NA',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), -- NEEDS REFERENCE?
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1093/ageing/afu021','24590568',2014,'Validation of the 4AT, a new instrument for rapid delirium screening: a study in 234 hospitalised older people');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => '4at',
	assessment_version_code => '1',
	name => '4 ‘A’s Test',
	abbreviation => '4AT',
	reference_id => met.get_reference_by_doi('10.1093/ageing/afu021'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1016/S0140-6736(74)91639-0','4136544',1974,'ASSESSMENT OF COMA AND IMPAIRED CONSCIOUSNESS: A Practical Scale');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'gcs',
	assessment_version_code => '1',
	name => 'Glasgow Coma Scale',
	abbreviation => 'GCS',
	reference_id => met.get_reference_by_doi('10.1016/S0140-6736(74)91639-0'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsneuroadd',
	assessment_version_code => '1',
	name => 'COVID-CNS additional neurological questions',
	abbreviation => 'NEURO ADD',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsnis',
	assessment_version_code => '1',
	name => 'COVID-CNS Neurological Impairment Survey',
	abbreviation => 'NIS',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --Needs reference??
	documentation => ''
	);


SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnscovid19',
	assessment_version_code => '1',
	name => 'COVID-19: Symptoms and Treatment',
	abbreviation => 'COVID19',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);



/*






INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.21203/rs.3.pex-1085/v1',NULL,2020,'Great British Intelligence Test Protocol');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'cognitronq',
	assessment_version_code => '2022',
	name => 'Cognitron questionnaire',
	abbreviation => 'COGNITRON Questionnaire',
	reference_id => met.get_reference_by_doi('10.21203/rs.3.pex-1085/v1'),
	documentation => ''
	);
*/






/*
--this does not work
CREATE EXTENSION IF NOT EXISTS dblink;
SELECT * FROM dblink('dbname=covid-cns user=postgres password=XXXXX','SELECT id,kit_id FROM participants') AS tb2(id int, kit_id int)
SELECT * FROM dblink_connect_u('covidcns_web_db', 'dbname=covid-cns user=postgres password=XXXXX')

--this does not work either
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER covidcns_web_db
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'covid-cns', port '5432');

CREATE USER MAPPING FOR postgres
SERVER covidcns_web_db
OPTIONS (user 'postgres', password 'XXXXXX');

IMPORT FOREIGN SCHEMA covid_cns
FROM SERVER covidcns_web_db INTO coh_covidcns;

CREATE OR REPLACE PROCEDURE coh_covidcns.update_from_website_database()
LANGUAGE plpgsql
AS $$
BEGIN
	-- IMPORT participants
	
	SELECT * FROM dblink('dbname=covid-cns','SELECT id, kit_id FROM participants')
   	AS tb2(id int, kit_id int);
	
END;
$$
*/


