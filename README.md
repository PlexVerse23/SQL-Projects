# 📊 SQL Projects Portfolio

Welcome to my personal SQL project portfolio!  
This repository is a growing collection of case studies built using real-world inspired datasets. Each project aims to solve specific business questions using SQL and uncover insights from data using analytical thinking.

---

## 🗂️ Projects Listed

Below are some of the projects I’ve worked on using SQL. Each one is designed to explore different aspects of data analysis — from customer behavior and product trends to reward systems and salary analysis.

---

## 📍 Project 1: Data Analyst Job Market Exploration

This project dives deep into the world of data analyst job listings, uncovering high-paying roles, top-demanded skills, and where opportunities meet salary potential. The goal was to simulate a job market analysis one might perform as a business analyst or data-driven career strategist.

---

### 📊 Sample Insight  
<p align="center">
  <img src="assets/top_skills_chart.png" alt="Top Paying Skills Chart" width="500"/>
</p>

One of the highlights from this project was identifying the top-paying skills for remote data analyst jobs. **SQL**, **Python**, and **Tableau** emerged as the most valued by companies like Meta, AT&T, and SmartAsset.

---

### 🛠️ Techniques & Tools Used  
- SQL Joins & Aggregations  
- Common Table Expressions (CTEs)  
- Window Functions like DENSE_RANK and ROW_NUMBER  
- PostgreSQL & Visual Studio Code  
- Real-World Data Exploration  
- Insight Presentation with Charts & Tables

---

### 📎 [Check out full project here](Analysis of Salary/README.md)


## 📍 Project 2: The Zomato Project — Customer & Product Insights

This project simulates a food delivery platform's dataset (inspired by Zomato) to analyze customer behavior, product trends, and the impact of loyalty programs like gold memberships.

The analysis covers:

- Total spend per customer  
- Most popular products  
- First & last purchases related to loyalty upgrades  
- A custom-built **reward point system** based on purchase value and product type

### 🧾 Sample Insight — Most Purchased Products

| product_id | purchases |
|------------|-----------|
|     2      |     6     |
|     1      |     5     |
|     3      |     4     |

> *Product 2 is the most popular item across all users — a potential driver of customer loyalty or promotions.*

### 🛠️ Techniques Used

- Joins across multiple tables (`JOIN`, `LEFT JOIN`)
- Ranking with window functions (`DENSE_RANK`, `RANK`)
- Subqueries and CTEs for clean query structuring
- Conditional logic using `CASE`
- Aggregation and date-based filtering

👉 [🔗 Check out the full Zomato project here](./zomato-project/README.md)

---

More projects will be added soon! Stay tuned 🚀
