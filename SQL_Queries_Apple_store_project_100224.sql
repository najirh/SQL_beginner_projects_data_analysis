
-- creating Database 
CREATE DATABASE Apple_Store_DBMS;

-- creating relational table 

CREATE TABLE products
					(product_id int PRIMARY KEY, 
					 product_name VARCHAR(25),
					 product_category VARCHAR(15),
					 Price	FLOAT,
					 stock int 
					 );
					 
-- creating customers table					 
CREATE TABLE customers(
					   customer_id int PRIMARY KEY,
					   customer_name VARCHAR(25)
					   );
					 
-- creating Orders Table 
CREATE TABLE orders(
					order_id int PRIMARY KEY,
					order_date date,
					product_id int,
					quantity_ordered int,
					customer_id int,
					payment_type CHAR(10),
					FOREIGN KEY (product_id) REFERENCES products(product_id),
					FOREIGN KEY	(customer_id) REFERENCES customers(customer_id)
					);
	
					
-- inserting data into product table 

INSERT INTO products
VALUES            (101, 'iPhone 5', 'phone', 499, 10),
					(102, 'iPhone 6', 'phone', 599, 15),
					(103, 'iPhone 7', 'phone', 699, 10),
					(104, 'iPhone 8', 'phone', 799, 20),
					(105, 'iPhone X', 'phone', 999, 10),
					(106, 'iPhone 14', 'phone', 1099, 10),
					(107, 'macbook pro 13', 'mac', 1299, 9),
					(108, 'airpods', 'accessories', 399, 10),
					(109, 'earphone', 'accessories', 199, 10),
					(110, 'imac', 'mac', 1499, 10)
					;
-- inserting customer data 
INSERT INTO customers (customer_id, customer_name)
VALUES 
(1, 'John Smith'),
(2, 'Alice Johnson'),
(3, 'Michael Brown'),
(4, 'Emily Davis'),
(5, 'David Martinez'),
(6, 'Jennifer Taylor'),
(7, 'Daniel Wilson'),
(8, 'Jessica Anderson'),
(9, 'James Thomas'),
(10, 'Sarah Garcia'),
(11, 'Robert Hernandez'),
(12, 'Linda Lopez'),
(13, 'William Scott'),
(14, 'Karen King'),
(15, 'Richard Young'),
(16, 'Maria Lee'),
(17, 'Charles Turner'),
(18, 'Patricia Hill'),
(19, 'Christopher Adams'),
(20, 'Laura Baker'),
(21, 'Matthew Gonzalez'),
(22, 'Ashley Nelson'),
(23, 'Joseph Carter'),
(24, 'Amanda Mitchell'),
(25, 'Donald Perez'),
(26, 'Susan Roberts'),
(27, 'Paul Evans'),
(28, 'Margaret Stewart'),
(29, 'Ryan Sanchez'),
(30, 'Deborah Morris'),
(31, 'Mark Rogers'),
(32, 'Lisa Reed'),
(33, 'Brian Cooper'),
(34, 'Dorothy Rivera'),
(35, 'Edward Cook'),
(36, 'Carol Ward'),
(37, 'Kevin Bailey'),
(38, 'Brenda Cox'),
(39, 'Ronald Diaz'),
(40, 'Pamela Richardson'),
(41, 'Jason Gray'),
(42, 'Helen Flores'),
(43, 'Scott Murphy'),
(44, 'Angela Washington'),
(45, 'Gregory Perry'),
(46, 'Melissa Butler'),
(47, 'Kenneth Barnes'),
(48, 'Debra Green'),
(49, 'Sean Hughes'),
(50, 'Tiffany Coleman');

					
-- Adding products 

-- Assuming you have at least 50 customers and 10 products in your respective tables

-- Insert 1000 orders with unique order_id values
INSERT INTO orders (order_id, order_date, product_id, quantity_ordered, customer_id, payment_type)
SELECT 
    ROW_NUMBER() OVER (ORDER BY random()) AS order_id,
    TIMESTAMP '2022-01-01' + random() * (TIMESTAMP '2024-02-08' - TIMESTAMP '2022-01-01') AS order_date,
    floor(random() * 10) + 101 AS product_id, -- Assuming product_id starts from 101
    floor(random() * 5) + 1 AS quantity_ordered,
    floor(random() * 50) + 1 AS customer_id, -- Assuming you have at least 50 customers
    CASE floor(random() * 2) WHEN 0 THEN 'Credit' ELSE 'Cash' END AS payment_type
