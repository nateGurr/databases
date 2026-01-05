# Exercise 2: Seed Data (DML - INSERT)

## Objective

Populate the NeoBank database with realistic test data using INSERT statements. You will practice:

- `INSERT INTO ... VALUES` syntax
- Inserting data that respects all constraints
- Using SQL functions like `gen_random_uuid()` and `encode(sha256(...), 'hex')`
- Understanding the order of insertions when foreign keys are involved
- **Writing idempotent INSERTs using `ON CONFLICT`**

## Important: Idempotency for Seed Data

The grading script may run your seed file after your schema is already populated. To avoid duplicate key errors, use the `ON CONFLICT DO NOTHING` pattern for data that has unique constraints:

```sql
-- Fails if 'Basic Checking' already exists
INSERT INTO neobank.account_types (name, interest_rate, ...)
VALUES ('Basic Checking', 0.0001, ...);

-- Safe to run multiple times
INSERT INTO neobank.account_types (name, interest_rate, ...)
VALUES ('Basic Checking', 0.0001, ...)
ON CONFLICT (name) DO NOTHING;
```

## Your Task

Create a file called `sql/02_seed.sql` that inserts test data into all tables.

---

## 2.1 Account Types

Insert exactly these 5 account types:

| name | description | interest_rate | minimum_balance | monthly_fee |
|------|-------------|---------------|-----------------|-------------|
| Basic Checking | Standard checking account for everyday transactions | 0.0001 | 0.00 | 4.99 |
| Premium Checking | High-tier checking with premium benefits and no monthly fee | 0.0010 | 1500.00 | 0.00 |
| Savings | Standard savings account with competitive interest | 0.0250 | 100.00 | 0.00 |
| High-Yield Savings | Premium savings with higher APY for larger balances | 0.0450 | 10000.00 | 0.00 |
| Money Market | Money market account with tiered interest rates | 0.0350 | 2500.00 | 0.00 |

**Use `ON CONFLICT` for idempotency:**

```sql
INSERT INTO neobank.account_types (name, description, interest_rate, minimum_balance, monthly_fee)
VALUES ('Basic Checking', 'Standard checking account for everyday transactions', 0.0001, 0.00, 4.99)
ON CONFLICT (name) DO NOTHING;
```

---

## 2.2 Customers

Insert **at least 10 customers** with the following requirements:

### Requirements:
- Use `gen_random_uuid()` for the `id` field, or omit it to use the default
- Include a variety of `kyc_status` values: at least 6 verified, 2 pending, 2 rejected
- `date_of_birth` should span different decades (1970s, 1980s, 1990s, 2000s) - all must be 18+
- Email addresses should be realistic (e.g., `john.doe@gmail.com`)
- Phone numbers in E.164 format (e.g., `+14155551234`)
- For `ssn_hash`, generate unique 64-character hex strings

### Generating SSN Hashes

You can generate unique 64-character hashes like this:

```sql
-- Option 1: Using sha256 function
encode(sha256('unique_identifier_1'::bytea), 'hex')

-- Option 2: Just use a placeholder 64-char string for testing
'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2'
```

### Example Customer Insert (Idempotent):

```sql
INSERT INTO neobank.customers (
    email, phone_number, first_name, last_name, 
    date_of_birth, ssn_hash, kyc_status, created_at
)
VALUES (
    'john.doe@gmail.com',
    '+14155551234',
    'John',
    'Doe',
    '1985-03-15',
    encode(sha256('ssn_john_doe'::bytea), 'hex'),
    'verified',
    CURRENT_TIMESTAMP - INTERVAL '90 days'
)
ON CONFLICT (email) DO NOTHING;
```

### Specific Customers to Include:

Include at least these specific cases for later exercises:

1. **A customer with email ending in `@test.neobank.local`** (for testing delete operations)
2. **A customer with 'bank' in their email** (for pattern matching queries)
3. **A customer born between 1980-1995 with a phone starting with '+1'** (for complex filtering)
4. **At least 2 customers with 'pending' status created more than 7 days ago**

---

## 2.3 Accounts

Insert **at least 15 accounts** with the following requirements:

