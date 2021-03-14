CREATE OR REPLACE VIEW sandbox.rpt_active_users as 
SELECT user_id active_user_id, --Active user id list
       MAX(cons_days) as max_cons_days --Maximum number of consecutive days on which user has triggered an event
FROM (SELECT user_id,
             day1,
             COUNT(*) cons_days
      FROM (SELECT row_number1,
                   event_date,
                   user_id,
                   event_date - row_number1::INTEGER day1 --Subtract row number from event date to get a generic date
            FROM (SELECT DISTINCT event_date,
                         user_id,
                         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date) AS row_number1 -- Row Number partitioned by user_id
                  FROM (SELECT DISTINCT event_date, user_id FROM sandbox.fact_event) AS b
                  ORDER BY user_id,
                           row_number1) AS a
            ORDER BY user_id,
                     row_number1) AS agg
      GROUP BY 1,
               2
      HAVING COUNT(*) >= 3) AS agg ---Business Rule Applied for active users  and Group by the generic day 
GROUP BY user_id
ORDER BY user_id;




