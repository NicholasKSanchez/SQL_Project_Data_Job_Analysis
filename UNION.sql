/*
UNION Operators 
Combine result sets of two or more SELECT statements into a single result set.
UNION: remove duplicate rows
UNION ALL: includes all duplicate rows

Each SELECT statement within the UNION must have the same number of columns in the result sets with similar data types

UNITON
combines results from two or more SELECT statements

they need to have the same amount of columns, and the data type must match

does not return duplicates

UNION ALL
combine the result of two or more SELECT statements
they need to have the same amount of columns, and the data type must match

returns all rows even duplicates
*/


SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

/*
Practice Problem
Find job postings from the first quarter that have a salary greater than 70k
- combine job posting tables from the first quarter of 2023
- Gets job postings with an average yearly salary > 70k
*/

-- my answer
WITH quarter_one AS (
    SELECT *
    FROM
        january_jobs
    UNION ALL
    SELECT *
    FROM
        february_jobs
    UNION ALL
    SELECT *
    FROM
        march_jobs
)

SELECT *
FROM quarter_one
WHERE
    salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg;

-- his answer

SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.Job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE quarter1_job_postings.salary_year_avg > 70000 AND
quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC