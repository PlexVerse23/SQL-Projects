SELECT 
    skills,
    count(job_postings_fact.job_id) as demand
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND job_work_from_home = true
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 5