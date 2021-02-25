BEGIN TRANSACTION;

/**phenodb_architect**/

REVOKE ALL ON SCHEMA met FROM "phenodb_architect";
GRANT ALL ON SCHEMA met TO "phenodb_architect"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA met FROM "phenodb_architect";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO "phenodb_architect";
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA met TO "phenodb_architect";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA met FROM "phenodb_architect";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT SELECT, UPDATE, USAGE ON SEQUENCES TO "phenodb_architect";
GRANT SELECT, UPDATE, USAGE ON ALL SEQUENCES IN SCHEMA met TO "phenodb_architect";

--REVOKE ALL ON ALL FUNCTIONS IN SCHEMA met FROM "phenodb_architect";

--ALTER DEFAULT PRIVILEGES IN SCHEMA met
--GRANT EXECUTE ON FUNCTIONS
--TO "phenodb_architect";

--ALTER DEFAULT PRIVILEGES IN SCHEMA met
--GRANT USAGE ON TYPES
--TO "phenodb_architect";

--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA i TO "phenodb_architect";


REVOKE ALL ON SCHEMA phe FROM "phenodb_architect";
GRANT ALL ON SCHEMA phe TO "phenodb_architect"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA phe FROM "phenodb_architect";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO "phenodb_architect";
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA phe TO "phenodb_architect";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA phe FROM "phenodb_architect";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT SELECT, UPDATE, USAGE ON SEQUENCES TO "phenodb_architect";
GRANT SELECT, UPDATE, USAGE ON ALL SEQUENCES IN SCHEMA phe TO "phenodb_architect";

--REVOKE ALL ON ALL FUNCTIONS IN SCHEMA phe FROM "phenodb_architect";


/**phenodb_phenotype_editor**/

REVOKE ALL ON SCHEMA phe FROM "phenodb_phenotype_editor";
GRANT ALL ON SCHEMA phe TO "phenodb_phenotype_editor"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA phe FROM "phenodb_phenotype_editor";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO "phenodb_phenotype_editor";
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA phe TO "phenodb_phenotype_editor";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA phe FROM "phenodb_phenotype_editor";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT USAGE ON SEQUENCES TO "phenodb_phenotype_editor";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA phe TO "phenodb_phenotype_editor";


/**phenodb_phenotype_reader**/

REVOKE ALL ON SCHEMA phe FROM "phenodb_phenotype_reader";
GRANT ALL ON SCHEMA phe TO "phenodb_phenotype_reader"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA phe FROM "phenodb_phenotype_reader";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT SELECT ON TABLES TO "phenodb_phenotype_reader";
GRANT SELECT ON ALL TABLES IN SCHEMA phe TO "phenodb_phenotype_reader";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA phe FROM "phenodb_phenotype_reader";
ALTER DEFAULT PRIVILEGES IN SCHEMA phe
GRANT USAGE ON SEQUENCES TO "phenodb_phenotype_reader";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA phe TO "phenodb_phenotype_reader";


/**phenodb_metadata_editor**/

REVOKE ALL ON SCHEMA met FROM "phenodb_metadata_editor";
GRANT ALL ON SCHEMA met TO "phenodb_metadata_editor"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA met FROM "phenodb_metadata_editor";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO "phenodb_metadata_editor";
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA met TO "phenodb_metadata_editor";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA met FROM "phenodb_metadata_editor";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT USAGE ON SEQUENCES TO "phenodb_metadata_editor";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA met TO "phenodb_metadata_editor";


/**phenodb_metadata_reader**/

REVOKE ALL ON SCHEMA met FROM "phenodb_metadata_reader";
GRANT ALL ON SCHEMA met TO "phenodb_metadata_reader"; -- WITH GRANT OPTION;

REVOKE ALL ON ALL TABLES IN SCHEMA met FROM "phenodb_metadata_reader";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT SELECT ON TABLES TO "phenodb_metadata_reader";
GRANT SELECT ON ALL TABLES IN SCHEMA met TO "phenodb_metadata_reader";

REVOKE ALL ON ALL SEQUENCES IN SCHEMA met FROM "phenodb_metadata_reader";
ALTER DEFAULT PRIVILEGES IN SCHEMA met
GRANT USAGE ON SEQUENCES TO "phenodb_metadata_reader";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA met TO "phenodb_metadata_reader";





COMMIT;
