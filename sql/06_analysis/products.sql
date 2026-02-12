-- Top product category by revenue per year
-- Definition:
--   Identifies the highest-grossing product category each year.
--   Uses window functions to rank categories within each year.
SELECT `year`, category top_category,  total_revenue
FROM(
	SELECT category, YEAR(order_purchase_timestamp) `year`,
	SUM(price) total_revenue, 
	ROW_NUMBER() OVER (
   	PARTITION BY YEAR(order_purchase_timestamp)
      ORDER BY SUM(price) DESC) rn
	FROM v_delivered_order_items
	GROUP BY `year`, category) ranked
WHERE rn = 1;

-- Revenue by product category (Top 5 categories only)
-- Definition:
--   Item-level revenue aggregated by category and month.
--   Restricts output to the 5 categories with the highest
--   total revenue across the full observed period.
WITH category_totals AS (
    SELECT category, SUM(price) total_revenue
    FROM v_delivered_order_items
    GROUP BY category),
    
top_categories AS (
    SELECT category
    FROM category_totals
    ORDER BY total_revenue DESC
    LIMIT 5)

SELECT category, YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`, SUM(price) revenue
FROM v_delivered_order_items
WHERE category IN (
    SELECT category
	 FROM top_categories)
GROUP BY category, `year`, `month`
ORDER BY category, `year`, `month`;