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


REVOKE ALL ON SCHEMA coh_covidcns FROM "phenodb_user";
GRANT ALL ON SCHEMA coh_covidcns TO "phenodb_user"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA coh_covidcns FROM "phenodb_user";
ALTER DEFAULT PRIVILEGES IN SCHEMA coh_covidcns
GRANT SELECT ON TABLES TO "phenodb_user";
GRANT SELECT ON ALL TABLES IN SCHEMA coh_covidcns TO "phenodb_user";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA coh_covidcns FROM "phenodb_user";
ALTER DEFAULT PRIVILEGES IN SCHEMA coh_covidcns
GRANT SELECT, UPDATE, USAGE ON SEQUENCES TO "phenodb_user";
GRANT SELECT, UPDATE, USAGE ON ALL SEQUENCES IN SCHEMA coh_covidcns TO "phenodb_user";


CREATE SCHEMA sec_covidcns
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA sec_covidcns
    IS 'Secure schema for the COVID-CNS cohort, for holding mapped data relating to the administrative web database which contains individual identifieable data.';

REVOKE ALL ON SCHEMA sec_covidcns FROM "phenodb_coworker";
GRANT ALL ON SCHEMA sec_covidcns TO "phenodb_coworker"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA sec_covidcns FROM "phenodb_coworker";
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_covidcns
GRANT SELECT ON TABLES TO "phenodb_coworker";
GRANT SELECT ON ALL TABLES IN SCHEMA sec_covidcns TO "phenodb_coworker";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA sec_covidcns FROM "phenodb_coworker";
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_covidcns
GRANT SELECT, UPDATE, USAGE ON SEQUENCES TO "phenodb_coworker";
GRANT SELECT, UPDATE, USAGE ON ALL SEQUENCES IN SCHEMA sec_covidcns TO "phenodb_coworker";

 
 -- metadata entries


INSERT INTO met.cohort(code,name,abbreviation,data_collection_country,primary_targeted_phenotype,data_collection_sex,documentation) VALUES('covidcns','The COVID-19 Clinical Neuroscience Study','COVID-CNS','gb',1,'mix','The COVID-CNS cohort. To be updated.');
INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1136/bmj.m3871','33051183',2020,'Neuropsychiatric complications of covid-19');
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bl',met.get_cohort('covidcns'),'Baseline','BL',0);
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('blinp',met.get_cohort('covidcns'),'Baseline, inpatients only','BL INP',0);
INSERT INTO met.cohortstage(code,cohort,name,abbreviation,order_index) VALUES('bloutp',met.get_cohort('covidcns'),'Baseline, outpatients only','BL OUTP',0);
INSERT INTO met.cohortinstance(code,cohort,name,abbreviation,reference) VALUES('2022',met.get_cohort('covidcns'),'First extraction in 2022','2022',met.get_reference_by_doi('10.1136/bmj.m3871'));
INSERT INTO met.cohortinstance(code,cohort,name,abbreviation,reference) VALUES('2023',met.get_cohort('covidcns'),'Improved extraction in 2023','2023',met.get_reference_by_doi('10.1136/bmj.m3871'));
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
	assessment_type =>'imaging',
	assessment_code => 'fsidpukbb',
	assessment_version_code => '2022',
	name => 'Oxford server/UK Biobank type IDP collection, FreeSurfer IDPs, as of 2022',
	abbreviation => 'FSIDP UKBB',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'imaging',
	assessment_code => 'idpukbbnontab',
	assessment_version_code => '2022',
	name => 'Oxford server/UK Biobank type IDP collection non-tabular data, as of 2022',
	abbreviation => 'IDP UKBB NONTAB',
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

SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsadscreener',
	assessment_version_code => '1',
	name => 'COVID-CNS Screener Lifetime A&D',
	abbreviation => 'CNS AD',
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
	assessment_code => 'covidcnscovid19',
	assessment_version_code => '1',
	name => 'COVID-19: Symptoms and Treatment',
	abbreviation => 'COVID19',
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
	assessment_code => 'covidcnsharm',
	assessment_version_code => '1',
	name => 'COVID-CNS Self-harm',
	abbreviation => 'HARM',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
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
	assessment_code => 'covidcnsmigraine',
	assessment_version_code => '1',
	name => 'COVID-CNS Migraine Disability Assessment',
	abbreviation => 'MDA',
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


INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1037/1040-3590.14.4.485','12501574',2002,'The Obsessive-Compulsive Inventory: Development and validation of a short version.');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'oci',
	assessment_version_code => 'r',
	name => 'The Obsessive-Compulsive Inventory, short version',
	abbreviation => 'OCI-R',
	reference_id => met.get_reference_by_doi('10.1037/1040-3590.14.4.485'),
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


SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'covidcnsphh',
	assessment_version_code => '1',
	name => 'COVID-CNS Physical Health History',
	abbreviation => 'PHH',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
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


INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1037/t30040-000',NULL,1995,'Psychosis Screening Questionnaire (PSQ)');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'questionnaire',
	assessment_code => 'psq',
	assessment_version_code => '1',
	name => 'Psychosis Screening Questionnaire',
	abbreviation => 'PSQ',
	reference_id => met.get_reference_by_doi('10.1037/t30040-000'),
	documentation => 'The Psychosis Screening Questionnaire (PSQ; Bebbington & Nayani, 1995) assesses potentially psychotic symptoms. The PSQ covers five broad categories of symptoms: hypomania; thought interference; persecutory delusions; delusional mood; and auditory hallucinations. Each category is screened for with a stem question followed by more targeted questions. For each domain, a screening question establishes the presence of the symptom with additional questions then confirming that the experience is incongruent with norms in the society. The informant must have answered ‘yes’ to all questions within a symptom category in order to score positive on that item. The 5 multiple-part items (e.g., "Over the past year, have there been times when you felt very happy indeed without a break for days on end?" and "Over the past year, have there been times when things looked or sounded abnormal to you?") were answered as yes, no, or unsure. For the PSQ, sensitivity was 96.9%, specificity 95.3%, positive predictive value 91.2%, and negative predictive value 98.4%. (PsycTests Database Record (c) 2020 APA, all rights reserved)'
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
	assessment_code => 'covidcnstinnitus',
	assessment_version_code => '1',
	name => 'COVID-CNS Tinnitus and hearing',
	abbreviation => 'TINNITUS',
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

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1097/00005237-199712000-00003','9451188',1997,'The complete blood count: physiologic basis and clinical usage');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'biosample',
	assessment_code => 'cbc',
	assessment_version_code => '1',
	name => 'Complete blood count',
	abbreviation => 'CBC',
	reference_id => met.get_reference_by_doi('10.1097/00005237-199712000-00003'),
	documentation => 'A complete blood count (CBC), also known as a full blood count (FBC)'
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.1111/j.1532-5415.2005.53221.x','15817019',2005,'The Montreal Cognitive Assessment, MoCA: A Brief Screening Tool For Mild Cognitive Impairment');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'cognitive',
	assessment_code => 'moca',
	assessment_version_code => '1',
	name => 'The Montreal Cognitive Assessment',
	abbreviation => 'MoCA',
	reference_id => met.get_reference_by_doi('10.1111/j.1532-5415.2005.53221.x'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'covidcnspsyneuroscr',
	assessment_version_code => '1',
	name => 'Psych neuro short screener',
	abbreviation => 'psy_neuro_scr',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --Needs reference??
	documentation => ''
	);


SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'covidcnsncrf',
	assessment_version_code => 'm1', --module 1
	name => 'COVID-CNS neuro case report',
	abbreviation => 'NCRF1',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --Needs reference??
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'covidcnsncrf',
	assessment_version_code => 'm2', --module 2
	name => 'COVID-CNS neuro case report',
	abbreviation => 'NCRF2',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --Needs reference??
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'interview',
	assessment_code => 'covidcnsncrf',
	assessment_version_code => 'm3', --module 3
	name => 'COVID-CNS neuro case report',
	abbreviation => 'NCRF3',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'), --Needs reference??
	documentation => ''
	);

INSERT INTO met.reference(doi,pmid,year,documentation) VALUES('10.21203/rs.3.pex-1085/v1',NULL,2020,'Great British Intelligence Test Protocol');
SELECT met.create_assessment_ignoresert(
	assessment_type =>'cognitive',
	assessment_code => 'cognitron',
	assessment_version_code => '1',
	name => 'Cognitron',
	abbreviation => 'COGNITRON',
	reference_id => met.get_reference_by_doi('10.21203/rs.3.pex-1085/v1'),
	documentation => ''
	);

SELECT met.create_assessment_ignoresert(
	assessment_type =>'imaging',
	assessment_code => 'radrep',
	assessment_version_code => '1',
	name => 'Radiology report',
	abbreviation => 'RADIOLOGY REPORT',
	reference_id => met.get_reference_by_doi('10.1136/bmj.m3871'),
	documentation => 'A radiology report type instrument.'
	);


-- COVID-CNS Data dictionary views
CREATE OR REPLACE VIEW coh_covidcns.dictionary_variables
AS SELECT * FROM met.select_assessment_item_variable_meta(
	cohort_code => 'covidcns',
	instance_code => '2023');
