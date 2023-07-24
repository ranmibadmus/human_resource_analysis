CREATE TABLE hr (id text,
				 first_name text,
				 last_name text,
				 birthdate text,
				 gender text,
				 race text,
				 department varchar,
				 jobtitle varchar,
				 location varchar,
				 hire_date varchar,
				 termdate varchar,
				 location_city text,
				 location_state text
				)
				
--import data --

SELECT * FROM hr;

-- Correct the birthdate format

UPDATE hr
SET birthdate = CASE
    WHEN birthdate ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN to_date(birthdate, 'MM/DD/YYYY')
    WHEN birthdate ~ '^\d{1,2}-\d{1,2}-\d{2}$' THEN
        CASE
            WHEN to_date(birthdate, 'MM-DD-YY') >= to_date('2000-01-01', 'YYYY-MM-DD')
                THEN to_date(birthdate, 'MM-DD-YY') - INTERVAL '100 years'
            ELSE to_date(birthdate, 'MM-DD-YY')
        END
    ELSE NULL
END;

-- Change birthdate datatype to date

ALTER TABLE hr
ALTER COLUMN birthdate TYPE DATE USING birthdate::DATE;

SELECT birthdate FROM hr;


SELECT hire_date FROM hr;

-- Correct hire_date date format
UPDATE hr
SET hire_date = CASE
    WHEN hire_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN to_date(hire_date, 'MM/DD/YYYY')
    WHEN hire_date ~ '^\d{1,2}-\d{1,2}-\d{2}$' THEN
        CASE
            WHEN to_date(hire_date, 'MM-DD-YY') >= to_date('2000-01-01', 'YYYY-MM-DD')
                THEN to_date(hire_date, 'MM-DD-YY') - INTERVAL '100 years'
            ELSE to_date(hire_date, 'MM-DD-YY')
        END
    ELSE NULL
END;

-- Change column datatype to date

ALTER TABLE hr
ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;

SELECT hire_date FROM hr;

-- hire date has values like 1908 which is wrong.

UPDATE hr
SET hire_date = TO_DATE(REPLACE(TO_CHAR(hire_date, 'YYYY-MM-DD'), '190', '200'), 'YYYY-MM-DD')
WHERE hire_date >= DATE '1900-01-01' AND hire_date < DATE '2000-01-01';

SELECT hire_date FROM hr


SELECT termdate FROM hr;

-- Convert termdate correct date format
UPDATE hr
SET termdate = DATE(termdate::timestamp)
WHERE termdate IS NOT NULL;

-- Change column data type to DATE
ALTER TABLE hr
ALTER COLUMN termdate TYPE DATE
USING termdate::DATE;

-- Handle NULL values
UPDATE hr
SET termdate = NULL
WHERE termdate IS NULL;

SELECT termdate FROM hr;

-- Add age column to calculate employees' age

ALTER TABLE hr
ADD COLUMN age int;

-- Calculate age based on birthdate and current year

UPDATE hr
SET age = EXTRACT(YEAR FROM age(current_date, birthdate));

SELECT age FROM hr;

SELECT birthdate, age FROM hr

SELECT 
	min(age) AS youngest,
	max(age) AS eldest
FROM hr;

-- Highlight number of persons in the table older than 65

SELECT count(*) FROM hr
WHERE age > 65;


SELECT * FROM hr;
