CREATE TABLE walmart_sales (
    invoice_id      INT PRIMARY KEY,
    branch          VARCHAR(10),
    city            VARCHAR(50),
    category        VARCHAR(50),
    unit_price      DECIMAL(10, 2),
    quantity        DECIMAL(10, 2),
    date            DATE,
    time            TIME,
    payment_method  VARCHAR(20),
    rating          DECIMAL(3, 1),
    profit_margin   DECIMAL(5, 2),
    total           DECIMAL(12, 4)
);

INSERT INTO walmart_sales
SELECT
    invoice_id,
    branch,
    city,
    category,
    unit_price,
    quantity,
    TO_DATE(date, 'DD/MM/YY'),   -- converts "27/01/19" → 2019-01-27
    time,
    payment_method,
    rating,
    profit_margin,
    total
FROM walmart_staging;

Select * from walmart_sales;

select count(*) from walmart_sales;

select 
		payment_method, 
		count(*)
from walmart_sales
group by payment_method;


select count(distinct branch) from walmart_sales;

select max(quantity) from walmart_sales;

-- Business Problems
--Q.1 Find different payment method and number of transactions, number of qty sold

select 
		payment_method, 
		count(*) as no_of_payment,
		sum(quantity) as no_qty_sold
from walmart_sales
group by payment_method;

-- Project Question #2
-- Identify the highest-rated category in each branch, displaying the branch, category and AVG RATING

Select *
from
(
	Select
		branch,
		category,
		avg(rating) as avg_rating,
		rank() over(partition by branch order by avg(rating) desc) as rank
	from walmart_sales
	group by 1, 2
)
where rank = 1; 

-- Q.3 Identify the busiest day for each branch based on the number of transactions.

select *
from
(	select
		branch,
		TO_CHAR(date , 'DAY') as day_name,
		count(*) as no_of_transactions,
		rank() over(partition by branch order by count(*) DESC) as rank
	from walmart_sales
	group by 1, 2
)
where rank = 1; 

-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

select * from walmart_sales

select 
	payment_method,
	sum(quantity) as total_quantity 
from walmart_sales
group by 1;


-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

select 
	city,
	category,
	AVG(rating) as avg_rating,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating
from walmart_sales
group by 1, 2


-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

Select
	category,
	sum(total) as total_revenue,
	sum(total * profit_margin) as total_profit
from walmart_sales
group by 1
order by 3 DESC;

-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

select * from walmart_sales




