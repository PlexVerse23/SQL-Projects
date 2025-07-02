# 🍽️ The Zomato Project — SQL Analytics Case Study

![Zomato Banner](assets/zomato_banner.png)

> A SQL-based mini case study that simulates a food-tech platform like Zomato.  
> We explore user behavior, product performance, gold membership benefits, and a points-based reward system using a **sample dataset**.

🧠 Designed to work on **sample data**, yet scalable to any large-scale food delivery dataset!

---

## 📦 Dataset Overview

We simulate 4 core tables:

| Table Name         | Description                                      |
|--------------------|--------------------------------------------------|
| `users`            | User info & signup date                          |
| `sales`            | Transaction log (user, date, product purchased)  |
| `product`          | Menu items and prices                            |
| `goldusers_signup` | Records of users joining the Gold membership     |

> 💡 The dataset was generated using basic SQL insert statements. The goal was to analyze behavior, loyalty, and business impact using SQL only.

---

## 🛠 Tools Used

- **PostgreSQL** – For executing SQL queries
- **VS Code / DBeaver** – SQL IDE
- **Git & GitHub** – Version control and code management

---

## ❓ Business Questions Answered

Below is the list of analytical questions explored through SQL in this project:

1. 💸 What is the total amount each customer spent on Zomato?
2. 📅 How many days has each customer visited the platform?
3. 🛍️ What was the **first product** purchased by each customer?
4. 🔥 What is the **most purchased product** on the menu, and how many times was it bought?
5. 👤 What is the **most popular product for each individual customer**?
6. ⭐ What product was purchased **after** becoming a Gold Member?
7. ⏮️ What was the **last product bought before** a customer became a Gold Member?
8. 📦 What is the **total number of orders and amount spent** by each member **before** joining the Gold program?
9. 🧮 Using a custom reward system, how many **Zomato points** did each customer and each product accumulate?
10. 🗓️ In the **first year of Gold Membership**, how many points did users earn using a fixed reward scheme (5 points per ₹10)?
11. 🏆 Rank all transactions of each customer based on their date.
12. 🥇 Rank **only Gold Member transactions**, and assign `"NA"` to those that were not made under the membership.

---

## 🧠 Analysis Overview

For the complete list of queries and data preparation steps, feel free to explore the SQL scripts in this folder:  
📂 [View Full SQL Queries](./zomato_queries.sql/)

---

Rather than list each query, let's focus on the **key business insights** that emerged from this project:

### 📌 Highlights From Our Analysis

- **📊 Most Purchased Product:**  
  We identified the most frequently ordered item on the menu — this helps prioritize popular products in marketing and inventory planning.

```sql
SELECT userid, COUNT(product_id) as No_of_Purchases
FROM sales 
WHERE product_id = (
    SELECT s.product_id as Product_ID
    FROM sales s
    GROUP BY s.product_id
    ORDER BY COUNT(userid) DESC
    LIMIT 1
)
GROUP BY userid;
```

![Highest Demand Product](assets/most_sold_product.png)


- **🎯 Post-Membership Behavior:**  
  Analyzed the first product users purchased after joining the Gold Membership program. Repeated patterns here indicate products that keep users engaged after upgrade.

```sql
SELECT userid, product_id
FROM (
	SELECT s.userid, s.product_id, DENSE_RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) as rn
	FROM (
		SELECT * 
		FROM sales
		ORDER BY userid, created_date
		) AS s
	JOIN goldusers_signup g ON s.userid = g.userid AND s.created_date>g.gold_signup_date
	) 
WHERE rn = 1;
```
**Result Set**

| User ID | Product ID |
|---------|------------|
| 1       | 3          |
| 3       | 2          |

*This insight helps identify what products are most appealing to users right after joining the Gold program.*


- **⏮️ Pre-Membership Trigger:**  
  Found the last product purchased *before* users became members. If common, this product may have influenced their decision to upgrade — valuable for upsell strategies.

```sql
SELECT userid, product_id
FROM (
	SELECT s.userid, s.product_id, DENSE_RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date DESC) as rn
	FROM (
		SELECT * 
		FROM sales
		ORDER BY userid, created_date
		) AS s
	JOIN goldusers_signup g ON s.userid = g.userid AND s.created_date<=g.gold_signup_date
	) 
WHERE rn = 1;
```

**Result Set**



- **🏅 Reward Points Simulation:**  
  Designed a custom point system based on product pricing (e.g., 5₹ = 1 point). We calculated total points per user and per product, offering insight into loyalty performance by item.

These insights bridge raw transaction data with business value — helping decision-makers understand customer behavior, membership effectiveness, and reward optimization.

