-- Geographic revenue distribution
-- Definition:
--   Revenue aggregated by customer city and state.
--   Used to identify high-performing regions.
SELECT customer_state state, SUM(payment_value) revenue
FROM v_delivered_orders_customers c
JOIN olist_order_payments p
    ON p.order_id = c.order_id
GROUP BY customer_state
ORDER BY revenue DESC;


-- Average order value by state
-- Purpose:
--   Computes the mean payment value per order for each state.
--   Highlights regional differences in purchasing behavior.
SELECT
    customer_state state,
    AVG(p.payment_value) avg_order_value
FROM v_delivered_orders_customers c
JOIN olist_order_payments p
    ON p.order_id = c.order_id
GROUP BY customer_state
ORDER BY avg_order_value DESC;


-- Number of unique customers by state
-- Purpose:
--   Counts distinct customers associated with delivered orders
--   in each state. Reflects the regional customer base size
--   and market penetration of the platform.
SELECT DISTINCT(customer_state) state, COUNT(DISTINCT(customer_unique_id)) customers
FROM v_delivered_orders_customers
GROUP BY customer_state
ORDER BY customers DESC;