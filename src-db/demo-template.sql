--PhenoDB DEMO template

--View the cohort inventory - overview of the available cohort variables
--View only the demographics assessment
SELECT assessment_item_code, variable_original_descriptor, assessment_item_variable_code  FROM met.cohort_inventory ci WHERE ci.assessment_code = 'covidcnsdem'

--Export cohortdata data from an assessment

SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2022',
	assessment_code => 'covidcnsdem',
	assessment_version_code => '1',
	assessment_item_code => ARRAY['dateofbirth','dobage','ethnicorigin']
	--assessment_variable_code_full => NULL,
	--assessment_variable_code_original => NULL
	);
CREATE TEMP TABLE mydem AS
	SELECT * FROM t_export_data;
	
--SELECT * FROM mydem;

SELECT * FROM coh.create_current_assessment_item_variable_tview(
	cohort_code => 'covidcns',
	instance_code => '2022',
	assessment_code => 'phq9',
	assessment_version_code => '1'
	);
CREATE TEMP TABLE myphq9 AS
	SELECT * FROM t_export_data;
	
SELECT * FROM mydem, myphq9
WHERE mydem._stage=myphq9._stage AND mydem._individual_identifier=myphq9._individual_identifier;

