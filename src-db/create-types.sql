CREATE TYPE met.sex AS ENUM ('male','female','other','mix','unspecified');

--drop domain met.intpos;
CREATE DOMAIN met.intpos AS integer constraint intpos CHECK (VALUE >= 0);
--drop domain met.intoneindex;
CREATE DOMAIN met.intoneindex AS integer constraint intoneindex CHECK (VALUE > 0);
--drop domain met.intyearmodern;
CREATE DOMAIN met.intyearmodern AS integer constraint intyearmodern CHECK (VALUE >= 1900 AND VALUE <=2199);
--drop domain met.varcharcodeletnum;
CREATE DOMAIN met.varcharcodeletnum AS character varying(100) constraint varcharcodeletnum CHECK (VALUE ~* '^[A-Za-z0-9]+' OR VALUE='');
--drop domain met.varcharcodeletnum_lc;
CREATE DOMAIN met.varcharcodeletnum_lc AS character varying(100) constraint varcharcodeletnum_lc CHECK (VALUE ~* '^[a-z0-9]+' OR VALUE='');
--drop domain met.varcharcodeletnum_uc;
CREATE DOMAIN met.varcharcodeletnum_uc AS character varying(100) constraint varcharcodeletnum_uc CHECK (VALUE ~* '^[A-Z0-9]+' OR VALUE='');
--drop domain met.varcharcodesimple;
CREATE DOMAIN met.varcharcodesimple AS character varying(100) constraint varcharcodesimple CHECK (VALUE ~* '^[A-Za-z0-9_\-\.]+' OR VALUE='');
--drop domain met.varcharcodesimple_lc;
CREATE DOMAIN met.varcharcodesimple_lc AS character varying(100) constraint varcharcodesimple_lc CHECK (VALUE ~* '^[a-z0-9_\-\.]+' OR VALUE='');
--drop domain met.varcharcodesimple_uc;
CREATE DOMAIN met.varcharcodesimple_uc AS character varying(100) constraint varcharcodesimple_uc CHECK (VALUE ~* '^[A-Z0-9_\-\.]+' OR VALUE='');
--drop domain met.countryiso_uc;
CREATE DOMAIN met.countryiso_uc AS character(2) constraint countryiso_uc CHECK (VALUE ~* '^[A-Z]+' OR VALUE='');


