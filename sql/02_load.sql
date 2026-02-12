/*
-------------------------------------------------------
Project: Olist E-commerce Analysis
File: 02_load.sql
Purpose:
  - Load CSV datasets using LOAD DATA LOCAL INFILE
  - Minimal cleaning (empty strings → NULL)

Notes:
  - order_reviews dataset was pre-cleaned to normalize escaped quotes
  - No constraints enforced at this stage (raw layer)

Author: Juan Andrés González Moncada
-------------------------------------------------------
*/	

-- =========================
-- Customers
-- =========================
	
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_customers_dataset.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state);
	

-- =========================
-- Sellers
-- =========================
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

	
-- =========================
-- Products
-- =========================	
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES(
	product_id,
	@product_category_name,
	@product_name_lenght,
	@product_description_lenght,
	@product_photos_qty,
	@product_weight_g,
	@product_length_cm,
	@product_height_cm,
	@product_width_cm)
SET 
product_category_name			= NULLIF(@product_category_name, ''),
product_name_lenght				= NULLIF(@product_name_lenght, ''),
product_photos_qty				= NULLIF(@product_photos_qty, ''),
product_weight_g			     	= NULLIF(@product_weight_g, ''),
product_length_cm			     	= NULLIF(@product_length_cm, ''),
product_height_cm			     	= NULLIF(@product_height_cm, ''),
product_width_cm			     	= NULLIF(@product_width_cm, '');
	
	
-- =========================
-- Product name translations
-- =========================
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

	
-- =========================
-- Orders
-- =========================
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_orders_dataset.csv'
INTO TABLE olist_orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES(
	order_id,
	customer_id,
	order_status,
	@date_purchase,
	@date_approved,
	@date_carrier,
	@date_customer,
	@date_estimated)
SET 
order_purchase_timestamp      = NULLIF(@date_purchase, ''),
order_approved_at            	= NULLIF(@date_approved, ''),
order_delivered_carrier_date  = NULLIF(@date_carrier, ''),
order_delivered_customer_date = NULLIF(@date_customer, ''),
order_estimated_delivery_date = NULLIF(@date_estimated, '');
	
-- =========================
-- Order items
-- =========================
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_order_items_dataset.csv'
INTO TABLE olist_order_items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;
	
	
-- =========================
-- Order payments
-- =========================
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;
	
	
-- =========================
-- Order reviews
-- =========================	
-- NOTE:
-- The file olist_order_reviews_dataset_fixed.csv was obtained by preprocessing olist_oder_reviews_dataset.csv
-- The original file was preprocessed to replace \" with "" to ensure CSV compatibility
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/cleaned/olist_order_reviews_dataset_fixed.csv'
INTO TABLE olist_order_reviews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES(
	review_id,
	order_id,
	review_score,
	@review_title,
	@review_message,
	@creation_date,
	@answer_timestamp)
SET 
review_comment_title				= NULLIF(@review_title, ''),
review_comment_message			= NULLIF(@review_message, ''),
review_creation_date				= NULLIF(@creation_date, ''),
review_answer_timestamp       = NULLIF(@answer_timestamp, '');
	
-- =========================
-- Locations
-- =========================	
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocations
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

-- =========================
-- State acronyms
-- =========================	
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/brazil_states.csv'
INTO TABLE state_names
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

-- =========================
-- Brazil regions
-- =========================	
LOAD DATA LOCAL INFILE 'E:/olist-data-analysis/data/raw/brazil_regions.csv'
INTO TABLE brazil_regions
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;