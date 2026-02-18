-- ============================================
-- Exercise 1: Basic Filtering with WHERE
-- ============================================

-- Task 1.1: Premium Products (4 points)
-- Find all products with a price of $500 or more
-- Return: product_id, name, price
-- Order by: price descending
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 1.2: Budget-Friendly Options (4 points)
-- Find all products priced between $20 and $100 (inclusive)
-- Return: product_id, name, price, category_id
-- Order by: price ascending
-- Tip: Use BETWEEN operator
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 1.3: Electronics Department (4 points)
-- Find all products in Electronics category or its subcategories
-- Return: product_id, name, category_id, price
-- Order by: name ascending
-- Tip: First query the categories table to find the IDs for Electronics and its subcategories
--      Then use IN operator with those explicit category IDs (e.g., category_id IN (1, 2, 3))
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 1.4: Order Status Filter (4 points)
-- Find orders that are pending, confirmed, or processing
-- Return: order_id, order_number, status, total_amount, created_at
-- Order by: created_at descending
-- Tip: Use IN operator
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 1.5: High-Value Completed Orders (4 points)
-- Find delivered orders with total > $1000
-- Return: order_id, order_number, customer_id, total_amount, delivered_at
-- Order by: total_amount descending
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
