-- Role: security_manager
-- DROP ROLE security_manager;
/*
CREATE ROLE security_manager WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  CREATEROLE
  NOREPLICATION;
COMMENT ON ROLE security_manager IS 'Can edit login and group roles.';
*/

-- Role: phenodb
-- DROP ROLE phenodb;
CREATE ROLE phenodb WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb IS 'Admin/developer/architect access rights to the GWAS phenotype database.';


-- Role: phenodb_owner
-- DROP ROLE phenodb_owner;
CREATE ROLE phenodb_owner WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_owner IS 'Full read/write access to the GWAS phenotype database.';
GRANT phenodb_owner TO phenodb;

-- Role: phenodb_coworker
-- DROP ROLE phenodb_coworker;
CREATE ROLE phenodb_coworker WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_coworker IS 'Can read and write non-protected data in the GWAS phenotype database.';
GRANT phenodb_coworker TO phenodb_owner;

-- Role: phenodb_user
-- DROP ROLE phenodb_user;
CREATE ROLE phenodb_user WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_user IS 'Can read non-protected data in the GWAS phenotype database and write to designated areas.';
GRANT phenodb_user TO phenodb_coworker;

-- Role: phenodb_reader
-- DROP ROLE phenodb_reader;
CREATE ROLE phenodb_reader WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
COMMENT ON ROLE phenodb_reader IS 'Can read non-protected data in the GWAS phenotype database.';
GRANT phenodb_reader TO phenodb_user;

