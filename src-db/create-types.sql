CREATE TYPE met.sex AS ENUM ('male','female','both','other','unspecified');

CREATE DOMAIN met.intpos AS integer CHECK (VALUE >= 0);
CREATE DOMAIN met.intoneindex AS integer CHECK (VALUE > 0);
CREATE DOMAIN met.intyearmodern AS integer CHECK (VALUE >= 1900 AND VALUE <=2199);
CREATE DOMAIN met.varcharcodeletnum AS character varying(100) CHECK (VALUE ~* '^[A-Za-z0-9]+');
CREATE DOMAIN met.varcharcodeletnum_lc AS character varying(100) CHECK (VALUE ~* '^[a-z0-9]+');
CREATE DOMAIN met.varcharcodeletnum_uc AS character varying(100) CHECK (VALUE ~* '^[A-Z0-9]+');
CREATE DOMAIN met.varcharcodesimple AS character varying(100) CHECK (VALUE ~* '^[A-Za-z0-9_\-\.]+');
CREATE DOMAIN met.varcharcodesimple_lc AS character varying(100) CHECK (VALUE ~* '^[a-z0-9_\-\.]+');
CREATE DOMAIN met.varcharcodesimple_uc AS character varying(100) CHECK (VALUE ~* '^[A-Z0-9_\-\.]+');
CREATE DOMAIN met.countryiso_uc AS character(2) CHECK (VALUE ~* '^[A-Z]+');


