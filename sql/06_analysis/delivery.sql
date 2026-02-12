-- Delivery performance
-- Definition:
--   Measures logistics reliability.
--   A delivery is considered on-time if the actual delivery date
--   is less than or equal to the estimated delivery date.
SELECT     SUM(order_delivered_customer_date <= order_estimated_delivery_date) AS timely_shipments,
    SUM(order_delivered_customer_date > order_estimated_delivery_date) AS late_shipments,
    COUNT(*) AS total_shipments,
    SUM(order_delivered_customer_date <= order_estimated_delivery_date) / COUNT(*) AS delivery_performance
FROM v_delivered_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
    
    
-- Average delivery delay (days)
-- Purpose:
--   Measures the average number of days late for delayed deliveries.
--   Complements on-time rate by quantifying delay severity.
SELECT
    AVG(DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    )) AS avg_delay_days
FROM v_delivered_orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;


-- Delivery performance by state
-- Purpose:
--   Calculates the on-time delivery rate per customer state.
--   Identifies geographic regions with logistics challenges.
SELECT
    c.customer_state state,
    SUM(d.order_delivered_customer_date <= d.order_estimated_delivery_date)
        / COUNT(*) AS on_time_rate
FROM v_delivered_orders d
JOIN v_delivered_orders_customers c
    ON c.order_id = d.order_id
WHERE d.order_delivered_customer_date IS NOT NULL
  AND d.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY on_time_rate DESC;


-- Delivery performance by region
-- Purpose:
-- 	Calculates the on-time delivery rate aggregating 
-- 	states by macroregions as a proxy to group states 
--		with similar infrastructural and economic conditions
SELECT
    b.region_name region,
    SUM(d.order_delivered_customer_date <= d.order_estimated_delivery_date)
        / COUNT(*) AS on_time_rate
FROM v_delivered_orders d
JOIN v_delivered_orders_customers c
   ON c.order_id = d.order_id
JOIN brazil_regions b
	ON c.customer_state = b.state
WHERE d.order_delivered_customer_date IS NOT NULL
  AND d.order_estimated_delivery_date IS NOT NULL
GROUP BY b.region_name
ORDER BY on_time_rate DESC;