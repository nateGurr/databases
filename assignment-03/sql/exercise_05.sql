-- ============================================
-- Exercise 5: Grouping and HAVING
-- ============================================

-- Task 5.1: Orders by Status (4 points)
-- Count orders and revenue by status
-- Return: status, order_count, total_revenue
-- Order by: order_count descending
-- Tip: Use GROUP BY status
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    status,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Task 5.2: Top Product Categories by Revenue (5 points)
-- Find categories with > $5000 revenue
-- Return: category_id, total_revenue, items_sold
-- Order by: total_revenue descending
-- Note: Calculate from order_items joined with products
-- Tip: Use HAVING SUM(oi.line_total) > 5000
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    p.category_id,
    SUM(oi.line_total) AS total_revenue,
    SUM(oi.quantity) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category_id
HAVING SUM(oi.line_total) > 5000
ORDER BY total_revenue DESC;

-- Task 5.3: Customer Order Frequency (4 points)
-- Find customers with 3 or more orders
-- Return: customer_id, order_count, total_spent
-- Order by: total_spent descending
-- Tip: Use HAVING COUNT(*) >= 3
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY total_spent DESC;

-- Task 5.4: Monthly Revenue 2024 (4 points)
-- Find months with revenue > $2000 in 2024
-- Return: order_month (integer), order_count, monthly_revenue
-- Order by: order_month ascending
-- Tip: Filter year with WHERE, filter revenue with HAVING
--      Use EXTRACT(MONTH FROM created_at) for grouping
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    EXTRACT(MONTH FROM created_at) AS order_month,
    COUNT(*) AS order_count,
    SUM(total_amount) AS monthly_revenue
FROM orders
WHERE EXTRACT(YEAR FROM created_at) = 2024
GROUP BY order_month
HAVING SUM(total_amount) > 2000
ORDER BY order_month ASC;

-- Task 5.5: Product Rating Summary (3 points)
-- Products with 3+ reviews
-- Return: product_id, review_count, avg_rating (2 decimals), five_star_count
-- Order by: avg_rating descending, review_count descending
-- Tip: Use HAVING COUNT(*) >= 3
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    product_id,
    COUNT(*) AS review_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(CASE WHEN rating = 5 THEN 1 END) AS five_star_count
FROM reviews
GROUP BY product_id
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC, review_count DESC;