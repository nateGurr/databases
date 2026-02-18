-- ============================================
-- Exercise 4: Basic Aggregation Functions
-- ============================================

-- Task 4.1: Order Statistics (4 points)
-- Calculate overall order statistics
-- Return single row with:
--   - total_orders: COUNT(*)
--   - total_revenue: SUM(total_amount)
--   - average_order_value: AVG(total_amount) rounded to 2 decimals
--   - largest_order: MAX(total_amount)
--   - smallest_order: MIN(total_amount)
-- Tip: Use ROUND(AVG(...), 2) for rounding
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 4.2: Customer Count by Tier (4 points)
-- Count customers in each tier using conditional counting
-- Return single row with:
--   - total_customers: total count
--   - bronze_customers: count where tier = 'bronze'
--   - silver_customers: count where tier = 'silver'
--   - gold_customers: count where tier = 'gold'
--   - platinum_customers: count where tier = 'platinum'
-- Tip: Use COUNT(CASE WHEN tier = 'value' THEN 1 END)
--      or SUM(CASE WHEN tier = 'value' THEN 1 ELSE 0 END)
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 4.3: Product Catalog Summary (4 points)
-- Generate product catalog summary
-- Return single row with:
--   - total_products: COUNT(*)
--   - active_products: count where is_active = TRUE
--   - avg_price: AVG(price) rounded to 2 decimals
--   - price_range: MAX(price) - MIN(price)
--   - unique_categories: COUNT(DISTINCT category_id)
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 4.4: Review Metrics (4 points)
-- Calculate review statistics
-- Return single row with:
--   - total_reviews: COUNT(*)
--   - average_rating: AVG(rating) rounded to 1 decimal
--   - verified_reviews: count where is_verified_purchase = TRUE
--   - reviews_with_comments: COUNT(comment) - counts non-NULL only
--   - five_star_reviews: count where rating = 5
-- Tip: COUNT(column) only counts non-NULL values
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 4.5: Inventory Health Check (4 points)
-- Assess inventory levels
-- Return single row with:
--   - total_stock_units: SUM(quantity)
--   - unique_products_stocked: COUNT(DISTINCT product_id)
--   - avg_stock_per_product: AVG(quantity) rounded to 0 decimals
--   - out_of_stock_entries: count where quantity = 0
--   - low_stock_entries: count where quantity > 0 AND quantity <= 10
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
