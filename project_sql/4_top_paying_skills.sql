/*
Question: What are the top skills based on salary? 

- Look at the average salary associated with each skill for Data Scientist positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Scientists and helps identify the most financially rewarding skills to acquire or improve.
*/


-- Cleaning the data to ensure each skill is counted only once per job posting
WITH unique_job_skills AS (
    SELECT DISTINCT
        jp.job_id,
        sd.skills,
        jp.salary_year_avg
    FROM 
        job_postings_fact AS jp
    INNER JOIN 
        skills_job_dim AS sj ON jp.job_id = sj.job_id
    INNER JOIN 
        skills_dim AS sd ON sj.skill_id = sd.skill_id
    WHERE
        jp.job_title = 'Data Scientist'
        AND jp.salary_year_avg IS NOT NULL
)

-- Calculating the average salary for the top 100 skills based on their associated salaries
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    unique_job_skills
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 100;