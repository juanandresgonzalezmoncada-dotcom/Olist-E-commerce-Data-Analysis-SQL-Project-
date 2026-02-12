/*
-------------------------------------------------------
Project: Olist E-commerce Analysis
File: 02_clean.sql
Purpose:
  - Perform data cleaning and normalization
  - Resolve inconsistencies in raw datasets
  - Prepare tables for key and constraint creation

Notes:
  - Assumes 01_set.sql has been executed successfully
  - All operations are idempotent (safe to re-run)
  - No primary or foreign keys are enforced in this stage

Author: Juan Andrés González Moncada
-------------------------------------------------------
*/

-- =====================================================
-- Cleaned Geolocation Table
-- One row per ZIP code prefix

-- Cleaning strategy:
--  - Select the most frequent (city, state) per ZIP prefix
--  - Resolve ties deterministically (alphabetical order)
--  - Average latitude and longitude values

-- Rationale:
--  - Raw geolocation data contains multiple entries per ZIP
--  - This table provides a canonical location per ZIP prefix
-- =====================================================
DROP TABLE IF EXISTS cleaned_zip_geolocations;

CREATE TABLE cleaned_zip_geolocations AS
WITH ranked_locations AS (
	SELECT
		geolocation_zip_code_prefix,
		geolocation_city city,
		geolocation_state state,
		COUNT(*) freq,
		ROW_NUMBER() OVER (
      	PARTITION BY geolocation_zip_code_prefix
      	ORDER BY COUNT(*) DESC,                   
			geolocation_city,
         geolocation_state
			) rn
	FROM olist_geolocations
	GROUP BY geolocation_zip_code_prefix, geolocation_city, geolocation_state)

SELECT
	geo.geolocation_zip_code_prefix,
	AVG(geo.geolocation_lat) lat,
	AVG(geo.geolocation_lng) lng,
	rnk.city,
	rnk.state
FROM olist_geolocations geo
JOIN ranked_locations rnk
  ON geo.geolocation_zip_code_prefix = rnk.geolocation_zip_code_prefix
 AND rnk.rn = 1
GROUP BY geo.geolocation_zip_code_prefix, rnk.city, rnk.state;