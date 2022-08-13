/*

VR Startup Company

Skills Used: Inner Join, Left Join, Case Statement, Aggregate Function

*/


--Return the name of projects not picked by employees

SELECT project_name
FROM projects
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);


--Return the name of projects picked by the most employees

SELECT project_name
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY project_name
ORDER BY COUNT(employee_id) DESC
LIMIT 1;


--REturn the projects picked by multiple employees

SELECT project_name
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY current_project
HAVING COUNT(current_project) > 1;


--Return the number of positions for developers where at least two spots need to be filled by developers

SELECT (COUNT(*) * 2) - (
  SELECT COUNT(*)
  FROM employees
  WHERE current_project IS NOT NULL
   AND position = 'Developer') AS 'Count'
FROM projects;


--Return the outcome of the Myers-Briggs personality test given by the company to employees

SELECT personality
FROM employees
GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1;


--Return the most common personality found 

SELECT project_name
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE personality = (
  SELECT personality
  FROM employees
  GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1);



--Return the most commen personailty represented by each project

SELECT last_name, first_name, personality, project_name
FROM employees
INNER JOIN projects
ON employees.current_project = projects.project_id
WHERE personality = (
  SELECT personality
  FROM employees
  WHERE current_project IS NOT NULL
  GROUP BY personality
  ORDER BY COUNT(personality) DESC
  LIMIT 1);



  --Return the employee first and last name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers

SELECT last_name, first_name, personality, project_name,
CASE 
   WHEN personality = 'INFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
      WHEN personality = 'ENFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
      WHEN personality = 'INFJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
      WHEN personality = 'ENFJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
   WHEN personality = 'ISFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ'))
   WHEN personality = 'ESFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ISTP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ESTP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ISFJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ESFJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ISTJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
      WHEN personality = 'ESTJ' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ', 'ENFJ'))
   ELSE 0
END AS 'IMCOMPATS'
FROM employees
LEFT JOIN projects on employees.current_project = projects.project_id;