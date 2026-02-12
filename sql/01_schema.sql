/*
-------------------------------------------------------
Project: Olist E-commerce Analysis
File: 01_schema.sql
Purpose:
  - Create database
  - Create base tables (raw ingestion layer)

Notes:
  - No constraints enforced at this stage (raw layer)

Author: Juan Andrés González Moncada
-------------------------------------------------------
*/

DROP DATABASE IF EXISTS
	olistdatabase;
	
CREATE DATABASE olistdatabase;
USE olistdatabase;

DROP TABLE IF EXISTS
	olist_customers,
	olist_orders,
	olist_order_reviews,
	olist_order_items,
	olist_products,
	olist_order_payments,
	product_category_name_translation,
	olist_geolocations,
	olist_sellers,
	state_names,
	brazil_regions;

-- =========================
-- Customers
-- =========================
CREATE TABLE olist_customers(
	customer_id VARCHAR(40),
	customer_unique_id VARCHAR(40),
	customer_zip_code_prefix VARCHAR(10),
	customer_city VARCHAR(40),
	customer_state VARCHAR(2));
	

-- =========================
-- Sellers
-- =========================
CREATE TABLE olist_sellers(
	seller_id VARCHAR(40),
	seller_zip_code_prefix VARCHAR(10),
	seller_city VARCHAR(40),
	seller_state VARCHAR(2));
	
-- =========================
-- Products
-- =========================	
CREATE TABLE olist_products(
	product_id VARCHAR(40),
	product_category_name VARCHAR(60),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT);

	
-- =========================
-- Product name translations
-- =========================
CREATE TABLE product_category_name_translation(
	product_category_name VARCHAR(60),
	product_category_name_english VARCHAR(60));


-- =========================
-- Orders
-- =========================
CREATE TABLE olist_orders(
	order_id VARCHAR(40),
	customer_id VARCHAR(40),
	order_status ENUM('approved','created','processing','shipped','delivered','invoiced','unavailable','canceled'),
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME);


-- =========================
-- Order items
-- =========================
CREATE TABLE olist_order_items(
	order_id VARCHAR(40),
	order_item_id INT,
	product_id VARCHAR(40),
	seller_id VARCHAR(40),
	shipping_limit_date DATETIME,
	price DECIMAL(6,2),
	freight_price DECIMAL(6,2));


-- =========================
-- Order payments
-- =========================
CREATE TABLE olist_order_payments(
	order_id VARCHAR(40),
	payment_sequential INT,
	payment_type VARCHAR(20),
	payment_installments INT,
	payment_value DECIMAL(7,2));

	
-- =========================
-- Order reviews
-- =========================	
CREATE TABLE olist_order_reviews(
	review_id VARCHAR(40),
	order_id VARCHAR(40),
	review_score ENUM('1','2','3','4','5'), -- review_score defined as ENUM based source dataset (values 1–5)
	review_comment_title VARCHAR(50),
	review_comment_message VARCHAR(250),
	review_creation_date DATETIME,
	review_answer_timestamp DATETIME);
	
	
-- =========================
-- Locations
-- =========================	
CREATE TABLE olist_geolocations(
	geolocation_zip_code_prefix VARCHAR(10),
	geolocation_lat DOUBLE(19,16),
	geolocation_lng DOUBLE(19,16),
	geolocation_city VARCHAR(40),
	geolocation_state VARCHAR(2));

	
-- =========================
-- State acronyms
-- =========================	
CREATE TABLE state_names(
	state VARCHAR(2),
	state_name VARCHAR(40));
	

-- =========================
-- Brazil regions
-- =========================	
CREATE TABLE brazil_regions(
	state VARCHAR(2),
	region_name VARCHAR(40));