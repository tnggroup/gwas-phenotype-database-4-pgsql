/*
 * Sketch dat_cohort data tables for the covidcns cohort study.
 * assessment_cohort_country_cohortinstance
 */
 
 --TODO Add metadata entries!
 
-- DROP TABLE dat_cohort.qprospmetacog_covidcns_gb_2021;
CREATE TABLE dat_cohort.qprospmetacog_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT qprospmetacog_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.qprospmetacog_covidcns_gb_2021 IS 'Table for q_prospMetaCog.';

--INSERT INTO dat_cohort.tassessment_tcohort_tcohortinstance(_stage,spid,sex,var_time,var_alt_single1,var_alt_single1_comment,var_alt_multi1,var_alt_multi1_comment) VALUES('bl','CCNS19139',1,'2020-01-03 04:05:06+02',3,'Other choice','{1,3,4}','{NULL,NULL,"A comment. Some text."}')

CREATE TABLE dat_cohort.rsmanipulations2D_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsmanipulations2D_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsmanipulations2D_covidcns_gb_2021 IS 'Table for rs_manipulations2D.';


CREATE TABLE dat_cohort.rsTOL_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsTOL_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsTOL_covidcns_gb_2021 IS 'Table for rs_TOL.';

CREATE TABLE dat_cohort.rsverbalAnalogies_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsverbalAnalogies_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsverbalAnalogies_covidcns_gb_2021 IS 'Table for rs_verbalAnalogies.';

CREATE TABLE dat_cohort.rsmotorControl_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsmotorControl_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsmotorControl_covidcns_gb_2021 IS 'Table for rs_motorControl.';

CREATE TABLE dat_cohort.rsspatialSpan_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsspatialSpan_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsspatialSpan_covidcns_gb_2021 IS 'Table for rs_spatialSpan.';

CREATE TABLE dat_cohort.rstargetDetection_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rstargetDetection_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rstargetDetection_covidcns_gb_2021 IS 'Table for rs_targetDetection.';


CREATE TABLE dat_cohort.rsprospectiveMemoryWords1immediate_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsprospectiveMemoryWords1immediate_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsprospectiveMemoryWords1immediate_covidcns_gb_2021 IS 'Table for rs_prospectiveMemoryWords_1_immediate.';


CREATE TABLE dat_cohort.rsprospectiveMemoryWords1delayed_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --user_id character varying(9) NOT NULL,
    starttime timestamp with time zone,
	endtime timestamp with time zone,
	duration integer,
	version met.varcharcodesimple,
	summaryscore integer,
	rawdata character varying,
	exited integer,
	type integer,
	focusLossCount integer,
	timeOffScreen integer,
    CONSTRAINT rsprospectiveMemoryWords1delayed_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.rsprospectiveMemoryWords1delayed_covidcns_gb_2021 IS 'Table for rs_prospectiveMemoryWords_1_delayed.';

CREATE TABLE dat_cohort.mr1experiment_covidcns_gb_2021
(
    _id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    _stage met.varcharcodeletnum_lc NOT NULL,
	_individual_identifier uuid NOT NULL,
    --subject integer NOT NULL,
    scan_time timestamp with time zone,
	scan_no integer,
	scan_ttype integer,
	scan_resourcedicom character varying(600)[],
	scan_resourcesnapshots character varying(600)[],
	assessment1_resourcetest character varying(600)[],
    CONSTRAINT mr1experiment_covidcns_gb_2021_pkey PRIMARY KEY (_id)
);
COMMENT ON TABLE dat_cohort.mr1experiment_covidcns_gb_2021 IS 'Table for experiment MR1.';



