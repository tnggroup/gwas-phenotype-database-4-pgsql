-- SCHEMA: met
-- DROP SCHEMA met ;
CREATE SCHEMA met
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA met
    IS 'Metadata for all research data regarding cohort, study, phenotype definition etc. Should not contain personal data on individuals, ideally.';


-- SCHEMA: dat_cohort
-- DROP SCHEMA dat_cohort ;
CREATE SCHEMA dat_cohort
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA dat_cohort
    IS 'Study cohort associated data and supporting database objects.';


-- SCHEMA: dat_summary
-- DROP SCHEMA dat_summary ;
CREATE SCHEMA dat_summary
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA dat_summary
    IS 'Summary level data on a general or super cohort level. GWAS data falls within this categorisation.';
	

-- SCHEMA: dat_protected
-- DROP SCHEMA dat_protected ;
CREATE SCHEMA dat_protected
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA dat_protected
    IS 'Even though it can be discouraged to store data of more sensitive kind such as personal data with individual identifiers together with data of lesser sensitivity, it can sometimes be required. This schema is for those cases where you still want to separate this more sensitive data from other data with a separate set of authorisation rules.';
    
    
    


