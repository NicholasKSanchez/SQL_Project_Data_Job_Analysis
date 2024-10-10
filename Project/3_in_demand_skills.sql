/*
Question: What are the most in demand skills for data analysts?
- Join job postings to inner join tables similar to query 2
- identify the top 5 in-demand skills for a data analyst.
- focus on all job postings.
- Why? Retrieves the top 5 skills iwth the highes demand in the job market, providing insights into the most valuable skills for job seekers.
*/

-- hey idiot make sure your joins are right next time before wasting an hour of time
SELECT 
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;