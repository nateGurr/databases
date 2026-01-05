# Exercise 3: Queries (DQL - SELECT)

## Objective

Write SELECT queries to retrieve and filter data from the NeoBank database. You will practice:

- `SELECT ... FROM` basic syntax
- `WHERE` clause for filtering
- `ORDER BY` for sorting
- `LIMIT` for restricting results
- Comparison operators: `=`, `>`, `<`, `>=`, `<=`, `<>`
- Logical operators: `AND`, `OR`, `NOT`
- Pattern matching with `LIKE`
- Working with NULL values
- Date/time comparisons

## Your Task

Create a file called `sql/03_queries.sql` containing 10 SELECT queries. Each query should include a comment explaining what it does.

---

## Query 1: List All Verified Customers

**Goal:** Select all customers with 'verified' KYC status, ordered alphabetically by last name, then first name.

**Columns to return:** id, email, first_name, last_name, kyc_status

**Concepts:** WHERE with equality, ORDER BY with multiple columns

```sql
-- Example structure:
SELECT column1, column2, ...
FROM neobank.customers
WHERE condition
ORDER BY column1, column2;
```

---

## Query 2: High-Value Accounts

**Goal:** Find all accounts with a balance greater than $25,000.

**Columns to return:** id, account_number, balance, status

**Order by:** balance descending

**Concepts:** WHERE with comparison operator, ORDER BY DESC

---

## Query 3: Gmail Users (Pattern Matching)

**Goal:** Find all customers whose email ends with '@gmail.com'.

**Columns to return:** id, email, first_name, last_name, created_at

**Order by:** created_at descending

**Limit:** 5 results

**Concepts:** LIKE pattern matching with `%`, LIMIT

**Hint:** Use `email LIKE '%@gmail.com'`

---

## Query 4: Recent Transactions

**Goal:** Find all transactions created in the last 30 days.

**Columns to return:** id, transaction_type, amount, status, created_at

**Order by:** created_at descending

**Concepts:** Date arithmetic with INTERVAL

**Hint:** `created_at >= CURRENT_TIMESTAMP - INTERVAL '30 days'`

---

## Query 5: Pending Customers for Review

**Goal:** Find customers with 'pending' KYC status who signed up more than 7 days ago (need review).

**Columns to return:** id, email, first_name, last_name, kyc_status, created_at

**Order by:** created_at ascending (oldest first)

**Concepts:** Combining conditions with AND, date comparison

---

## Query 6: Frozen or Closed Accounts

**Goal:** Find all accounts that are either 'frozen' OR 'closed'.

**Columns to return:** id, account_number, balance, status, closed_at

**Order by:** status, then balance descending

**Concepts:** OR operator, ordering by multiple columns

---

## Query 7: Large Pending Transactions

**Goal:** Find all transactions that:
- Are still in 'pending' status
- Were created more than 24 hours ago
- Have an amount greater than $1,000

**Columns to return:** id, transaction_type, amount, status, created_at

**Order by:** amount descending, then created_at ascending

**Concepts:** Combining multiple WHERE conditions with AND

**Hint:** Use `CURRENT_TIMESTAMP - INTERVAL '24 hours'` for 24 hours ago

---

## Query 8: Specific Transaction Types

**Goal:** Find all withdrawal and fee transactions.

**Columns to return:** id, transaction_type, amount, source_account_id, status, created_at

**Order by:** created_at descending

**Concepts:** Using IN operator or multiple OR conditions

**Two ways to write this:**
```sql
-- Option 1: Using OR
WHERE transaction_type = 'withdrawal' OR transaction_type = 'fee'

-- Option 2: Using IN
WHERE transaction_type IN ('withdrawal', 'fee')
```

---

## Query 9: Multi-Condition Customer Search

**Goal:** Find all customers who:
- Have verified KYC status AND
- Were born between 1980 and 1995 AND
- Have a phone number starting with '+1'

**Columns to return:** id, email, phone_number, first_name, last_name, date_of_birth, kyc_status

**Order by:** date_of_birth ascending

**Concepts:** Multiple AND conditions, BETWEEN, LIKE with prefix matching

**Hint for date range:**
```sql
date_of_birth BETWEEN '1980-01-01' AND '1995-12-31'
```

---

## Query 10: Failed Transactions Cleanup Candidates

**Goal:** Find all transactions with 'failed' status that were created more than 1 year ago (candidates for cleanup).

**Columns to return:** id, transaction_type, amount, status, created_at

**Order by:** created_at ascending

**Concepts:** Date arithmetic with year interval

**Hint:** `created_at < CURRENT_TIMESTAMP - INTERVAL '1 year'`

---

## SQL Syntax Reference

### SELECT Statement Structure

```sql
SELECT column1, column2, ...
FROM schema.table_name
WHERE conditions
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC]
LIMIT number;
```

### Comparison Operators

| Operator | Meaning |
|----------|---------|
| `=` | Equal to |
| `<>` or `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal |
| `<=` | Less than or equal |
| `BETWEEN x AND y` | Inclusive range |
| `IN (a, b, c)` | Matches any value in list |
| `LIKE 'pattern'` | Pattern matching |
| `IS NULL` | Is null value |
| `IS NOT NULL` | Is not null value |

### Pattern Matching with LIKE

| Pattern | Matches |
|---------|---------|
| `'%gmail.com'` | Ends with 'gmail.com' |
| `'+1%'` | Starts with '+1' |
| `'%bank%'` | Contains 'bank' anywhere |
| `'____'` | Exactly 4 characters |

### Logical Operators

```sql
-- AND: both conditions must be true
WHERE status = 'active' AND balance > 1000

-- OR: at least one condition must be true
WHERE status = 'frozen' OR status = 'closed'

-- Parentheses for complex logic
WHERE kyc_status = 'verified' AND (email LIKE '%bank%' OR phone_number LIKE '+1%')
```

---

## Verification

Run each query and verify it returns expected results based on your seed data.

**To run your queries file:**

```bash
docker compose exec -T postgres psql -U postgres -d postgres -f /sql/03_queries.sql
```

**To run a single query for testing:**

```bash
docker compose exec -T postgres psql -U postgres -d postgres -c "SELECT * FROM neobank.customers WHERE kyc_status = 'verified' ORDER BY last_name, first_name;"
```

---

## Deliverable

Create the file `sql/03_queries.sql` with:

1. 10 SELECT queries as specified above
2. A comment before each query explaining its purpose
3. Proper formatting for readability
