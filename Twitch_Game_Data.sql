/*
Analyzing Twitch Gaming Data

Skills used: Case Statement, Aggragate Function, strftime Function, Joins

*/


--Return table

SELECT *
FROM stream
LIMIT 5;
SELECT *
FROM chat
LIMIT 5;


--Return only unique games

SELECT DISTINCT game
FROM stream;
SELECT DISTINCT channel
FROM stream;


--Return the most popular games, group by view count

SELECT game, COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;


--Return specific game type stream viewers by country

SELECT country, COUNT(*)
FROM stream
WHERE game = 'League of Legends'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


--Return a list of viewers and what devices they are watching on

SELECT player, COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;


--Return newly created column and group game type into specified genre

SELECT game, 
CASE 
  WHEN game = 'League of Legends' THEN 'MOBA'
  WHEN game = 'Dota 2' THEN 'MOBA'
  WHEN game = 'Heroes of the Storm' THEN 'MOBA'
  WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
  WHEN game = 'DayZ' THEN 'Survival'
  WHEN game = 'ARK: Survival Evolved' THEN 'Survival'
  ELSE 'Other'
  END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;


--Return table

SELECT time
FROM stream
LIMIT 10;


--Returns the seconds counted from stream time

SELECT time,
   strftime('%S', time)
FROM stream
GROUP BY 1
LIMIT 20;


--Return the hours of stream time by specific country

SELECT strftime('%H', time), COUNT(*)
FROM stream
WHERE country = 'US'
GROUP BY 1;


--Return the join of the 'stream' and 'chat' tables

SELECT *
FROM stream
JOIN chat
ON stream.device_id = chat.device_id
LIMIT 5;























