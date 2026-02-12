/*
-------------------------------------------------------
Project: Olist E-commerce Analysis
File: 05_views.sql

Author: Juan Andrés González Moncada
-------------------------------------------------------
*/

-- View: v_delivered_orders
-- Purpose:
--   Central definition of what a "valid" order is for analysis.
--   Filters orders to only those successfully delivered.
--   This avoids repeating `WHERE order_status = 'delivered'` everywhere.
CREATE OR REPLACE VIEW v_delivered_orders AS
SELECT
   order_id,
   customer_id,
	order_purchase_timestamp,
   order_delivered_customer_date,
   order_estimated_delivery_date
FROM olist_orders
WHERE order_status = 'delivered';

-- View: v_delivered_order_payments
-- Purpose:
--   Defines the revenue base of the project.
--   Joins delivered orders with their payments.
CREATE OR REPLACE VIEW v_delivered_order_payments AS
SELECT
   d.order_id,
   d.order_purchase_timestamp,
   p.payment_value
FROM v_delivered_orders d
JOIN olist_order_payments p
	ON p.order_id = d.order_id;
    
-- View: v_delivered_orders_customers
-- Purpose:
--   Associates delivered orders with customer identity and location.
--   Uses customer_unique_id to track repeat behavior correctly.
--   Used for customer and geographic analyses.
CREATE OR REPLACE VIEW v_delivered_orders_customers AS
SELECT
   d.order_id,
   c.customer_unique_id,
   c.customer_city,
   c.customer_state
FROM v_delivered_orders d
JOIN olist_customers c
   ON c.customer_id = d.customer_id;
    
-- View: v_delivered_order_items
-- Purpose:
--   Product-level revenue analysis.
--   Breaks delivered orders into individual items.
--   Translates Portuguese category names into English.
--   Uses item price (not payment_value) to attribute revenue by product.
CREATE OR REPLACE VIEW v_delivered_order_items AS
SELECT
	d.order_id,
   d.order_purchase_timestamp,
   i.price,
	i.product_id,
   t.product_category_name_english AS category
FROM v_delivered_orders d
JOIN olist_order_items i
   ON i.order_id = d.order_id
JOIN olist_products p
   ON p.product_id = i.product_id
JOIN product_category_name_translation t
   ON p.product_category_name = t.product_category_name;
    
    
-- View: v_repeat_customer_orders
-- Purpose:
--   Associate each repeat customer (customer_unique_id)
--   with all of their delivered orders.
--   This view is the base for repeat-rate, AOV, LTV, and retention analysis.
CREATE OR REPLACE VIEW v_repeat_customer_orders AS
SELECT
   c.customer_unique_id,
   order_id
FROM v_delivered_orders_customers c
JOIN (
   SELECT customer_unique_id
   FROM v_delivered_orders_customers
   GROUP BY customer_unique_id
   HAVING COUNT(DISTINCT order_id) >= 2) repeat_customers
ON c.customer_unique_id = repeat_customers.customer_unique_id;