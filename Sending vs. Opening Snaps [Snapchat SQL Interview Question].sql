-- SELECT * FROM activities;
WITH user_time_spent AS (
  SELECT
    ag.age_bucket,
    SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) AS send_time_spent,
    SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) AS open_time_spent,
    SUM(CASE WHEN a.activity_type <> 'chat' THEN a.time_spent ELSE 0 END) AS total_time_spent
  FROM
    activities AS a
    LEFT JOIN
      age_breakdown ag 
      ON a.user_id = ag.user_id
  GROUP BY
    ag.age_bucket
)

SELECT
  age_bucket,
  ROUND(send_time_spent / total_time_spent * 100, 2) AS send_perc,
  ROUND(open_time_spent / total_time_spent * 100, 2) AS open_perc
FROM
  user_time_spent