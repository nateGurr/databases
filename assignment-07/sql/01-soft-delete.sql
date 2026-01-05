-- =============================================================================
-- Exercise 1: Soft-Delete Patterns
-- PrecisionParts Manufacturing Database
-- =============================================================================

-- Problem 1.1: Find All Soft-Deleted Records (3 points)
-- Show all soft-deleted records across the four main tables
-- Return: table_name, record_id (as TEXT), record_name, deleted_at, days_since_deletion
-- Tables: employees, materials, parts, machines
-- Tip: Use UNION ALL to combine results from all tables
--      Use EXTRACT(DAY FROM NOW() - deleted_at) for days calculation
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Problem 1.2: Impact Analysis of Deleted Records (4 points)
-- List soft-deleted employees with their quality check history
-- Return: employee_id, employee_name, role, deleted_at, 
--         total_checks, first_check_date, last_check_date
-- Filter: Only deleted employees (deleted_at IS NOT NULL)
-- Order by: total_checks descending
-- Tables: employees, quality_checks
-- Tip: Use LEFT JOIN to include employees with no checks
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here


-- Problem 1.3: Soft-Delete a Material (3 points)
-- Soft-delete the PTFE Rod Stock material (SKU: 'RAW-PTFE-ROD')
-- Only update if not already deleted
-- 
-- After writing the UPDATE, include a verification query comment
-- -----------------------------------------------------------------------------
-- TODO: Write your UPDATE statement here


-- Problem 1.4: Restore a Deleted Record (3 points)
-- Restore employee EMP029 (Michael Foster)
-- Set deleted_at to NULL and is_active to TRUE
-- Only update if currently deleted
-- 
-- After writing the UPDATE, include a verification query comment
-- -----------------------------------------------------------------------------
-- TODO: Write your UPDATE statement here


-- Problem 1.5: Cascade Soft-Delete Analysis (2 points)
-- Find soft-deleted machines and their production runs
-- Return: machine_id, machine_name, machine_deleted_at, 
--         run_id (run_number), run_status, part_number
-- Order by: machine_id, run start_time descending
-- Tables: machines, production_runs, parts
-- Tip: This shows orphaned data when parent is soft-deleted
-- -----------------------------------------------------------------------------
-- TODO: Write your SELECT statement here
