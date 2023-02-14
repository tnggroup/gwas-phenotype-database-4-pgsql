--PhenoDB DEMO template (updated for demo 2)

--Examples from the slides
SELECT * FROM met.assessment a, met.assessment_type at2 WHERE a.assessment_type = at2.code;
SELECT * FROM met.assessment a INNER JOIN met.assessment_type at2 ON a.assessment_type = at2.code;

--View data dictionaries
--From the tree menu
--or from your own query
SELECT * FROM coh_covidcns.dictionary_items_simple dis WHERE dis.assessment_code = 'phq9';
SELECT * FROM coh_covidcns.dictionary_variables_simple dvs WHERE dvs.assessment_code = 'phq9';
SELECT * FROM coh_covidcns.dictionary_items_simple dis WHERE dis.assessment_code = 'idpukbb';
SELECT * FROM coh_covidcns.dictionary_variables_simple dvs WHERE dvs.assessment_code = 'idpukbb';

--alt
SELECT * FROM met.select_assessment_item_meta(
	cohort_code => 'covidcns',
	instance_code => '2023'); --WHERE assessment_code = 'idpukbb';
SELECT * FROM met.select_assessment_item_variable_meta(
	cohort_code => 'covidcns',
	instance_code => '2023');

--alt2
SELECT * FROM met.select_cohort_inventory() ci WHERE ci.assessment_code = 'idpukbb';


--Export cohortdata data from an assessment

SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	assessment_item_code => ARRAY['dateofbirth','dobage','ethnicorigin']
	--assessment_variable_code_full => NULL,
	--assessment_variable_code_original => NULL
	);
SELECT * FROM t_export_data;

-- DROP TABLE mydem;
CREATE TEMP TABLE mydem AS
	SELECT * FROM t_export_data;

/*
SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'idpukbb',
	assessment_version_code => '2022',
	assessment_item_code => ARRAY['visit','qc','idpt1sienax','idp1first','idp1fastrois']
	);
SELECT * FROM t_export_data;
*/
SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2023',
	assessment_code => 'phq9',
	assessment_version_code => '1'
	);
SELECT * FROM t_export_data;

--DROP TABLE myphq9;
CREATE TEMP TABLE myphq9 AS
	SELECT * FROM t_export_data;
	
SELECT * FROM mydem INNER JOIN myphq9
ON mydem._stage=myphq9._stage AND mydem._individual_identifier=myphq9._individual_identifier;

