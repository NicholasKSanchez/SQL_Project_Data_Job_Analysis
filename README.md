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
Here are the tools that I used to accomplish the analysis:


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
Breakdown of the results of the above query:
- **Wide Salary Range**: The top 10 paying jobs for Data Analysts had a range of $184,000 to $650,000 which indicates that there is high potential to have a high salary job in this field.
- **Diverse Employers**: From the results every salary is from a different company such as Mantys, Meta, and AT&T indicating that many companies across industries are interested in Data Analytics.
- **Job Title Variety**: There are a variety of job titles such as Data Analyst, Director of Analytics, and Principal Data Analyst indicating that there are a variety of roles that can be filled as well as specializations within the field.


![Top Paying Roles](assets\top_paying_jobs_visual.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts. Used Google Sheets to visualize the result set.*
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
Breakdown of the results of the above query:
- **Variety of Skills**: This query indicates that Data Analytics value a variety of skills from their top paying jobs such as sql, python, azure, and aws. These skills show that coding as well as cloud knowledge are valued.
- **Overlap of skills**: There is much overlap between the different jobs and the skills that are demanded. For example: AT&T, Pinterest, and SmartAsset all demand sql, python, and excel.


![Skill Count for top paying jobs](assets\Skill_count_for_top_10_jobs.png)
*Visualization to show the skill counts for the top 10 paying jobs. Created using Google Sheets*
### Most In-Demand skills for Data Analysts
To identify the most In-Demand skills I counted the appearance of each skill for each of the posted jobs. This query highlights the specific skills that are the most sought after.


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
Breakdown of the results of the above query:
- **Highest in demand skills**: Most in demand skills are sql, excel, python, tableau, and powerbi.
- **Coding Languages are important**: SQL and python are very important to Data Analytics meaning that you should learn at least one of these to be successful. Since SQL demand count is much higher than python it seems beneficial to learn sql skills first.
- **Visualization**: Visualization skills are important considering both tableau and power bi made the top 5. Excel was the second most important skill lending to the importance of visualization as it also has those capabilities.


![Most Demanded Skills](assets\in_demand_visual.png)
*Visualization for the most in demand skills. Created using Google Sheets.*
### Which skills are associated with higher salaries
With this query I took the average salary of the job postings that demanded each skill and presented them in descending order. This provides the opportunity to see which high paying jobs are associated with certain skills.


*Bar graph visualizing the most in demand skills for data analysis. Created using Google Sheets.*
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
Breakdown of the results of the above query:
- **Small Range**: The range for these skills is fairly small ranging from $121,000 to 208,172.
- **Emphasis on Tools**: Jobs with the highest salaries tend to emphasize specific packages for coding language such as pyspark, and pandas. They also put an emphasis on experience with data and AI platforms such as couchbase, watson tools, and datarobot.


![Top Paying Skills](assets\Top_Paying_Skills.png)
*Visualization for the skills associated with the top paying jobs. Created using Google Sheets.*
### The most optimal skills to know
With this query I filtered for the salary and the demand of each skill and ordered by both. It shows a clear view of the skills that provide the highest salaries and are also in demand.


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
- **Data and Cloud Platforms important for high salaries**: It is important to have knowledge of data platforms such as hadoop, and snowflake. It is also important to have knowledge of cloud platforms such as AWS and Azure. Coding languages such as java, python, and r are also extremely important.
- **Smallest Range Yet**: The range of salaries for the optimal skills is much smaller than the previous ranges sitting only at $97,000 to $115,000.
- ***Most in demand skills**: Although data and cloud platform knowledge will seem to get you the most high salaries, the amount of demand for python, r, and tableau is much higher. This means that if you want a higher chance of getting a job you should have these 3 skills.


| skill_id | skills     | demand_count | average_salary |
|----------|------------|--------------|----------------|
| 8        | go         | 27           | 115320         |
| 234      | confluence | 11           | 114210         |
| 97       | hadoop     | 22           | 113193         |
| 80       | snowflake  | 37           | 112948         |
| 74       | azure      | 34           | 111225         |
| 77       | bigquery   | 13           | 109654         |
| 76       | aws        | 32           | 108317         |
| 4        | java       | 17           | 106906         |
| 194      | ssis       | 12           | 106683         |
| 233      | jira       | 20           | 104918         |
| 79       | oracle     | 37           | 104534         |
| 185      | looker     | 49           | 103795         |
| 2        | nosql      | 13           | 101414         |
| 1        | python     | 236          | 101397         |
| 5        | r          | 148          | 100499         |
| 78       | redshift   | 16           | 99936          |
| 187      | qlik       | 13           | 99631          |
| 182      | tableau    | 230          | 99288          |
| 197      | ssrs       | 14           | 99171          |
| 92       | spark      | 13           | 99077          |
| 13       | c++        | 11           | 98958          |
| 186      | sas        | 63           | 98902          |
| 7        | sas        | 63           | 98902          |
| 61       | sql server | 35           | 97786          |
| 9        | javascript | 20           | 97587          |
*Result set for the above query. Markdown created using ChatGPT.
# What I learned
Throughout this journey I was able to brush up on my SQL. It refreshed my memory on the more complicated aspects of SQL such as using joins, group bys, and aggregation.


It also allowed me to improve my analytical skills by going through the job data and figuring out trends for what the highest paying jobs are and what skills are often associated with Data Analysis jobs.


I also gained experience using tools such as ChatGPT to speed up mundane tasks such as creating markdown for github and visualizations.
# Conclusions
### Insights
1. Data Analysis offers jobs with high salaries. The top salary I found was $650,000.
2. The skills for top-paying jobs involve knowledge of cloud and data platforms but sql remains very important throughout all levels of data analysis.
3. The most demanded skill in the job market is SQL. It along with excel, python, r, tableau, and powerbi are essential skills for new job seekers.
4. For job with higher salaries more specialized skills are required such as snowflake, solidity, and SNV meaning there is potential to specialize and gain that bigger salary.
5. The most optimal skill for data analysis is clearly SQL. It is the most in demand job skill and offers a high average salary.


### Closing Thoughts
This project greatly enhanced my SQL skills and was able to prepare me for a technical interview that I did very well on. In addition it provided great insights into the data analyst job market. The findings serve as a way to understand which skills need to be prioritized during job search efforts. People trying to break into the data analyst field can prioritize these skills in order to allow themselves a higher chance of getting noticed and hired.
