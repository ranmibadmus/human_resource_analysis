SELECT * FROM hr 

-- QUESTIONS FOR HR PROJECT DATA CLEANING --

--1. What is the gender breakdown of employees in the company? --
SELECT gender, count (*) AS count
FROM hr
WHERE age <= 65 AND termdate IS NULL
GROUP BY gender;

--2. What is the race/ethnicity breakdown of employees in the company? --
SELECT race, count(*) AS count
FROM hr
WHERE age <= 65 AND termdate IS NULL
GROUP BY race
ORDER BY count DESC;

--3. What is the age distribution of employees in the company? --
SELECT
	min(age) AS youngest,
	max(age) AS eldest
FROM hr
WHERE age <= 65 AND termdate IS NULL

SELECT
CASE
	WHEN age BETWEEN 18 AND 24 THEN '18-24'
	WHEN age BETWEEN 25 AND 34 THEN '25-34'
	WHEN age BETWEEN 35 AND 44 THEN '35-44'
	WHEN age BETWEEN 45 AND 54 THEN '55-54'
	WHEN age BETWEEN 55 AND 64 THEN '55-64'
	ELSE '65+'
END AS age_group,
count(*) AS count
FROM hr
WHERE age <= 65 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

--4. How many employees work at headquarters versus remote locations? --
SELECT location, count(*) AS count
FROM hr
WHERE age <= 65 AND termdate IS NULL
GROUP BY location;

--5. What is the average length of employment for employees who have been terminated? --
SELECT
    ROUND(AVG(EXTRACT(YEAR FROM AGE(termdate, hire_date))), 0) AS avg_length_employment
FROM hr
WHERE termdate <= CURRENT_DATE
    AND termdate IS NOT NULL
    AND age <= 65;

--6. How does the gender distribution vary across departments and job titles? --
SELECT department, gender, count(*) AS count
FROM hr
WHERE  age <= 65 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

--7. WHat is the distribution of job titles across the company? --
SELECT jobtitle, count(*) AS count
FROM hr
WHERE  age <= 65 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

--8. Which department has the highest turnover rate? --
SELECT department,
    total_count,
    terminated_count,
    terminated_count::float / total_count AS termination_rate
FROM (
    SELECT department,
        count(*) AS total_count,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age <= 65
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

--9. What is the distribution of employees across locations by city and state? --
SELECT location_state, count(*) AS count
FROM hr
WHERE  age <= 65 AND termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

--10. How has the company employee count changed over time based on hire and term dates? --
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations)::numeric / hires * 100, 2) AS net_change_percent
FROM (
    SELECT
        EXTRACT(YEAR FROM hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age <= 65
    GROUP BY EXTRACT(YEAR FROM hire_date)
) AS subquery
ORDER BY year ASC;

--11. What is the tenure distribution for each department? --
SELECT department, ROUND(AVG(EXTRACT(YEAR FROM AGE(termdate, hire_date))), 0) AS avg_tenure
FROM hr
WHERE termdate <= CURRENT_DATE AND termdate IS NOT NULL AND age <= 65
GROUP BY department;
