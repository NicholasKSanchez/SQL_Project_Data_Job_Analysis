/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst postitions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact slaary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve
*/

-- modified query 1 to get this for a cleaner version see the provided answer
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
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
)

SELECT 
    skills_dim.skills,
    ROUND(AVG(top_paying_jobs.salary_year_avg), 0) as average_salary
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    average_salary DESC;

-- his answer
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25;