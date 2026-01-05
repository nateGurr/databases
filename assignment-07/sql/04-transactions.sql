-- =============================================================================
-- Exercise 4: Transactions
-- PrecisionParts Manufacturing Database
-- =============================================================================

-- Problem 4.1: Create Production Order Transaction (5 points)
-- Create a complete production order with multiple line items atomically
-- 
-- Requirements:
--   - Begin transaction
--   - Insert production order (order_number: 'PO-2024-100', customer: 'Lockheed Martin')
--   - Insert 3 order items with different parts
--   - Verify the order was created with a SELECT
--   - Commit transaction
-- 
-- Tables: production_orders, order_items, parts
-- Tip: Use DO $$ DECLARE ... BEGIN ... END $$; for variables
-- -----------------------------------------------------------------------------
-- TODO: Write your transaction here (BEGIN; ... COMMIT;)


-- Problem 4.2: Material Consumption Transaction (6 points)
-- Consume materials for a production run with validation
-- 
-- Requirements:
--   - Begin transaction
--   - Set session variable: SET LOCAL app.current_user_id = '13';
--   - For part AERO-BRK-001, check all required materials (from part_materials)
--   - Validate sufficient stock for each material (10 units)
--   - If ANY material insufficient: RAISE EXCEPTION with details
--   - If all sufficient: 
--     * UPDATE each material's stock_quantity
--     * INSERT log entries to inventory_log
--   - Commit or rollback based on validation
-- 
-- Tables: parts, part_materials, materials, inventory_log
-- Tip: Use RAISE EXCEPTION to trigger rollback on validation failure
-- -----------------------------------------------------------------------------
-- TODO: Write your transaction here


-- Problem 4.3: Production Run Completion (5 points)
-- Complete a production run and update all related records
-- 
-- Requirements:
--   - Begin transaction
--   - Update production_run: set status = 'completed', end_time = NOW
--   - Update related part inventory: increase quantity
--   - Create quality check record for the run
--   - Update order item if this fulfills an order
--   - Commit transaction
-- 
-- This demonstrates multi-table updates that must succeed together
-- -----------------------------------------------------------------------------
-- TODO: Write your transaction here


-- Problem 4.4: Savepoints Demo (4 points)
-- Demonstrate the use of savepoints for partial rollbacks
-- 
-- Scenario: Batch update of part prices with checkpoint
--   - Begin transaction
--   - Update prices for Category A parts (increase by 5%)
--   - SAVEPOINT after_category_a
--   - Update prices for Category B parts (increase by 10%)
--   - If Category B update affects too many rows (> 100), rollback to savepoint
--   - Commit Category A changes either way
-- 
-- Tip: Use ROLLBACK TO SAVEPOINT savepoint_name;
-- -----------------------------------------------------------------------------
-- TODO: Write your transaction with savepoints here


-- Problem 4.5: Transfer Materials Between Warehouses (5 points)
-- Atomic transfer of materials from one location to another
-- 
-- Requirements:
--   - Begin transaction
--   - Decrease source warehouse stock
--   - Increase destination warehouse stock
--   - Log both movements to inventory_log
--   - Validate neither goes negative
--   - Commit only if both operations succeed
-- 
-- This is the classic "double-entry" pattern for transfers
-- -----------------------------------------------------------------------------
-- TODO: Write your transaction here


-- =============================================================================
-- BONUS: Understanding Isolation Levels
-- =============================================================================

-- Explain in comments what would happen with different isolation levels
-- for Problem 4.2 (Material Consumption) if two users try to consume
-- the same materials simultaneously:

/*
READ COMMITTED (PostgreSQL default):
  -- TODO: Describe behavior

REPEATABLE READ:
  -- TODO: Describe behavior

SERIALIZABLE:
  -- TODO: Describe behavior
*/
