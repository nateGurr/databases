-- ============================================
-- Exercise 3: CASE Expressions and Date Filtering
-- ============================================

-- Task 3.1: Product Price Tiers (4 points)
-- Categorize products by price tier:
--   - Under $50: 'Budget'
--   - $50 to $199.99: 'Mid-Range'
--   - $200 to $499.99: 'Premium'
--   - $500+: 'Luxury'
-- Return: product_id, name, price, price_tier
-- Order by: price ascending
-- Tip: Use CASE WHEN with range conditions
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    product_id,
    name,
    price,
    CASE
        WHEN price < 50 THEN 'Budget'
        WHEN price BETWEEN 50 AND 199.99 THEN 'Mid-Range'
        WHEN price BETWEEN 200 AND 499.99 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_tier
FROM products
ORDER BY price ASC;

-- Task 3.2: Order Status Labels (4 points)
-- Create human-readable status labels:
--   - pending -> 'Awaiting Confirmation'
--   - confirmed -> 'Order Confirmed'
--   - processing -> 'Being Prepared'
--   - shipped -> 'In Transit'
--   - delivered -> 'Completed'
--   - cancelled -> 'Cancelled'
--   - refunded -> 'Refunded'
--   - default -> 'Unknown'
-- Return: order_id, order_number, status, status_label
-- Order by: order_id ascending
-- Tip: Use CASE status WHEN 'value' THEN 'label' syntax
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    order_id,
    order_number,
    status,
    CASE status
        WHEN 'pending' THEN 'Awaiting Confirmation'
        WHEN 'confirmed' THEN 'Order Confirmed'
        WHEN 'processing' THEN 'Being Prepared'
        WHEN 'shipped' THEN 'In Transit'
        WHEN 'delivered' THEN 'Completed'
        WHEN 'cancelled' THEN 'Cancelled'
        WHEN 'refunded' THEN 'Refunded'
        ELSE 'Unknown'
    END AS status_label
FROM orders
ORDER BY order_id ASC;

-- Task 3.3: Black Friday Orders (4 points)
-- Find orders from November 25-29, 2024
-- Return: order_id, order_number, customer_id, total_amount, created_at
-- Order by: created_at ascending
-- Tip: Use >= and < for date ranges (exclusive end)
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    order_id,
    order_number,
    customer_id,
    total_amount,
    created_at
FROM orders
WHERE created_at >= '2024-11-25'
AND created_at < '2024-11-30'
ORDER BY created_at ASC;


-- Task 3.4: Monthly Order Distribution 2024 (4 points)
-- Get all orders from 2024 with month number
-- Return: order_id, order_number, order_month (integer), total_amount
-- Order by: order_month ascending, order_id ascending
-- Tip: Use EXTRACT(MONTH FROM created_at) and EXTRACT(YEAR FROM created_at)
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    order_id,
    order_number,
    EXTRACT(MONTH FROM created_at) AS order_month,
    total_amount
FROM orders
WHERE EXTRACT(YEAR FROM created_at) = 2024
ORDER BY order_month ASC, order_id ASC;

-- Task 3.5: Review Sentiment Categories (4 points)
-- Categorize reviews by sentiment:
--   - Rating 1-2: 'Negative'
--   - Rating 3: 'Neutral'
--   - Rating 4-5: 'Positive'
-- Also indicate if review has a comment (TRUE/FALSE)
-- Return: review_id, product_id, rating, sentiment, has_comment
-- Order by: rating descending, review_id ascending
-- Tip: Use CASE for sentiment, comment IS NOT NULL for has_comment
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
SELECT
    review_id,
    product_id,
    rating,
    CASE
        WHEN rating BETWEEN 1 AND 2 THEN 'Negative'
        WHEN rating = 3 THEN 'Neutral'
        WHEN rating BETWEEN 4 AND 5 THEN 'Positive'
    END AS sentiment,
    (comment IS NOT NULL) AS has_comment
FROM reviews
ORDER BY rating DESC, review_id ASC;