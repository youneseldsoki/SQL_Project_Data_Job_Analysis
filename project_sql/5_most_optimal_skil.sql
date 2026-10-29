/*
Question: Which skills offer the best combination of demand and salary for Data Scientists?

- Remove duplicate job-skill associations to prevent inflated demand counts and biased salary averages.
- Calculate the average annual salary associated with each skill.
- Determine the relative demand for each skill among Data Scientist job postings.
- Combine both metrics into a demand-weighted salary score.
- Include only job postings with reported salaries, regardless of location.

Why?
The score combines salary and market demand to identify skills that are both financially attractive and frequently requested.

Formula:
weighted_salary_score = avg_salary * demand_ratio

A higher score represents a stronger combination of demand and advertised salary.

Limitations:
- Demand does not represent the probability of getting hired.
- Skills may occur together, so salary differences cannot be attributed to individual skills.
- The analysis does not account for learning effort or existing qualifications.
*/



-- Total number of Data Scientist job postings with specified salaries
WITH total_jobs AS (
    SELECT 
        COUNT(*) AS job_count
    FROM 
        job_postings_fact
    WHERE 
        job_title = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
),

-- Cleaning the data to ensure each skill is counted only once per job posting
unique_job_skills AS (
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
),

-- Calculating demand count, average salary, and demand ratio for each skill
skill_metrics AS (
    SELECT
        skills,
        COUNT(*) AS demand_count,
        AVG(salary_year_avg) AS avg_salary,
        COUNT(*) * 1.0 / (SELECT job_count FROM total_jobs) AS demand_ratio
    FROM
        unique_job_skills
    GROUP BY
        skills
)

-- Final selection of skills with their demand count, average salary, demand ratio, and weighted salary score
SELECT
    skills,
    demand_count,
    ROUND(avg_salary, 0) AS avg_salary,
    ROUND(demand_ratio, 4) AS demand_ratio,
    ROUND(avg_salary * demand_ratio, 0) AS weighted_salary_score
FROM 
    skill_metrics
ORDER BY 
    weighted_salary_score DESC;
