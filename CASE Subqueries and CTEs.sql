/*
Case Expressions
A CASE expression is a way to apply conditional logic within your SQL queries
CASE begins the expression
WHEN specifies the condition to look at
THEN what to do when the condition is TRUE
ELSE provides output if none of the WHEN conditions are met
END concludes the CASE expression
*/

SELECT 
    job_title_short,
    job_location
FROM job_postings_fact;

/*

Lavel new column as follows:
- Anwhere jobs as Remote
- New York, NY as Local
- Otherwise Onsite
*/

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;


/*
Subqueries and CTEs
Subqueries and Common Table Expressions: Used for organizing and simplifying complex queries.

Subqueries: query nested inside a larger query
It can be used in SELECT, FROM, and WHERE clauses.

Common Tables Expressions (CTEs): define a temporary result set that you can reference
Can reference within a SELECT, INSERT, UPDATE, OR DELETE statement
Defined with WITH
*/

SELECT *
FROM ( --Subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
    -- Subquery ends here

WITH january_jobs AS ( --CTE definition starts here
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here

SELECT *
    FROM january_jobs


SELECT name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
            company_id
    FROM
            job_postings_fact
    WHERE
            job_no_degree_mention = TRUE
);

/*
Find the companies that have the most job openings.
- get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_count AS (
SELECT
    company_id,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

/*
find the count of the number of remote job postings per skill
    -display the top 5 skills by their demand in remote jobs
    -include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM   
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE  
        job_postings.job_work_from_home = true AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    remote_job_skills.skill_id,
    skills.skills,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5 