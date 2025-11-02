-- SQL Question
-- https://platform.stratascratch.com/coding/2054-consecutive-days/submissions?code_type=3



--  MY SOLUTION:
with first_cte as (
    select 
        distinct 
            user_id,
            record_date
    from 
        sf_events
    order by user_id,record_date 
),
second_cte as (
    select 
        user_id,
        record_date,
        lag(record_date,2) over(partition by user_id order by record_date) as past_3
    from
        first_cte
)
select 
    distinct user_id 
from 
    second_cte
where record_date-past_3=2;





--  There and best solution: 

WITH ordered_dates AS (
    SELECT 
        user_id,
        record_date,
        DATE_SUB(record_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY record_date) DAY) AS grp
    FROM sf_events
),
grouped AS (
    SELECT 
        user_id,
        MIN(record_date) AS start_date,
        MAX(record_date) AS end_date,
        COUNT(*) AS streak_length
    FROM ordered_dates
    GROUP BY user_id, grp
)
SELECT *
FROM grouped
WHERE streak_length >= 3;


-- 💡 Approach — Consecutive Dates Grouping Using ROW_NUMBER()
-- We use a clever date–index trick:
-- Assign each record a ROW_NUMBER() per user_id, ordered by record_date.
-- Subtract the row number (as days) from each date → this creates a group key (grp).
-- Consecutive dates produce the same grp value.
-- Group by (user_id, grp) and count streak length.
-- Filter where streak length ≥ 3.


-- Another good solution:
WITH ordered_dates AS (
  SELECT DISTINCT user_id, DATE(record_date) AS record_date
  FROM sf_events
),
rn AS (
  SELECT
    user_id,
    record_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY record_date) AS rn
  FROM ordered_dates
),
grps AS (
  SELECT
    user_id,
    record_date,
    DATE_SUB(record_date, INTERVAL rn DAY) AS grp
  FROM rn
),
agg AS (
  SELECT
    user_id,
    MIN(record_date) AS streak_start,
    MAX(record_date) AS streak_end,
    COUNT(*) AS streak_length
  FROM grps
  GROUP BY user_id, grp
)
SELECT user_id, streak_start, streak_end, streak_length
FROM agg
WHERE streak_length >= 3
ORDER BY user_id, streak_start;
