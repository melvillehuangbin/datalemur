-- SELECT * FROM user_transactions;

-- YoY growth rate for total spend of each product for each year
-- Output the year (in ascending order) partitioned by product id, current year's spend, 
-- previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

-- Approach
-- 1. find yearly spending for each product, year (sum, group by)
-- 2. get previous year spending of product (lag, partition, order by)
-- 3. calculate yoy rate = curr - prev / prev * 100 (round) 

WITH product_spending AS (
  SELECT
    EXTRACT(YEAR FROM transaction_date) AS transaction_year,
    product_id,
    SUM(spend) AS curr_year_spend
  FROM user_transactions
  GROUP BY
    transaction_year,
    product_id
)
,
prev_spending AS (
  SELECT
    *,
    LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY transaction_year ASC) AS prev_year_spend
  FROM product_spending
)
SELECT
  *,
  ROUND((curr_year_spend - prev_year_spend) / prev_year_spend * 100, 2) AS yoy_rate
FROM prev_spending