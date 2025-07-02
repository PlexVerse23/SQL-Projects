SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    count(job_postings_fact.job_id) as demand,
    ROUND(AVG(salary_year_avg),0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = true
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    count(job_postings_fact.job_id) > 10
ORDER BY
    average_salary DESC,
    demand DESC
LIMIT 25