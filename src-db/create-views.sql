--DROP VIEW met.cohort_inventory;
CREATE OR REPLACE VIEW met.cohort_inventory
AS WITH fi AS (SELECT
				substring("table_name" from '^(.+?)_') cohort_code,
				substring("table_name" from '^.+?_(.*?)_') instance_code,
				substring("table_name" from '^.+?_.*?_(.+?)_') assessment_code,
				substring("table_name" from '^.+?_.*?_.+?_(.*?)_') assessment_version_code,
				substring("table_name" from '_(\d+)$')::int table_index,
				substring("column_name" from '^([^_\n\r]+?)(_|$)') assessment_item_code,
				substring("column_name" from '^[^_\n\r]+?_(.+)$') assessment_item_variable_code,
				columns.*
				FROM information_schema.columns where table_catalog='phenodb' AND table_schema='coh'
			   )
	SELECT fi.*,
	cohort.id AS cohort_id,
	cohortinstance.id AS cohortinstance_id,
	assessment.id AS assessment_id,
	assessment_item.id AS assessment_item_id,
	assessment_item_variable.id AS assessment_item_variable_id
	FROM fi
	LEFT OUTER JOIN met.cohort ON fi.cohort_code=cohort.code
	LEFT OUTER JOIN met.cohortinstance ON fi.instance_code=cohortinstance.code AND cohortinstance.cohort=cohort.id
	LEFT OUTER JOIN met.assessment ON fi.assessment_code=assessment.code AND fi.assessment_version_code=assessment.version_code
	LEFT OUTER JOIN met.assessment_item ON assessment.id=assessment_item.assessment AND fi.assessment_item_code=assessment_item.item_code
	LEFT OUTER JOIN met.assessment_item_variable ON assessment_item.id=assessment_item_variable.assessment_item AND fi.assessment_item_variable_code = assessment_item_variable.variable_code
	ORDER BY cohort_code,instance_code,assessment_code,assessment_version_code,assessment_item_code,assessment_item_variable_code;


--SELECT * FROM met.cohort_inventory;