DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup(userid INTEGER, gold_signup_date DATE); 

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES 
(1, '22-09-2017'),
(3, '21-04-2017');

DROP TABLE IF EXISTS users;
CREATE TABLE users(userid INTEGER, signup_date DATE); 

INSERT INTO users(userid, signup_date) 
VALUES 
(1, '02-09-2014'),
(2, '15-01-2015'),
(3, '11-04-2014');

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(userid INTEGER, created_date DATE, product_id INTEGER); 

INSERT INTO sales(userid, created_date, product_id) 
VALUES 
(1, '19-04-2017', 2),
(3, '18-12-2019', 1),
(2, '20-07-2020', 3),
(1, '23-10-2019', 2),
(1, '19-03-2018', 3),
(3, '20-12-2016', 2),
(1, '09-11-2016', 1),
(1, '20-05-2016', 3),
(2, '24-09-2017', 1),
(1, '11-03-2017', 2),
(1, '11-03-2016', 1),
(3, '10-11-2016', 1),
(3, '07-12-2017', 2),
(3, '15-12-2016', 2),
(2, '08-11-2017', 2),
(2, '10-09-2018', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product(product_id INTEGER, product_name TEXT, price INTEGER); 

INSERT INTO product(product_id, product_name, price) 
VALUES
(1, 'p1', 980),
(2, 'p2', 870),
(3, 'p3', 330);

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;

-- Q1) What is the total amount each customer spent on zomato?

SELECT s.userid, sum(price) as total_spent 
FROM sales s
JOIN
	product p ON s.product_id = p.product_id
GROUP BY s.userid
ORDER BY total_spent DESC;

-- Q2) How many days has each customer visited zomato?

SELECT s.userid, COUNT(DISTINCT created_date) AS Days 
FROM sales s
GROUP BY userid
ORDER BY Days DESC;

-- Q3) What was the first product purchased by each customer?

SELECT userid, product_id 
FROM (
	SELECT userid, product_id, ROW_NUMBER() OVER(PARTITION BY userid ORDER BY created_date) AS rn
	FROM sales
	) AS numbered_data
WHERE rn = 1;

-- Q4) What is the most purchased item on the menu and how many times was it purchased?
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

-- Q5) Which item was the most popular for each customer?
 
SELECT userid, product_id FROM (
	SELECT userid, product_id, sales, DENSE_RANK() OVER(PARTITION BY userid ORDER BY sales DESC) as rn
	FROM (
		SELECT userid, product_id, COUNT(product_id) AS sales
		FROM sales
		GROUP BY product_id, userid
		ORDER BY userid
		)
	ORDER BY userid
	)
WHERE rn = 1;

-- Q6) Which item was purchased by the customer after they became a member?

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

-- Q7) Which item was just purchased before the customer became a member?

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

-- Q8) What is the total orders and amount spent for each member before they became a member?

SELECT f.userid, COUNT(f.created_date) as Total_Orders, SUM(f.price) as Total_Spent
FROM (
	SELECT s.userid, s.product_id, s.created_date, p.price
		FROM (
			SELECT * 
			FROM sales
			ORDER BY userid, created_date
			) AS s
		JOIN goldusers_signup g ON s.userid = g.userid AND s.created_date<=g.gold_signup_date
		JOIN product p ON s.product_id = p.product_id
	) f
GROUP BY f.userid
ORDER BY f.userid

-- Q9) If buying each product generates points for eg 5rs=2 Zomato Point and each product has different purchasing points for eg for p1  5rs=1 Zomato point, for p2 10rs=5 zomato point and p3 5rs=1 zomato point.
	  -- Calculate total points collected for each customer and for which product most points have been given till now.
	
SELECT userid, SUM(Zomato_point) as Earned_Points
FROM (
		SELECT *, 
			CASE
				WHEN product_id=1 THEN total/5
				WHEN product_id=2 THEN (total/10)*5
				WHEN product_id=3 THEN total/5
			END as Zomato_point
		FROM (
			SELECT s.userid, s.product_id, SUM(p.price) as total
			FROM sales s
			JOIN
				product p ON s.product_id = p.product_id
			GROUP BY s.userid, s.product_id
			ORDER BY userid
			)
		)
GROUP BY userid
ORDER BY userid;

SELECT product_id, SUM(Zomato_point) as Earned_Points
FROM (
		SELECT *, 
			CASE
				WHEN product_id=1 THEN total/5
				WHEN product_id=2 THEN (total/10)*5
				WHEN product_id=3 THEN total/5
			END as Zomato_point
		FROM (
			SELECT s.userid, s.product_id, SUM(p.price) as total
			FROM sales s
			JOIN
				product p ON s.product_id = p.product_id
			GROUP BY s.userid, s.product_id
			ORDER BY userid
			)
		)
GROUP BY product_id
ORDER BY Earned_Points DESC
LIMIT 1;

-- Q10) In the first one year, after a customer joins the gold program (including their join date) irrespective of what the customer has purchased they earn 5 zomato points for every 10 rs spent.
-- Who earned more - 1 or 3? What was their points earned in the first year? 


SELECT s.userid, (p.price/10)*5 as points_earned
FROM sales s
JOIN 
	goldusers_signup g ON s.userid = g.userid AND (s.created_date - g.gold_signup_date) BETWEEN 0 AND 365
JOIN
	product p ON s.product_id = p.product_id
ORDER BY points_earned DESC
LIMIT 1;

-- Q11) Rank all the transactions of the customers.

SELECT *, RANK() OVER(PARTITION BY userid ORDER BY created_date) as Rank
FROM sales;

-- Q12) Rank all the transactions for each member when they are gold members. For every non gold member, mark NA as transaction.

SELECT s.userid, s.created_date, g.gold_signup_date,
	CASE
		WHEN g.gold_signup_date IS NULL or s.created_date<g.gold_signup_date THEN 'NA'
		WHEN s.created_date>=g.gold_signup_date THEN RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date DESC)::TEXT
	END as Rank
FROM sales s
LEFT JOIN
	goldusers_signup g ON s.userid = g.userid