FROM generate_series(1, 1000);



-- Insert 4999 more random orders with existing products and mixing customers
INSERT INTO orders (order_id, order_date, product_id, quantity_ordered, customer_id, payment_type)
SELECT 
    (SELECT max(order_id) FROM orders) + ROW_NUMBER() OVER () AS order_id,
    TIMESTAMP '2022-01-01' + random() * (TIMESTAMP '2024-02-08' - TIMESTAMP '2022-01-01') AS order_date,
    floor(random() * 10) + 101 AS product_id, -- Assuming product_id starts from 101
    floor(random() * 5) + 1 AS quantity_ordered,
    (SELECT customer_id FROM customers ORDER BY random() LIMIT 1) AS customer_id,
    CASE floor(random() * 2) WHEN 0 THEN 'Credit' ELSE 'Cash' END AS payment_type
FROM generate_series(1, 4999);


SELECT o.order_id, o.order_date, o.quantity_ordered, c.customer_name
FROM orders as o
JOIN customers as c 
ON o.customer_id = c.customer_id


					
SELECT * FROM products;					
SELECT * FROM customers;
SELECT * FROM orders;

-- Business Analysis & Answers business question with sql

-- Q1. Find out total sales per year  ?

SELECT
	EXTRACT(YEAR from o.order_date) as YEAR,
	SUM(o.quantity_ordered) as quantity_sold,
	SUM(o.quantity_ordered * p.price)
-- 	o.quantity_ordered * p.price as total_sale
FROM orders as o 
JOIN products as p 
ON o.product_id = p.product_id
GROUP BY 1;


-- Q.2 Best selling products and their sale?

SELECT
	p.product_name,
	SUM(o.quantity_ordered) as qty_sold,
	SUM(p.price * o.quantity_ordered) as total_sale
FROM orders as o 
JOIN products as p 
ON p.product_id = o.product_id
GROUP BY 1
ORDER BY total_sale DESC;

-- Q.3 How many customer does we have ?


SELECT COUNT(DISTINCT customer_id) as total_customer
FROM customers; -- Output 50

-- Q.4 Find out total orders placed by each customer 

SELECT customer_id, COUNT(quantity_ordered) as total_no_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-- Q.5 Find out total no of orders 
SELECT COUNT(*)
FROM orders

-- Q.6 Find out best selling month and compare with previous month 

WITH s 		-- using common expression table to find out sale of year 22
AS (
SELECT 
	LEFT(TO_CHAR(o.order_date, 'Month'), 3) as MONTH_2022,
	SUM(o.quantity_ordered * p.price) as total_sale
FROM orders as o
JOIN products as p 
ON o.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date ) = 2022
GROUP BY 1
),
s1		-- using common expression table to find out sale of year 23
AS (
SELECT 
	LEFT(TO_CHAR(o.order_date, 'Month'), 3)  as MONTH_2023,
	SUM(o.quantity_ordered * p.price) as total_sale
FROM orders as o
JOIN products as p 
ON o.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date ) = 2023
GROUP BY 1
)

SELECT s.month_2022, s.total_sale, s1.month_2023, s1.total_sale
FROM s
JOIN s1
ON MONTH_2022 = s1.month_2023;

-- Q.7 Count of payment cash vs credit card?

SELECT 
	payment_type,
	COUNT(payment_type)
FROM orders
GROUP BY 1;

-- Q.8 Find out best selling category?

SELECT 
	p.product_category,
	count(o.quantity_ordered) as total_orders
FROM orders as o
JOIN products p
ON o.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC;

-- Q.9 Customer who placed most orders?

SELECT 
	c.customer_id,
	c.customer_name,
	count(o.quantity_ordered) as total_orderes 
FROM orders as o 
JOIN customers as c 
ON o.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 3 DESC ;

-- Q.10 Best selling product where payment type is cash.

SELECT 
	p.product_name,
	COUNT(o.quantity_ordered) as cnt_order
FROM orders as o 
JOIN products as p
ON o.product_id = p.product_id
WHERE o.payment_type = 'Cash'
GROUP BY 1
ORDER BY cnt_order DESC
LIMIT 1;

-- Project by Najir Hussain
-- Follow me link Linkedin for more such projects
-- https://www.linkedin.com/in/najirr/
-- End of project


					
SELECT * FROM products;					
SELECT * FROM customers;
SELECT * FROM orders;