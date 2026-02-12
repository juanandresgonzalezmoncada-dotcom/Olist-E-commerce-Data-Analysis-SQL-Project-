-- Repeat customer rate
-- Definition:
--   A repeat customer is one with two or more delivered orders.
--   Uses customer_unique_id to avoid counting duplicates.
WITH customer_orders AS(
	SELECT COUNT(DISTINCT order_id) total_orders
	FROM v_delivered_orders_customers 
	GROUP BY customer_unique_id)
SELECT SUM(total_orders >= 2) repeat_customers, COUNT(*) total_customers, SUM(total_orders >= 2)/COUNT(*) repeat_rate
FROM customer_orders;


-- Revenue share from repeat customers
-- Purpose:
--   Calculates what fraction of total revenue comes from repeat customers
--   Quantifies the business impact of customer retention.
WITH customer_revenue AS(
	SELECT SUM(p.payment_value) AS revenue,
	COUNT(DISTINCT c.order_id) total_orders
	FROM v_delivered_orders_customers c
	JOIN v_delivered_order_payments p
	ON p.order_id=c.order_id
	GROUP BY customer_unique_id)
SELECT SUM(CASE WHEN total_orders >= 2 THEN revenue ELSE 0 END) repeat_revenue, SUM(revenue) total_revenue, SUM(CASE WHEN total_orders >= 2 THEN revenue ELSE 0 END)
    / SUM(revenue) repeat_revenue_share
FROM customer_revenue;


-- Metric: Monthly average order value (AOV) from repeat customers
-- Purpose:
--   Calculates the AOV for customers with two or more delivered orders.
SELECT YEAR(order_purchase_timestamp) `year`, MONTH(order_purchase_timestamp) `month`, AVG(payment_value) repeat_AOV 
FROM v_delivered_order_payments pay
JOIN v_repeat_customer_orders repeat_c
ON repeat_c.order_id=pay.order_id
GROUP BY 1, 2;


-- Metric: Customer lifetime value (LTV) and total delivered orders per customer
-- Purpose:
--   Computes the observed lifetime value of each customer as the total
--   payment value accumulated across all delivered orders within the
--   observation window, along with the total number of distinct orders.
--   This metric is used to assess revenue concentration, customer
--   heterogeneity, and the relationship between order frequency and
--   customer value.
SELECT
    customer_unique_id,
    SUM(payment_value) customer_ltv,
    COUNT(DISTINCT pay.order_id) total_orders
FROM v_delivered_order_payments pay
JOIN v_delivered_orders_customers customer
ON (pay.order_id = customer.order_id)
GROUP BY customer_unique_id
ORDER BY customer_ltv DESC, total_orders DESC;


-- Revenue share from repeat customers when analyzing highest LTV customers
-- Purpose:
--   Calculates what fraction of total revenue comes from repeat customers
--   Quantifies the business impact of customer retention.
WITH high_ltv_customers AS(
	SELECT
	    customer_unique_id,
	    SUM(payment_value) customer_ltv,
	    COUNT(DISTINCT pay.order_id) total_orders
	FROM v_delivered_order_payments pay
	JOIN v_delivered_orders_customers customer
	ON (pay.order_id = customer.order_id)
	GROUP BY customer_unique_id
	ORDER BY customer_ltv DESC, total_orders DESC
	LIMIT 100)
SELECT COUNT(*) considered_highest_ltv_customers, SUM(total_orders >= 2) repeat_customers, SUM(total_orders >= 2)/COUNT(*) repeat_rate
FROM high_ltv_customers;