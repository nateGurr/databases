-- =============================================================================
-- NeoBank Seed Data
-- Assignment 02: SQL Fundamentals - DML (INSERT)
-- =============================================================================
-- This script should be IDEMPOTENT - uses ON CONFLICT DO NOTHING for repeatable runs
-- =============================================================================

-- =============================================================================
-- Account Types
-- Insert at least 5 account types:
--   - Basic Checking, Premium Checking, Savings, High-Yield Savings, Money Market
-- Use ON CONFLICT (name) DO NOTHING for idempotency
-- =============================================================================
-- TODO: Write your INSERT statements here


-- =============================================================================
-- Customers
-- Insert at least 10 customers with varied:
--   - KYC statuses (pending, verified, rejected)
--   - Email domains (gmail, yahoo, outlook, etc.)
--   - Created dates (use INTERVAL for relative dates)
-- Tip: Use encode(sha256('value'::bytea), 'hex') for ssn_hash
-- Use ON CONFLICT (email) DO NOTHING for idempotency
-- =============================================================================
-- TODO: Write your INSERT statements here


-- =============================================================================
-- Accounts
-- Insert accounts for customers, linking to account types
-- Tip: Use subqueries to get customer_id and account_type_id from their respective tables
-- Example: INSERT INTO neobank.accounts (customer_id, account_type_id, ...)
--   SELECT id FROM neobank.customers WHERE ... LIMIT 1
-- Use ON CONFLICT (account_number) DO NOTHING for idempotency
-- =============================================================================
-- TODO: Write your INSERT statements here


-- =============================================================================
-- Transactions
-- Insert various transaction types:
--   - Deposits (no source, has destination)
--   - Withdrawals (has source, no destination)
--   - Transfers (has both source and destination)
--   - Fees and interest transactions
-- Include various statuses: pending, completed, failed
-- Use ON CONFLICT (idempotency_key) DO NOTHING for idempotency
-- =============================================================================
-- TODO: Write your INSERT statements here
