/*
Fictional Ecommerce Marketing data

Skills used: Window Functions, Aggregate functions, Joins
*/


--counting the number of first touches each of the multiple campaigns recived

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_source,
    ft_attr.utm_campaign,
    COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--counting the number of last touches each of the multiple campaigns recived

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source,
    lt_attr.utm_campaign,
    COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


----counting the number of distinct purchases made on a specified page 
    
SELECT DISTINCT COUNT(user_id) AS 'distinct purchase id'
FROM page_visits
WHERE page_name = '4 - purchase';


--counting the number of last touches that where made on a specific page

SELECT user_id, MAX(timestamp) AS last_touch_at
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY user_id
LIMIT 10;