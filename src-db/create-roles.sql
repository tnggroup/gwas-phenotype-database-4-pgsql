-- Role: security_manager
-- DROP ROLE security_manager;
CREATE ROLE security_manager WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  CREATEROLE
  NOREPLICATION;
COMMENT ON ROLE security_manager IS 'Can edit login and group roles.';

-- Role: phenodb_owner
-- DROP ROLE phenodb_owner;
CREATE ROLE phenodb_owner WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  CREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_owner IS 'The main owner/administrator and architect of the GWAS phenotype database.';

-- Role: phenodb_phenotype_editor
-- DROP ROLE phenodb_phenotype_editor;
CREATE ROLE phenodb_phenotype_editor WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_phenotype_editor IS 'Can edit phenotype data and metadata in the GWAS phenotype database.';

-- Role: phenodb_metadata_editor
-- DROP ROLE phenodb_metadata_editor;
CREATE ROLE phenodb_metadata_editor WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_metadata_editor IS 'Can edit phenotype metadata in the GWAS phenotype database.';

-- Role: phenodb_data_entry_clerk
-- DROP ROLE phenodb_data_entry_clerk;
CREATE ROLE phenodb_data_entry_clerk WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_data_entry_clerk IS 'Can edit data that is to be imported into the primary database structure of the GWAS phenotype database.';