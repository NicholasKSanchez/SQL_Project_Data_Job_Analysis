SELECT *
FROM job_postings_fact
LIMIT 100;

SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

-- type castings
SELECT '2023-02-19'::DATE;

SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date 
FROM
    job_postings_fact;

/*AT TIME ZONE
converts timestamps between different time zones
can be used on timestamps with or without time zone information
*/

-- this is the data without a time zone according to video all data is in UTC
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date_time
FROM
    job_postings_fact
LIMIT 5;

-- to add the time zone of est you must first convert to utc and then est
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT 5;

/*Extract
Gets field (e.g, year, month,date) from a date/time value

SELECT
    EXTRACT(MONTH FROM column_name) AS column_month
FROM
    table_name
*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 5;

--QUERY TO SEE A JOB COUNT PER MONTH
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE  
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;

/*
WRITE AN SQL QUERY TO FIND THE AVERAGE SALARY BOTH YEARLY AND HOURLY FOR JOB POSTINGS WHAT WERE POSTED AFTER JUNE 1,2023. GROUP RESULTS BY JOB SHCHEDULE TYPE
*/

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_salary_average,
    AVG(salary_hour_avg) AS average_hourly_salary
FROM
    job_postings_fact
WHERE  
    job_posted_date::DATE > '2023-06-01'
GROUP BY
    job_schedule_type;

/*
Write a query to count the number of job postings for each month in 2023, adjusting the job_posted_date to be in 'America/New York' time zone before extracting (hint) the month. Assume the job_posted_date is stored in UTC. Grou by and ordery by the month
*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'))  AS month
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month;

/*
Write a query to find companies(include company name) that have posted jobs offering health insurance, where these postings were made in the second quarter of 2023.
Use date extraction to filter by quarter
*/

SELECT
    companies.name,
    postings.job_health_insurance,
    EXTRACT(MONTH FROM(postings.job_posted_date)) AS date
FROM
    company_dim AS companies
LEFT JOIN job_postings_fact AS postings
ON companies.company_id = postings.company_id
WHERE
    postings.job_health_insurance = true AND (EXTRACT(MONTH FROM(postings.job_posted_date))) BETWEEN 4 AND 6; 

/*
Practice Problem 6
Create tables from Other Tables
-Create three tables:
Jan 2023 jobs
Feb 2023 jobs
Mar 2023 jobs
*/

CREATE TABLE january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
);

-- Create table for February jobs
CREATE TABLE february_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
);

-- Create table for March jobs
CREATE TABLE march_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
);

SELECT job_posted_date
FROM march_jobs;