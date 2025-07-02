SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25

/* Top Insights from Data Analyst Salary Data:

1 Non-traditional tools pay more: Skills like SVN, Solidity, and Golang offer high salaries, indicating value in niche or cross-functional roles.

2 AI/ML tools are lucrative: Libraries like Datarobot, Keras, PyTorch, and Hugging Face suggest growing demand for analysts with machine learning skills.

3 DevOps/DataOps skills pay well: Tools like Terraform, VMware, Puppet, and Airflow show that infrastructure and automation knowledge boosts pay.

4 Cloud & streaming tools are valued: Kafka, Cassandra, and Airflow indicate demand for real-time data handling skills.

5 Programming beyond Python helps: Knowledge of Scala, Golang, or Perl sets candidates apart. */
