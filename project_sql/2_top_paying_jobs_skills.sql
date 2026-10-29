/*
Question: What are the top-paying data scientist jobs, and what skills are required?

- Identify the top 10 highest-paying Data Scientist jobs and the specific skills required for these roles.
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/
WITH top_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_jobs.*,
    skills_dim.skills
FROM
    top_jobs
INNER JOIN
    skills_job_dim ON top_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_jobs.salary_year_avg DESC;