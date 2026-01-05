# Exercise 4: Transactions (25 points)

## Learning Objectives

- Understand ACID properties and their importance
- Write multi-statement transactions
- Handle transaction rollback and error recovery
- Use savepoints for partial rollback
- Understand isolation levels

## Background

Manufacturing operations often require multiple database changes that must succeed or fail together. For example:

- Creating a production order with line items
- Consuming materials and updating inventory
- Processing a quality check and updating run status

Transactions ensure data consistency when operations span multiple tables.

## Transaction Control Language (TCL) Reference

```sql
BEGIN;                      -- Start transaction
-- ... your SQL statements ...
COMMIT;                     -- Save all changes

BEGIN;
-- ... statements ...
ROLLBACK;                   -- Undo all changes

BEGIN;
-- ... statements ...
SAVEPOINT my_savepoint;
-- ... more statements ...
ROLLBACK TO my_savepoint;   -- Undo to savepoint
COMMIT;                     -- Save changes before savepoint
```

---

## Problem 4.1: Create Production Order Transaction (5 points)

Write a transaction that creates a complete production order with line items.

**Scenario:** Lockheed Martin orders:
- 50 units of AERO-BRK-001 (brake caliper)
- 100 units of AERO-MNT-001 (engine mount bracket)
- 25 units of AERO-HSG-001 (sensor housing)

**Requirements:**
- Create the production order with appropriate fields
- Add all three order items
- If any INSERT fails, roll back the entire transaction
- Return the new order_id

```sql
BEGIN;

-- Create the production order


-- Add order items


-- Verify the order was created correctly
SELECT 
    po.order_number,
    po.customer_name,
    COUNT(oi.item_id) as line_items,
    SUM(oi.quantity_ordered) as total_units
FROM manufacturing.production_orders po
JOIN manufacturing.order_items oi ON po.order_id = oi.order_id
WHERE po.order_id = (SELECT MAX(order_id) FROM manufacturing.production_orders)
GROUP BY po.order_number, po.customer_name;

COMMIT;
```

---

## Problem 4.2: Material Consumption Transaction (6 points)

Write a transaction that consumes materials for a production run.

**Scenario:** Production run starting for part AERO-BRK-001 (10 units). Consume the required materials.

**Requirements:**
1. Look up the bill of materials for the part
2. Calculate required quantities (BOM quantity × 10 units)
3. Check if sufficient stock exists for ALL materials
4. If sufficient: deduct from inventory and log to inventory_log
5. If insufficient: rollback and report which material is short

```sql
BEGIN;

-- Set the user for logging
SET LOCAL app.current_user_id = '13';

-- Your implementation here
-- Hint: Use a CTE or temp table to check all materials first

COMMIT;  -- or ROLLBACK based on your checks
```

---

## Problem 4.3: Quality Check with Conditional Update (5 points)

Write a transaction that processes a quality check and updates the production run status.

**Scenario:** Quality inspector performs final inspection on production run RUN-2024-0002.

**Requirements:**
1. Insert a quality check record (type: 'final', result: based on defects found)
2. If result is 'pass': update production run status to 'completed', set end_time
3. If result is 'fail': update production run status to 'stopped', log reason
4. Use savepoints to allow partial rollback if needed

```sql
BEGIN;

SET LOCAL app.current_user_id = '10';

-- Assume inspection found no defects - this is a pass
SAVEPOINT before_status_update;

-- Insert quality check


-- Update production run based on result


COMMIT;
```

---

## Problem 4.4: Bulk Price Update with Validation (5 points)

Write a transaction that updates prices for all parts in a category with validation.

**Scenario:** Increase aerospace parts prices by 8% due to material cost increases.

**Requirements:**
1. Create a savepoint before each price update
2. Update prices for 'aerospace' category parts
3. Validate no price exceeds $10,000
4. If any price would exceed limit:
   - Rollback that specific update using savepoint
   - Log which part was skipped
   - Continue with other parts
5. Commit successful updates

```sql
BEGIN;

-- Your implementation
-- Hint: Use a loop or cursor to update one at a time with savepoints

COMMIT;
```

---

## Problem 4.5: Machine Maintenance Transaction (4 points)

Write a transaction that logs machine maintenance and updates machine status.

**Scenario:** Preventive maintenance on machine MIL-002 (Haas VF-4 Mill).

**Requirements:**
1. Insert maintenance log entry
2. Update machine status based on maintenance type:
   - 'preventive': keep status as 'operational'
   - 'corrective': set status to 'maintenance'
   - 'emergency': set status to 'offline'
3. Update the `last_maintenance` timestamp on the machine

```sql
BEGIN;

SET LOCAL app.current_user_id = '21';

-- Preventive maintenance scenario


COMMIT;
```

---

## Bonus: Demonstrate Isolation Levels (Optional, +3 points)

In two separate database connections (two Adminer tabs), demonstrate a concurrency issue and how isolation levels prevent it.

**Scenario:** Two operators try to consume the same material simultaneously.

Document your test:
1. What isolation level did you use?
2. What was the initial state?
3. What commands did you run in each connection?
4. What was the result?

```sql
-- Connection 1:


-- Connection 2:


-- Explanation:
```

---

## Submission

Save your solutions in `sql/04-transactions.sql`:

```sql
-- Problem 4.1: Create Production Order Transaction
-- Your transaction here

-- Problem 4.2: Material Consumption Transaction
-- Your transaction here

-- Problem 4.3: Quality Check with Conditional Update
-- Your transaction here

-- Problem 4.4: Bulk Price Update with Validation
-- Your transaction here

-- Problem 4.5: Machine Maintenance Transaction
-- Your transaction here

-- Bonus: Isolation Level Demonstration (Optional)
-- Your demonstration and explanation here
```

## Grading Rubric

| Problem | Points | Criteria |
|---------|--------|----------|
| 4.1 | 5 | Creates order and all items atomically, proper error handling |
| 4.2 | 6 | Checks all materials before consuming, proper inventory logging |
| 4.3 | 5 | Conditional logic based on result, proper use of savepoints |
| 4.4 | 5 | Uses savepoints for partial rollback, continues after invalid prices |
| 4.5 | 4 | Correct maintenance logging, proper status update |
| Bonus | +3 | Demonstrates isolation issue and solution |
| **Total** | **25** | (+3 bonus) |
