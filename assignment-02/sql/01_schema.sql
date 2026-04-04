-- =============================================================================
-- NeoBank Database Schema
-- Assignment 02: SQL Fundamentals - DDL
-- =============================================================================
-- This script should be IDEMPOTENT - it can be run multiple times without errors
-- Tip: Use IF NOT EXISTS for tables and constraints
-- =============================================================================

-- =============================================================================
-- Create Schema
-- Create the neobank schema to organize all database objects
-- =============================================================================
CREATE SCHEMA IF NOT EXISTS neobank;

-- =============================================================================
-- Table: customers (UUID as primary key)
-- Requirements:
--   - UUID primary key with auto-generation (gen_random_uuid())
--   - Email: VARCHAR(255), unique, required
--   - Phone number: VARCHAR(20), unique, optional
--   - First name, Last name: VARCHAR(100), required
--   - Date of birth: DATE, required, must be 18+ years old (use CHECK constraint)
--   - SSN hash: CHAR(64), unique, required (for SHA-256 hash)
--   - KYC status: VARCHAR(20), values: 'pending', 'verified', 'rejected' (default: 'pending')
--   - Timestamps: created_at, updated_at (TIMESTAMPTZ with defaults)
-- =============================================================================
-- TODO: Write your CREATE TABLE statement here


-- =============================================================================
-- Table: account_types (SERIAL as primary key)
-- Requirements:
--   - SERIAL primary key
--   - Name: VARCHAR(50), unique, required
--   - Description: TEXT, optional
--   - Interest rate: DECIMAL(5,4), required, must be between 0 and 1
--   - Minimum balance: DECIMAL(15,2), required, non-negative, default 0.00
--   - Monthly fee: DECIMAL(10,2), required, non-negative, default 0.00
--   - Is active: BOOLEAN, default TRUE
-- =============================================================================
-- TODO: Write your CREATE TABLE statement here


-- =============================================================================
-- Table: accounts (BIGINT auto-increment primary key)
-- Requirements:
--   - Auto-incrementing BIGINT primary key. You may use either:
--     Option A: id BIGSERIAL PRIMARY KEY
--     Option B: id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
--   - Customer ID: UUID, required, foreign key to customers(id) with CASCADE delete
--   - Account type ID: INTEGER, required, foreign key to account_types(id)
--   - Account number: CHAR(16), unique, required
--   - Routing number: CHAR(9), required
--   - Balance: DECIMAL(15,2), required, default 0.00
--   - Currency: CHAR(3), default 'USD'
--   - Status: VARCHAR(20), values: 'active', 'frozen', 'closed' (default: 'active')
--   - Timestamps: opened_at (default), closed_at (nullable)
--   - Constraint: closed_at must be NOT NULL when status is 'closed', NULL otherwise
-- =============================================================================
-- TODO: Write your CREATE TABLE statement here


-- =============================================================================
-- Table: transactions (UUID as primary key)
-- Requirements:
--   - UUID primary key with auto-generation
--   - Idempotency key: UUID, unique, required
--   - Source account ID: BIGINT, optional, foreign key to accounts(id)
--   - Destination account ID: BIGINT, optional, foreign key to accounts(id)
--   - Transaction type: VARCHAR(20), values: 'deposit', 'withdrawal', 'transfer', 'fee', 'interest'
--   - Amount: DECIMAL(15,2), required, must be > 0
--   - Currency: CHAR(3), required
--   - Description: TEXT, optional, max 500 characters
--   - Status: VARCHAR(20), values: 'pending', 'completed', 'failed', 'reversed' (default: 'pending')
--   - Timestamps: created_at (default), processed_at (nullable)
--   - Constraint: validate source/destination based on transaction type
-- =============================================================================
-- TODO: Write your CREATE TABLE statement here


-- =============================================================================
-- Table: audit_log (BIGINT auto-increment primary key)
-- Requirements:
--   - Auto-incrementing BIGINT primary key. You may use either:
--     Option A: id BIGSERIAL PRIMARY KEY
--     Option B: id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
--   - Table name: VARCHAR(100), required
--   - Record ID: TEXT, required
--   - Old values: JSONB, optional
--   - New values: JSONB, optional
--   - Action: VARCHAR(10), values: 'INSERT', 'UPDATE', 'DELETE'
--   - Changed by: UUID, optional
--   - Changed at: TIMESTAMPTZ with default
-- =============================================================================
-- TODO: Write your CREATE TABLE statement here


-- =============================================================================
-- Indexes
-- Create indexes to optimize common queries:
--   - customers: email, kyc_status
--   - accounts: customer_id, status
--   - transactions: source_account_id, destination_account_id, status, created_at
-- =============================================================================
-- TODO: Write your CREATE INDEX statements here
