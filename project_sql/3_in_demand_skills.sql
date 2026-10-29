/*
Question: What are the most in-demand skills for data scientists?

- Identify the top 5 in-demand skills for a data scientist.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
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

-- Calculating the demand count for each skill
SELECT
    skills,
    COUNT(job_id) AS demand_count
FROM
    unique_job_skills
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;