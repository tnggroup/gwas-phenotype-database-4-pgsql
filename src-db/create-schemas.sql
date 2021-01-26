-- SCHEMA: phe

-- DROP SCHEMA phe ;
CREATE SCHEMA phe
    AUTHORIZATION phenodb_owner;

COMMENT ON SCHEMA phe
    IS 'GWAS phenotype associated data and supporting database objects.';
    
    
    
-- SCHEMA: meta

-- DROP SCHEMA met ;
CREATE SCHEMA met
    AUTHORIZATION phenodb_owner;

COMMENT ON SCHEMA met
    IS 'Metadata for the phenotype data regarding cohort, study, phenotype definition etc.';