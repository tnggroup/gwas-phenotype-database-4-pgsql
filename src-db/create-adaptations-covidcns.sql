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
INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1016/S0140-6736(74)91639-0','4136544',1974,'ASSESSMENT OF COMA AND IMPAIRED CONSCIOUSNESS: A Practical Scale');
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

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnscovid19',
	assessment_version_code => '1',
	name => 'COVID-19: Symptoms and Treatment',
	abbreviation => 'COVID19',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'gcs',
	assessment_version_code => '1',
	name => 'Glasgow Coma Scale',
	abbreviation => 'GCS',
	reference_id => met.get_reference_by_doi('10.1016/S0140-6736(74)91639-0'),
	documentation => ''
	);

/*
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsimpact',
	assessment_version_code => '1',
	name => 'COVID-CNS Impact of COVID',
	abbreviation => 'IMPACT',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1001/jama.252.14.1905','6471323',1984,'Detecting alcoholism. The CAGE questionnaire');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'cage',
	assessment_version_code => 'covidcns',
	name => 'Alcohol CAGE',
	abbreviation => 'CAGE',
	reference_id => met.get_reference_by_doi('10.1001/jama.252.14.1905'),
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1093/occmed/kqu168','25559796',2015,'The Chalder Fatigue Scale (CFQ 11)');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'cfq11',
	assessment_version_code => 'covidcns',
	name => 'The Chalder Fatigue Scale',
	abbreviation => 'CFQ 11',
	reference_id => met.get_reference_by_doi('10.1093/occmed/kqu168'),
	documentation => ''
	);

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


