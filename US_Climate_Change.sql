/*
Climate Change Data Across The United States

Skills used: Window Function, Partition By Clause, Aggregate Function
*/


--Returning the table

SELECT * 
FROM state_climate
LIMIT 5;


--Returning the average temperature changes over time for each state

SELECT state, year, ROUND(tempf, 2) AS tempf_avg,
ROUND(AVG(tempf) OVER (PARTITION BY state
ORDER BY year), 2) AS 'running_avg_temp'
FROM state_climate
LIMIT 5;

--Returning the lowest temperature for each state

SELECT state, year, ROUND(tempf, 2) AS tempf_avg,
ROUND(first_value(tempf) OVER (PARTITION BY state ORDER BY tempf ), 2) AS 'running_min_temp'
FROM state_climate
LIMIT 5;

--Returning the highest temperature for each state

SELECT state, year, ROUND(tempf, 2) AS tempf_avg,
ROUND(last_value(tempf) OVER (PARTITION BY state ORDER BY tempf 
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) AS 'running_max_temp'
FROM state_climate
LIMIT 5;

--Returning the change in temperature from the preious year

SELECT state, year, ROUND(tempf, 2) AS temp_avg,
ROUND(LAG(tempf, 1, 0) OVER (PARTITION BY state ORDER BY year), 2) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC
LIMIT 5;

--Returning the coldest temperatures ranked from coldest to warmest

SELECT year, state, ROUND(tempf, 2) AS temp_avg,
RANK() OVER (ORDER BY tempf) AS rank
FROM state_climate
LIMIT 5;

--Returning the hottest temperatures ranked from hotest to coldest

SELECT year, state, ROUND(tempf, 2) AS temp_avg,
RANK() OVER (ORDER BY tempf DESC) AS rank
FROM state_climate
LIMIT 5;

-- return the average yearly temperatures in quartiles (4)

SELECT NTILE(4) OVER (PARTITION BY state) AS quartile, state, year, ROUND(tempf, 2) AS tempf1
FROM state_climate
LIMIT 5;

--return the average yearly temperatures in quintiles (5)

SELECT NTILE(5) OVER (ORDER BY tempf) AS quintile, state, year, ROUND(tempf, 2) AS tempf1
FROM state_climate
LIMIT 5;

