-------------------------------------------------Create Sandbox Schema---------------------------------------------------------
CREATE SCHEMA sandbox;
-------------------------------------------------STAGING TABLES ----------------------------------------------------------------
DROP TABLE IF EXISTS sandbox.stageUserData;---Stage Table for user data
CREATE TABLE sandbox.stageUserData(
   user_id    INTEGER  NOT NULL PRIMARY KEY 
  ,first_name VARCHAR(10) NOT NULL
  ,last_name  VARCHAR(12) NOT NULL
  ,email      VARCHAR(26) NOT NULL
  ,gender     VARCHAR(11) NOT NULL
);

DROP TABLE IF EXISTS sandbox.stageEventData;---Stage Table for event data
CREATE TABLE sandbox.stageEventData(
   event_date VARCHAR(10) NOT NULL 
  ,event_id   INTEGER  NOT NULL
  ,user_id    INTEGER  NOT NULL
  ,event_data VARCHAR(16) NOT NULL
);

-----------------------------------Table to keep multiplication factor and the key------------------------------------------------
DROP TABLE IF EXISTS sandbox.mul_fctr;--To generate annonyms user_id or any other id in future
CREATE TABLE sandbox.mul_fctr(
  key_nm varchar(20)
 ,fctr integer
);

---------------------------------------------User Dimension Creation---------------------------------
DROP TABLE IF EXISTS sandbox.dim_user;
CREATE TABLE sandbox.dim_user(
   user_id    INTEGER  NOT NULL PRIMARY KEY 
  ,first_name VARCHAR(10) NOT NULL
  ,last_name  VARCHAR(12) NOT NULL
  ,provider_domain  VARCHAR(20) NOT NULL
  ,gender     VARCHAR(11) NOT NULL
);

-------------------------------------------------Event Fact Creation---------------------------------------------------------
DROP TABLE if exists sandbox.fact_event;
CREATE TABLE sandbox.fact_event(
   event_date DATE  NOT NULL 
  ,event_id   INTEGER  NOT NULL
  ,user_id    INTEGER  NOT NULL
  ,event_data VARCHAR(16) NOT NULL
  ,week_num integer
);

------------------------------------------------Final Reporting table with all transformations------------------------------------------------------
DROP TABLE IF EXISTS sandbox.rpt_event;

CREATE TABLE sandbox.rpt_event
(
   week_num             integer,
   user_id              integer,
   provider_domain      varchar(20),
   provider_event_rate  numeric,
   overall_event_rate   numeric
);


-----------------------------------------------View on top of reporting table------------------------------------------------------------------------

CREATE OR REPLACE VIEW sandbox.v_rpt_event as select week_num,user_id,provider_domain,provider_event_rate,overall_event_rate from sandbox.rpt_event;


