-- SELECT * FROM inventory;
-- store most number of items in 500,000 square feet warehouse
-- stock as many prime items as possible
-- afterwards use reamining square footage to stock as much non-prime items as possible
-- find number of prime/non-prime items that can be stored
-- output: item_type, item_count

-- aproach
-- 1. find total square footage of prime_eligible items
-- 2. number of times to stock combination of prime_eligible items
-- 3. multiply by number of prime_eligible items
-- 4. volume (prime) - volume (non prime)
-- 5. get number of times to stock combination of non prime eligible items
-- 6. multiply by number of non-prime eligible items
-- 7. union result

WITH items AS (
  SELECT
    item_type,
    SUM(square_footage) AS item_volume,
    COUNT(item_id) AS item_count
  FROM inventory
  GROUP BY
    item_type
)
,
prime_items AS  (
  SELECT
    *
  FROM items
  WHERE item_type = 'prime_eligible'
)
,
not_prime_items AS  (
  SELECT
    *
  FROM items
  WHERE item_type = 'not_prime'
)
,
prime_count AS (
SELECT
  'prime_eligible' AS item_type,
  FLOOR(500000/(SELECT item_volume from prime_items)) AS stock_count,
  FLOOR(500000/(SELECT item_volume from prime_items))*(SELECT item_count from prime_items) AS item_count
)
,
not_prime_count AS (
  SELECT
    'not_prime' AS item_type,
    FLOOR((500000 - ((SELECT stock_count FROM prime_count) * (SELECT item_volume from prime_items))) / (SELECT item_volume from not_prime_items)) * (SELECT item_count from not_prime_items)
)
SELECT
  *
FROM (
  SELECT item_type, item_count from prime_count
  UNION 
  SELECT * from not_prime_count
) t
ORDER BY
  item_count DESC