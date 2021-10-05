-- SCHEMA: met
-- DROP SCHEMA met ;
CREATE SCHEMA met
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA met
    IS 'Metadata for all research data regarding cohort, study, phenotype definition etc. Should not contain personal data on individuals, ideally.';


-- SCHEMA: coh
-- DROP SCHEMA coh ;
CREATE SCHEMA coh
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA coh
    IS 'Study cohort associated data and supporting database objects.';


-- SCHEMA: sum
-- DROP SCHEMA sum ;
CREATE SCHEMA sum
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA sum
    IS 'Summary level data on a general or super cohort level. GWAS data falls within this categorisation.';
	

-- SCHEMA: sec
-- DROP SCHEMA sec ;
CREATE SCHEMA sec
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA sec
    IS 'Even though it can be discouraged to store data of more sensitive kind such as personal data with individual identifiers together with data of lesser sensitivity, it can sometimes be required. This schema is for those cases where you still want to separate this more sensitive data from other data with a separate set of authorisation rules.';
    
    
    


