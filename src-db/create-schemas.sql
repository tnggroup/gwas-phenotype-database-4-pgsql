-- SCHEMA: phe

-- DROP SCHEMA phe ;
CREATE SCHEMA phe
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA phe
    IS 'GWAS phenotype associated data and supporting database objects.';
    
    
    
-- SCHEMA: met

-- DROP SCHEMA met ;
CREATE SCHEMA met
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA met
    IS 'Metadata for the phenotype data regarding cohort, study, phenotype definition etc.';

