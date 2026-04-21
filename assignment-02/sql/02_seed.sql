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
INSERT INTO neobank.account_types(name, description, interestRate, minBalance, monthlyFee)
VALUES
('Basic Checking', 'Standard checking account', 0.0005, 0.00, 4.00),
('Premium Checking', 'Premium features account', 0.0035, 1500.00, 0.00),
('Savings', 'Basic savings account', 0.0125, 0.00, 0.00),
('High-Yield Savings', 'High interest savings', 0.0450, 750.00, 0.00),
('Money Market', 'Money market account', 0.0180, 2000.00, 12.00)
ON CONFLICT (name) DO NOTHING
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
INSERT INTO neobank.customers (email, firstName, lastName, dob, ssnHash, kycStatus, created_at)
VALUES
('ethan@gmail.com', 'Ethan', 'Clark', '1992-08-14', encode(digest('1357','sha256'),'hex'), 'verified', CURRENT_TIMESTAMP - INTERVAL '12 days'),
('mia@yahoo.com', 'Mia', 'Lopez', '1997-01-21', encode(digest('2468','sha256'),'hex'), 'pending', CURRENT_TIMESTAMP - INTERVAL '9 days'),
('logan@outlook.com', 'Logan', 'Hill', '1989-06-30', encode(digest('9753','sha256'),'hex'), 'verified', CURRENT_TIMESTAMP - INTERVAL '7 days'),
('chloe@gmail.com', 'Chloe', 'Scott', '1994-10-11', encode(digest('8642','sha256'),'hex'), 'rejected', CURRENT_TIMESTAMP - INTERVAL '6 days'),
('jack@yahoo.com', 'Jack', 'Green', '1986-03-05', encode(digest('1122','sha256'),'hex'), 'verified', CURRENT_TIMESTAMP - INTERVAL '5 days'),
('lily@outlook.com', 'Lily', 'Adams', '1999-12-19', encode(digest('3344','sha256'),'hex'), 'pending', CURRENT_TIMESTAMP - INTERVAL '4 days'),
('ryan@gmail.com', 'Ryan', 'Baker', '1991-07-08', encode(digest('5566','sha256'),'hex'), 'verified', CURRENT_TIMESTAMP - INTERVAL '3 days'),
('zoe@yahoo.com', 'Zoe', 'Nelson', '1993-02-27', encode(digest('7788','sha256'),'hex'), 'rejected', CURRENT_TIMESTAMP - INTERVAL '2 days'),
('lucas@outlook.com', 'Lucas', 'Carter', '1988-11-16', encode(digest('9900','sha256'),'hex'), 'verified', CURRENT_TIMESTAMP - INTERVAL '1 day'),
('ella@gmail.com', 'Ella', 'Mitchell', '1996-05-03', encode(digest('1212','sha256'),'hex'), 'pending', CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;

-- =============================================================================
-- Accounts
-- Insert accounts for customers, linking to account types
-- Tip: First query the customers and account_types tables to find the IDs you need
-- Then use those IDs directly in your INSERT statements
-- Use ON CONFLICT (account_number) DO NOTHING for idempotency
-- =============================================================================
-- TODO: Write your INSERT statements here
INSERT INTO neobank.accounts (customerID, accountTypeID, accountNum, rountingNum, balance)
VALUES
((SELECT id FROM neobank.customers WHERE email='john@gmail.com'), 1, '0000000000000001', '234567891', 1500.00),
((SELECT id FROM neobank.customers WHERE email='jane@yahoo.com'), 3, '0000000000000002', '345678912', 3000.00),
((SELECT id FROM neobank.customers WHERE email='mike@outlook.com'), 2, '0000000000000003', '456789123', 5000.00),
((SELECT id FROM neobank.customers WHERE email='sara@gmail.com'), 1, '0000000000000004', '567891234', 200.00),
((SELECT id FROM neobank.customers WHERE email='alex@yahoo.com'), 4, '0000000000000005', '678912345', 8000.00)
ON CONFLICT (accountNum) DO NOTHING;

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
INSERT INTO neobank.transactions (idempotencyKey, sourceAccountID, destinationAccountID, transactionType, amount, currency, status)
VALUES
-- Deposit (no source)
(gen_random_uuid(), NULL, 1, 'deposit', 500.00, 'USD', 'completed'),

-- Withdrawal (no destination)
(gen_random_uuid(), 1, NULL, 'withdrawal', 200.00, 'USD', 'completed'),

-- Transfer
(gen_random_uuid(), 1, 2, 'transfer', 300.00, 'USD', 'completed'),

-- Fee
(gen_random_uuid(), NULL, 1, 'fee', 10.00, 'USD', 'completed'),

-- Pending transaction
(gen_random_uuid(), 2, NULL, 'withdrawal', 100.00, 'USD', 'pending'),

-- Failed transaction
(gen_random_uuid(), 2, 1, 'transfer', 1000.00, 'USD', 'failed')

ON CONFLICT (idempotencyKey) DO NOTHING;