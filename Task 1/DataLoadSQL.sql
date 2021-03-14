
insert into sandbox.mul_fctr values('user_id',2); --2 is the secret key used here to conver user_id into annonyms user_id

------------------------------------------------Data Load into User Dimension----------------------------------------------------------------------

truncate table sandbox.dim_user;
INSERT INTO sandbox.dim_user
(
  user_id,
  first_name,
  last_name,
  provider_domain,
  gender
)
SELECT user_id*mul_fctr.fctr, ---This will multiply the original user_id with the factor that is kept in the sandbox.mul_fctr table
       first_name,
       last_name,
       SPLIT_PART(SPLIT_PART(email,'@',2),'.',1),--This will remove the user name from the email and just keep the domain provider name 
       gender
FROM sandbox.stageUserData
inner join  sandbox.mul_fctr mul_fctr ON key_nm='user_id' ;--joined the sandbox.mul_fctr table on key_nm.

-------------------------------------------------Data Load into Event Fact---------------------------------------------------------

TRUNCATE TABLE sandbox.fact_event;

INSERT INTO sandbox.fact_event
SELECT TO_DATE(event_date,'DD.MM.YY') AS event_date, --Converted the date into a sql equivalent date format
       event_id,
       user_id*mul_fctr.fctr,---This will multiply the original user_id with the factor that is kept in the sandbox.mul_fctr table
       event_data,
       DATE_PART('week',TO_DATE(event_date,'DD.MM.YY')) AS week_num --Created week number which can be used further
FROM sandbox.stageEventData
  INNER JOIN sandbox.mul_fctr mul_fctr ON key_nm = 'user_id';--joined the sandbox.mul_fctr table on key_nm.



-----------------------------------Temporary Table Creation with some transformations---------------------------------------------------------------
---Aggregated the event data on user_id and week number
Drop table if exists  sandbox.temp_reporting;
create table sandbox.temp_reporting as
select Event.user_id,
Event.week_num,
Userdata.provider_domain,
count(Event.event_id) as no_of_events_triggered from sandbox.fact_event Event
left join sandbox.dim_user Userdata ON Event.user_id=Userdata.user_id 
group by 1,2,3;

-----------------------------------------------Data Load into Reporting Table-------------------------------------------------------------------------
 
insert into sandbox.rpt_event 
SELECT distinct fact_e.week_num,
       fact_e.user_id,
       agg.provider_domain,
       TRUNC(agg.no_of_events_triggered / domain_wise_events,3) AS provider_event_rate,
       TRUNC(agg.no_of_events_triggered / totl_events,3) overall_event_rate
FROM sandbox.fact_event fact_e
  LEFT JOIN (SELECT a.*,
                    b.domain_wise_events,
                    c.totl_events
             FROM sandbox.temp_reporting a
               LEFT JOIN (SELECT provider_domain,week_num,
                                 SUM(no_of_events_triggered) domain_wise_events
                          FROM sandbox.temp_reporting
                          GROUP BY 1,2) AS b ON a.provider_domain = b.provider_domain and a.week_num=b.week_num
               LEFT JOIN (SELECT week_num,SUM(no_of_events_triggered) totl_events
                          FROM sandbox.temp_reporting group by 1) c ON a.week_num=c.week_num) agg ON fact_e.user_id = agg.user_id and fact_e.week_num=agg.week_num;