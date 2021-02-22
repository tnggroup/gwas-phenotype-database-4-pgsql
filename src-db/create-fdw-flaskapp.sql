CREATE EXTENSION mysql_fdw;

CREATE SERVER flaskapp_mysql FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host 'localhost',port '3306');

CREATE USER MAPPING FOR PUBLIC SERVER flaskapp_mysql OPTIONS (username 'XXX',password 'XXX');

-- SCHEMA: sumstat_old

-- DROP SCHEMA sumstat_old ;

CREATE SCHEMA sumstat_old
    AUTHORIZATION phenodb;

COMMENT ON SCHEMA sumstat_old
    IS 'The sumstats schema on the flaskapp mysql db.';


--show search_path;

--CREATE TYPE sumstat_old.gwas_permissions_t AS enum('FREE','FREE TO UKBB','ON DEMAND','EATING DISORDERS AND DRUG TARGETOR','PRIVATE');

CREATE TYPE gwas_permissions_t AS enum('FREE','FREE TO UKBB','ON DEMAND','EATING DISORDERS AND DRUG TARGETOR','PRIVATE');
CREATE TYPE gwas_assembly_t AS enum('GRCh38/hg38','GRCh37/hg19','NCBI36/hg18','NCBI35/hg17');
CREATE TYPE gwas_uk_biobank_t AS enum('yes','no');
CREATE TYPE gwas_ancestry_t AS enum('AMR','AFR','EUR','SAS','EAS','MIX');
CREATE TYPE gwas_dependent_variable_t AS enum('continuous','binary','categorical');
CREATE TYPE gwas_sex_t AS enum('both','male','female');
CREATE TYPE phenotype_type_t AS enum('trait','disorder','biomarker');

IMPORT FOREIGN SCHEMA sumstats FROM SERVER flaskapp_mysql INTO sumstat_old;
