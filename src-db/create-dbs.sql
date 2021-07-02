-- Database: phenodb

-- DROP DATABASE phenodb;

CREATE DATABASE phenodb
    WITH 
    OWNER = phenodb
    ENCODING = 'UTF8'
    LC_COLLATE = 'C.UTF-8'
    LC_CTYPE = 'C.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE phenodb
    IS 'This is a database intended to be used for storing project phenotype data and related metadata for the PGD ED group and collaborators. It is however created to be useful from a general purpose point of view to meet changes in requirements and needs.';