# Introduction
This project aims to explore top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics for the data job market.

You an find the SQL queries here: [Project folder](/Project/)
# Background
This projects main goal was to improve my skills with SQL and analysis by analyzing the data analyst job market. To do this this project aims to pinpoint top-paid and in-demand skills. 

The data used is from [Luke Barousse's SQL Course](https://lukebarousse.com/sql)

### Questions that are answered with the SQL queries:

1. What are the top-paying data analyst jobs
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to know?

# Tools I Used
Here are the tools that I used to accopmlish the analysis:

- **SQL**: Used to query the database
- **PostgreSQL**: The database management system used to store the data
** Visual Studio Code**: Used to connect to the database, write, and execute queries.
- **Git and GitHub**: Version control and sharing the SQL scripts and analysis.
# The Analysis
Each query for the project was aimed at investigating specific aspects of the data analyst job market. Below is how I approached each question:

### Top Paying Data Analyst Jobs
To identify the highest-paying roles I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT  
    job_id,
    job_title,
    job_location,
    Job_schedule_type,
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
LIMIT 10;
```
### Skills Required for Top-Paying jobs
In order to do this I built on top of the previous query by filtering for the skills required by each in order to create a list of jobs and skills that you can take a glance at.

```sql
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

### Most In-Demand skills for Data Analysts
To identify the most In-Demand skills I counted the appearance of each skill for each of the posted jobs. This query highlights the specific skills that are the msot sought after.

```sql
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
```

### Which skills are associated with higher salaries
With this query I tooke the average salary of the job postings that demanded each skill and presented them in descending order. This provides the opportunity to see which high paying jobs are associated with certain skills.

```sql
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
```

### The most optimal skills to know
With this query I filted for the salary and the demand of each skill and ordered by both. It shows a clear view of the skills that provide the highest salaries and are also in demand.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;
```

# What I learned

# Conclusions