/*
-------------------------------------------------------
Project: Olist E-commerce Analysis
File: 03_constraints.sql
Purpose:
  - Define primary keys and foreign keys
  - Enforce referential integrity between cleaned tables
  - Finalize relational schema according to ERD and data reality

Notes:
  - Assumes 01_set.sql and 02_clean.sql have been executed
  - Data has been validated for key uniqueness
  - Composite keys are used where required by the dataset
  - 
  
Author: Juan Andrés González Moncada
-------------------------------------------------------
*/

-- =====================================================
-- Brazil information
-- =====================================================
ALTER TABLE state_names
ADD PRIMARY KEY (state);

ALTER TABLE brazil_regions
ADD FOREIGN KEY (state) REFERENCES state_names(state);


-- =====================================================
-- Lookup tables
-- =====================================================
ALTER TABLE product_category_name_translation
ADD PRIMARY KEY (product_category_name);

ALTER TABLE cleaned_zip_geolocations
ADD PRIMARY KEY (geolocation_zip_code_prefix);

-- =====================================================
-- Core entity tables
-- =====================================================
ALTER TABLE olist_products
ADD PRIMARY KEY (product_id);

ALTER TABLE olist_sellers
ADD PRIMARY KEY (seller_id);

ALTER TABLE olist_customers
ADD PRIMARY KEY (customer_id);

-- =====================================================
-- Orders and dependent tables
-- =====================================================
ALTER TABLE olist_orders
ADD PRIMARY KEY (order_id),
ADD FOREIGN KEY (customer_id) REFERENCES olist_customers(customer_id);

-- =====================================================
-- Reviews
-- Composite key required because review_id is not unique
-- across orders in the raw dataset
-- =====================================================
ALTER TABLE olist_order_reviews
ADD PRIMARY KEY (review_id, order_id),
ADD FOREIGN KEY (order_id) REFERENCES olist_orders(order_id);

-- =====================================================
-- Payments
-- Composite key reflects real-world payment structure
-- =====================================================
ALTER TABLE olist_order_payments
ADD PRIMARY KEY (order_id, payment_sequential),
ADD FOREIGN KEY (order_id) REFERENCES olist_orders(order_id);

-- =====================================================
-- Order items
-- Each item belongs to an order, product, and seller
-- =====================================================
ALTER TABLE olist_order_items
ADD FOREIGN KEY (order_id) REFERENCES olist_orders(order_id),
ADD FOREIGN KEY (product_id) REFERENCES olist_products(product_id),
ADD FOREIGN KEY (seller_id) REFERENCES olist_sellers(seller_id);


