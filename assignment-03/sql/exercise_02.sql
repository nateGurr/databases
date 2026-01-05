-- ============================================
-- Exercise 2: Pattern Matching and NULL Handling
-- ============================================

-- Task 2.1: Product Search (4 points)
-- Find products with "Pro" in the name (case-insensitive)
-- Return: product_id, name, price
-- Order by: name ascending
-- Tip: Use ILIKE for case-insensitive matching
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 2.2: Email Domain Analysis (4 points)
-- Find customers with Gmail addresses
-- Return: customer_id, first_name, last_name, email
-- Order by: last_name ascending
-- Tip: Use LIKE with pattern '%@gmail.com'
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 2.3: Customers Without Phone Numbers (4 points)
-- Find customers with NULL phone
-- Return: customer_id, first_name, last_name, email
-- Order by: customer_id ascending
-- Tip: Use IS NULL, not = NULL
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 2.4: Reviews Without Comments (4 points)
-- Find reviews with rating but no comment
-- Return: review_id, product_id, customer_id, rating, title
-- Order by: rating descending, review_id ascending
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Task 2.5: Contact List with Default Phone (4 points)
-- Display "No phone on file" for NULL phones
-- Return: customer_id, full_name (concatenated), contact_phone
-- Order by: last_name ascending
-- Tip: Use COALESCE(phone, 'No phone on file')
--      Use || operator for string concatenation
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