ALTER VIEW coh_covidcns.dictionary_variables OWNER TO "phenodb_coworker";

CREATE OR REPLACE VIEW coh_covidcns.dictionary_items
AS SELECT * FROM met.select_assessment_item_meta(
	cohort_code => 'covidcns',
	instance_code => '2023');
ALTER VIEW coh_covidcns.dictionary_items OWNER TO "phenodb_coworker";

--Simple views
CREATE OR REPLACE VIEW coh_covidcns.dictionary_variables_simple
AS SELECT assessment_code, assessment_version_code, assessment_item_code, assessment_item_variable_code, variable_original_descriptor, udt_name db_data_type, variable_unit, variable_documentation 
FROM met.select_assessment_item_variable_meta(
	cohort_code => 'covidcns',
	instance_code => '2023');
ALTER VIEW coh_covidcns.dictionary_variables_simple OWNER TO "phenodb_coworker";

CREATE OR REPLACE VIEW coh_covidcns.dictionary_items_simple
AS SELECT assessment_code, assessment_version_code, assessment_item_type_code, assessment_item_code, item_original_descriptor, item_text, item_documentation
FROM met.select_assessment_item_meta(
	cohort_code => 'covidcns',
	instance_code => '2023');
ALTER VIEW coh_covidcns.dictionary_items_simple OWNER TO "phenodb_coworker";


--Admin Web Database sync
/*
--this works now 
CREATE EXTENSION IF NOT EXISTS dblink;
SELECT * FROM dblink('dbname=covidcnsdb user=postgres password=XXXXX','SELECT id,kit_id FROM "covid-cns".participants') AS tb2(id int, kit_id int)
SELECT * FROM dblink_connect_u('covidcns_web_db', 'dbname=covid-cns user=postgres password=XXXXX')
*/

--this works now also
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- list previous fdw servers
select 
    srvname as name, 
    srvowner::regrole as owner, 
    fdwname as wrapper, 
    srvoptions as options
from pg_foreign_server
join pg_foreign_data_wrapper w on w.oid = srvfdw;

DROP SERVER IF EXISTS covidcns_web_db CASCADE;

CREATE SERVER covidcns_web_db
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'covidcnsdb', port '5432');

CREATE USER MAPPING FOR postgres
SERVER covidcns_web_db
OPTIONS (user 'postgres', password 'XXXXXX');

IMPORT FOREIGN SCHEMA "covid-cns"
FROM SERVER covidcns_web_db INTO sec_covidcns;

--update individual and individual_cohortinstance_identifier tables

--kits with ID's not in database
SELECT * FROM sec_covidcns.participants 
	LEFT OUTER JOIN sec_covidcns.kits ON participants.kit_id = kits.id
	LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici ON ici.cohortinstance = met.get_cohortinstance('covidcns','2023') AND ici.identifier_cohort = kits.identifier
WHERE ici.individual IS NULL;

-- update individual table
UPDATE sec.individual SET name = participants.first_name, surname = participants.last_name  
FROM sec_covidcns.participants 
	LEFT OUTER JOIN sec_covidcns.kits ON participants.kit_id = kits.id
	LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici ON ici.cohortinstance = met.get_cohortinstance('covidcns','2023') AND ici.identifier_cohort = kits.identifier
WHERE ici.individual = individual.id
;

-- update individual_cohortinstance_identifier table
UPDATE sec.individual_cohortinstance_identifier SET 
	country = 'GB', 
	email = participants.email, 
	phone_other=participants.phone_number,
	street=participants.address_street_name,
	city=participants.address_city,
	province=participants.address_county,
	postal_code=participants.address_post_code,
	nhs_id=participants.nhs_id,
	participant_type=participants.type,
	time_entry = participants.created_at,
	time_change = participants.updated_at
FROM sec_covidcns.participants 
	LEFT OUTER JOIN sec_covidcns.kits ON participants.kit_id = kits.id
	LEFT OUTER JOIN sec.individual_cohortinstance_identifier ici ON ici.cohortinstance = met.get_cohortinstance('covidcns','2023') AND ici.identifier_cohort = kits.identifier
WHERE ici.individual = individual_cohortinstance_identifier.individual AND ici.cohortinstance = individual_cohortinstance_identifier.cohortinstance
;

/*
CREATE OR REPLACE PROCEDURE sec_covidcns.update_from_website_database()
LANGUAGE plpgsql
AS $$
BEGIN
	-- IMPORT participants
	--SELECT * FROM dblink('dbname=covid-cns','SELECT id, kit_id FROM participants')
   	--AS tb2(id int, kit_id int);
	
	
	
END;
$$
*/



