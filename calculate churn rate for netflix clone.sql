/*
Calculating the chur rate for a netflix clone

Skills used: Union, Cross Joins, Temperary Tables, Case, Aggregate, CTEs
*/




--looking at table

SELECT *
FROM subscriptions
LIMIT 10; 

--looking at date ranges from table

SELECT MAX(subscription_start), MIN(subscription_start)
FROM subscriptions;



--looking at churn rate data from A/B testing
--selecting and combining data from the first three months
--first creating temp table months for the first three months
--second create temp table cross join for subscriptions and months
--third create temp table status from cross join table
--fourth create case statments for both segments 87 and 30 to find users who existed prior to beginning of the month
--fifth add segment to indicate if subscription was canceled partway through the month
--sixth create status_aggregate temp table to sum the active and cancelled subscriptions for each month
--seventh calculate the churn rate of the two segments

WITH months AS (
  SELECT
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
   SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION
     SELECT
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day 
),
cross_join AS(
  SELECT *
  FROM subscriptions
  CROSS JOIN months
),
status AS (
  SELECT id, first_day AS month,
  CASE 
    WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 87)
    THEN 1
   ELSE 0
  END AS is_active_87,
  CASE 
  WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 30)
    THEN 1
   ELSE 0
  END AS is_active_30,
CASE
  WHEN (subscription_end BETWEEN first_Day AND last_day) AND (segment = 87) THEN 1
    ELSE 0
  END AS is_canceled_87,
CASE
  WHEN (subscription_end BETWEEN first_Day AND last_day) AND (segment = 30) THEN 1
    ELSE 0
  END AS is_canceled_30
  FROM cross_join  
),
status_aggregate AS (
  SELECT month,
  SUM(is_active_87) AS sum_active_87,
  SUM(is_active_30) AS sum_active_30,
  SUM(is_canceled_87) AS sum_canceled_87,
  SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY month
)
SELECT
  month, 
  1.0 * sum_canceled_87 / sum_active_87 AS churn_rate_87,
  1.0 * sum_canceled_30 / sum_active_30 AS churn_rate_30  
FROM status_aggregate;