### Requirements:
- Distribute accounts across your customers (some should have 2-3 accounts)
- Use all 5 account types
- Account numbers must be exactly 16 characters (use realistic patterns like `1234567890123456`)
- Routing numbers are exactly 9 characters (use `021000021` for testing)
- Balances should range from $0 to over $100,000
- Include variety: most active, at least one frozen, at least one closed

### Important Constraints:
- `customer_id` must reference an existing customer
- `account_type_id` must reference an existing account type (1-5)
- For closed accounts, remember to set BOTH `status = 'closed'` AND `closed_at` to a timestamp

### Example Account Insert (Idempotent):

```sql
INSERT INTO neobank.accounts (
    customer_id, account_type_id, account_number, routing_number,
    balance, currency, status, opened_at
)
SELECT 
    c.id,  -- Get customer_id dynamically
    1,     -- Basic Checking
    '1234567890123456',
    '021000021',
    2500.00,
    'USD',
    'active',
    CURRENT_TIMESTAMP - INTERVAL '90 days'
FROM neobank.customers c
WHERE c.email = 'john.doe@gmail.com'
ON CONFLICT (account_number) DO NOTHING;
```

### Specific Accounts to Include:

1. **At least one account with balance > $25,000** (for high-value query)
2. **At least one frozen account** 
3. **At least one closed account** (with `closed_at` set)
4. **At least one account with balance below its type's minimum_balance** (for status-based filtering)

---

## 2.4 Transactions

Insert **at least 30 transactions** with the following requirements:

### Requirements:
- Include all transaction types: deposit, withdrawal, transfer, fee, interest
- Include all statuses: pending, completed, failed
- Each transaction must have a unique `idempotency_key` (use `gen_random_uuid()`)
- Amounts should range from small ($5) to large ($10,000+)
- Respect the source/destination rules based on transaction type

### Transaction Type Rules:

| Type | source_account_id | destination_account_id |
|------|-------------------|------------------------|
| deposit | NULL | Must be set |
| withdrawal | Must be set | NULL |
| fee | Must be set | NULL |
| transfer | Must be set | Must be set |
| interest | Must be set | Must be set |

### Example Transactions (with fixed idempotency keys for repeatability):

For transactions, use fixed UUIDs as idempotency keys so the script is idempotent:

```sql
-- Deposit (source = NULL, destination = account)
INSERT INTO neobank.transactions (
    idempotency_key, source_account_id, destination_account_id,
    transaction_type, amount, currency, description, status, created_at
)
VALUES (
    'a0000000-0000-0000-0000-000000000001'::uuid,  -- Fixed UUID for idempotency
    NULL,
    1,  -- destination account id
    'deposit',
    5000.00,
    'USD',
    'Initial deposit',
    'completed',
    CURRENT_TIMESTAMP - INTERVAL '89 days'
)
ON CONFLICT (idempotency_key) DO NOTHING;
```

### Specific Transactions to Include:

1. **At least 3 pending transactions created more than 24 hours ago with amount > $1,000**
2. **At least 2 failed transactions created more than 1 year ago** (for cleanup query)
3. **At least 3 pending transactions of type 'fee' or 'interest'** (for batch processing)
4. **A variety of transaction dates** (some recent, some older)

---

## Order of Insertions

Due to foreign key constraints, you MUST insert data in this order:

1. `account_types` (no foreign keys)
2. `customers` (no foreign keys)
3. `accounts` (references customers and account_types)
4. `transactions` (references accounts)

---

## Verification

After running your script, verify the data:

```bash
docker compose exec -T postgres psql -U postgres -d postgres -c "
SELECT 'account_types' as table_name, COUNT(*) as count FROM neobank.account_types
UNION ALL
SELECT 'customers', COUNT(*) FROM neobank.customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM neobank.accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM neobank.transactions;
"
```

---

## Deliverable

Create the file `sql/02_seed.sql` that:

1. Inserts 5 account types (exactly as specified) with `ON CONFLICT DO NOTHING`
2. Inserts at least 10 customers with varied data
3. Inserts at least 15 accounts across customers
4. Inserts at least 30 transactions respecting all rules
5. Is fully idempotent (can run multiple times without errors)
