/*
Questions: What skills are required for the top paying data analyst jobs?
- Use the top 10 highest paying Data Analyst jobs from first query
- Add the specific skills required for these roles
Why? It provides a detailed look at which high paying jobs demand certain skills, helping job seekers understand which skills to develop that aligh with top salaries.
*/

WITH top_paying_jobs AS(
    SELECT  
        job_id,
        job_title,
        salary_year_avg,
        job_posted_date,
        company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

-- his answer
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC


/*
This was my answer that went a step forward than what was asked by aggregating the top skills 
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skill_id) AS skill_count
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    skill_count DESC
*/