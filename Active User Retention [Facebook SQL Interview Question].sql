-- SELECT * FROM user_actions;

-- obtain active user retention in July 2022
-- month in numerical format 1,2,3
-- number of monthly active users

-- An active user is a user who has user action ("sign-in", "like", or "comment") 
-- in the current month and last month.

-- Approach
-- 1. get month of user_action through event_date
-- 2. count number of active users (count, case when)
-- 3. order by month, user_id
-- 4. join previous month and current month to find previous month active users (inner join)
-- 5. count the users left on table with that valid condition

WITH count_active_users AS (
  SELECT
    EXTRACT(MONTH from event_date) AS event_month,
    user_id,
    COUNT(DISTINCT(CASE WHEN event_type IN ('sign-in', 'like', 'comment') THEN user_id END)) AS active_users
  FROM user_actions
  GROUP BY
    event_month,
    user_id
  ORDER BY
    user_id ASC,
    event_month ASC
)
,
july_active_users AS (
  SELECT *
  FROM count_active_users
  WHERE event_month = 7
)
,
june_active_users AS (
  SELECT *
  FROM count_active_users
  WHERE event_month = 6
)
,
check_previous_month AS (
  SELECT
    j.*,
    p.active_users AS prev_month_active_users
  FROM
    july_active_users AS j
    INNER JOIN june_active_users AS p 
      ON j.user_id = p.user_id
      AND j.event_month = (p.event_month + 1)
)
SELECT
  event_month AS month,
  COUNT(active_users) AS monthly_active_users
FROM check_previous_month
GROUP BY
  month
