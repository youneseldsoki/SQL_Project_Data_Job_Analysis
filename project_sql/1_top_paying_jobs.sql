/*
Question: What are the top-paying data scientist jobs?

- Identify the top 10 highest-paying Data Scientist roles that are available.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Scientists, offering insights into employment options and location flexibility.
*/


SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    CASE
        WHEN job_work_from_home = 'TRUE' THEN 'Yes'
        ELSE 'No'
    END AS work_from_home,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;