--create Table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
			  transactions_id INT PRIMARY KEY,
			  sale_date	DATE,
			  sale_time	TIME,
			  customer_id INT,
			  gender VARCHAR(10),
			  age INT,
			  category VARCHAR(15),
			  quantity INT,
			  price_per_unit FLOAT,	
			  cogs	FLOAT,
			  total_sale FLOAT
)

SELECT * FROM retail_sales;

-- Data cleaning --
-- To check for the null values:

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- Delete the rows with null values

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data exploration
-- How many sales we have
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many customers we have
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- How many distinct category we have, and what are they? 
SELECT COUNT(DISTINCT category) AS distinct_category_count FROM retail_sales;
SELECT DISTINCT(category) as distinct_category FROM retail_sales;

-- Data Analysis & Business Key problems and Answers

--Q.1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales;
WHERE sale_date ='2022-11-05';

--Q.2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 
-- 3 in the month of Nov-2022?

SELECT * FROM retail_sales
WHERE category = 'Clothing' and quantity>3 and sale_date between '2022-11-01' and '2022-11-30';

-- Q.3. Write a SQL query to calculate the total sales(total_sale), total order count and total quantity ordered for each category:
SELECT category, SUM(total_sale) as total_sales,COUNT(transactions_id) as total_orders, SUM(quantity) as total_quantity_ordered FROM retail_sales
GROUP BY category;

-- Q.4. Write a SQL query to find the average age of customers who purchased items from 'Beauty' category
SELECT * FROM retail_sales;
SELECT category, ROUND(AVG(age), 2) FROM retail_sales
WHERE category='Beauty'
GROUP BY 1;

-- Q.5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT* FROM retail_sales;
SELECT * FROM retail_sales 
WHERE total_sale > 1000;

-- Q.6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT * FROM retail_sales;
SELECT 
	category, 
	gender,
	COUNT(transactions_id) as total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY category, gender;

--Q.7. Write a SQL query to calculate the average sale for each month, and find out the best-selling month in each year.
SELECT * FROM retail_sales;
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE t1.rank=1;

-- Q.8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT * FROM retail_sales;
SELECT 
	customer_id, 
	sum(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--Q.9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT * FROM retail_sales;
SELECT 
	category,
	COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY 1;

-- Q.10. Write a SQL query to create each shift and the number of orders(Example: Morning<=12, Afternoon Between 12&17, Evening >17)
SELECT * FROM retail_sales;
WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(transactions_id) as total_orders
FROM hourly_sales
GROUP BY shift

--End of project