-- SELECT * FROM transactions;
-- we want third transactions of every users
WITH rank_transactions AS (
  SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) AS transaction_rank
  FROM
    transactions
)

SELECT
  user_id,
  spend,
  transaction_date
FROM rank_transactions
WHERE transaction_rank = 3