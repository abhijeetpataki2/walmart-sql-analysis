SELECT * FROM walmartsales.sales;



#------------------------------------------Feature Engineer-------------------------------------------------------------------------------
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;



ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);



UPDATE sales
SET time_of_day = (
    CASE
        WHEN `time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END
)

-- Add date_name column
select
	date,
	DAYNAME(date)
FROM sales;



ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column

SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);


-- Generic Question--


-- 1] How many unique cities does the data have?


select distinct city from sales;


-- 2] In which city is each branch?

select distinct city,branch from sales;



-- Product----

-- 1]How many unique product lines does the data have

SELECT DISTINCT product_line AS unique_product_lines
FROM sales;



-- 2]What is the most common payment method

select payment,count(*) from sales
group by payment
order by count(*) Desc;


-- 3] What is the most selling product line?
select sum(quantity) AS Qty,product_line
from sales
group by product_line
order by Qty desc;


-- 4]What is the total revenue by month

select month_name as month,sum(total) as Total_revenue
from sales
group by month
order by Total_revenue desc;


-- 5] What month had the largest COGS

select month_name as month,sum(cogs)as largest
from sales
group by month_name
order by largest desc;


-- 6] What product line had the largest revenue?

select product_line,sum(total)as largest_revenue
from sales
group by product_line
order by largest_revenue desc;


-- 7] What is the city with the largest revenue

select city,sum(total)as largest_revenue
from sales
group by city
order by largest_revenue desc;


-- 8] What product line had the largest VAT

select product_line,avg(tax_pct) as VAT
from sales
group by product_line
order by VAT desc;



-- 9] Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- 10]Which branch sold more products than average product sold?

select branch,sum(quantity)as qty
from sales
group by branch
having qty> (select avg(quantity) from sales);

-- 11] What is the most common product line by gender?

select gender,product_line,count(gender)AS Total
from sales
group by gender,product_line
order by Total desc;


-- 12] What is the average rating of each product line?

select product_line,round(avg(rating),2)as Avg_rating from sales
group by product_line
order by Avg_rating desc;



-- Sales----


-- 1]Number of sales made in each time of the day per weekday

select time_of_day,count(*)from sales
where day_name='Sunday'
group by time_of_day
order by count(*)desc;


-- 2]Which of the customer types brings the most revenue?

select customer_type,sum(total) as most_revenue
from sales
group by customer_type
order by most_revenue desc;


-- 3]Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,round(avg(tax_pct),2) as lar_Vat
from sales
group by city
order by lar_Vat desc;


-- 4] Which customer type pays the most in VAT?

select customer_type,avg(tax_pct)as most_vat
from sales
group by customer_type
order by most_vat desc;



-- Customer --

-- 1]How many unique customer types does the data have?

select distinct customer_type from sales;

-- 2]How many unique payment methods does the data have?

select distinct payment from sales


-- 3]What is the most common customer type?

SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC
LIMIT 1;



-- 4]Which customer type buys the most?

SELECT
    customer_type,
    COUNT(*) AS purchase_count
FROM sales
GROUP BY customer_type
ORDER BY purchase_count DESC
LIMIT 1;




-- 5]What is the gender of most of the customers?

select gender,count(*) as count
from sales
group by gender
order by count desc;


-- 6]What is the gender distribution per branch?

SELECT branch, gender, COUNT(*) AS count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender;



-- 7]Which time of the day do customers give most ratings?

SELECT time_of_day, COUNT(rating) AS rating_count
FROM sales
GROUP BY time_of_day
ORDER BY rating_count DESC;



-- 8]Which time of the day do customers give most ratings per branch?

select branch,time_of_day,count(customer_type) as Customers
from sales
group by branch,time_of_day
order by branch,Customers Desc;


-- 9]Which day fo the week has the best avg ratings?


SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- 10] Which day of the week has the best average ratings per branch
SELECT 
    branch,
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;







