# Exercise 3: Triggers (20 points)

## Learning Objectives

- Create triggers that fire on INSERT, UPDATE, or DELETE operations
- Implement audit logging with triggers
- Use triggers for data validation and business rules
- Understand trigger timing (BEFORE vs AFTER)

## Background

Triggers automatically execute in response to database events. PrecisionParts uses triggers for:

- **Audit logging**: Track who changed what and when
- **Data integrity**: Enforce complex business rules
- **Automation**: Update related records automatically

## Trigger Syntax Reference

```sql
-- Create the trigger function
CREATE OR REPLACE FUNCTION trigger_function_name()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- For BEFORE triggers: modify NEW record
    -- For AFTER triggers: just perform actions
    
    -- Available variables:
    -- NEW: the new row (INSERT/UPDATE)
    -- OLD: the old row (UPDATE/DELETE)
    -- TG_OP: 'INSERT', 'UPDATE', or 'DELETE'
    -- TG_TABLE_NAME: name of the table
    
    RETURN NEW; -- for BEFORE triggers
    -- or RETURN NULL for AFTER triggers
END;
$$;

-- Attach trigger to table
CREATE TRIGGER trigger_name
    BEFORE|AFTER INSERT|UPDATE|DELETE ON table_name
    FOR EACH ROW
    EXECUTE FUNCTION trigger_function_name();
```

---

## Problem 3.1: Audit Log Trigger (5 points)

Create a trigger that logs all changes to the `parts` table into the `audit_log` table.

**Requirements:**
- Trigger on INSERT, UPDATE, and DELETE
- Log the following:
  - `table_name`: 'parts'
  - `record_id`: the part_id
  - `action`: 'INSERT', 'UPDATE', or 'DELETE'
  - `old_data`: JSON of old record (NULL for INSERT)
  - `new_data`: JSON of new record (NULL for DELETE)
  - `changed_fields`: array of column names that changed (UPDATE only)
  - `performed_by`: use `current_setting('app.current_user_id', true)::INTEGER` or default to 0

**Hint:** Use `row_to_json()` to convert rows to JSON.

```sql
-- Create the trigger function
CREATE OR REPLACE FUNCTION manufacturing.audit_parts_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Your implementation here
END;
$$;

-- Create the trigger

```

**Test your trigger:**
```sql
-- Set the current user for audit
SET app.current_user_id = '1';

-- Update a part
UPDATE manufacturing.parts 
SET base_price = base_price * 1.05 
WHERE part_id = 1;

-- Check audit log
SELECT * FROM manufacturing.audit_log 
WHERE table_name = 'parts' 
ORDER BY performed_at DESC LIMIT 1;
```

---

## Problem 3.2: Inventory Movement Trigger (5 points)

Create a trigger that automatically logs material inventory changes.

**Requirements:**
- Fire AFTER UPDATE on `materials` table
- Only log when `quantity_in_stock` changes
- Insert a record into `inventory_log` with:
  - `material_id`
  - `change_type`: 'adjusted'
  - `quantity_change`: new quantity - old quantity
  - `quantity_before`: old quantity
  - `quantity_after`: new quantity
  - `unit_cost`: current unit cost
  - `reason`: 'Automatic adjustment logged by trigger'
  - `performed_by`: from session setting or default 0

```sql
-- Create the trigger function


-- Create the trigger

```

**Test your trigger:**
```sql
SET app.current_user_id = '9';

-- Adjust inventory
UPDATE manufacturing.materials 
SET quantity_in_stock = quantity_in_stock - 10 
WHERE material_id = 1;

-- Check inventory log
SELECT * FROM manufacturing.inventory_log 
WHERE material_id = 1 
ORDER BY created_at DESC LIMIT 1;
```

---

## Problem 3.3: Order Status History Trigger (4 points)

Create a trigger that tracks all status changes for production orders.

**Requirements:**
- Fire AFTER UPDATE on `production_orders`
- Only fire when `status` column changes
- Insert into `order_status_history`:
  - `order_id`
  - `old_status`
  - `new_status`
  - `changed_by`: from session setting
  - `changed_at`: current timestamp

```sql
-- Create the trigger function


-- Create the trigger

```

**Test your trigger:**
```sql
SET app.current_user_id = '7';

-- Change order status
UPDATE manufacturing.production_orders 
SET status = 'in_production' 
WHERE order_id = 14;  -- PO-2024-014

-- Check history
SELECT * FROM manufacturing.order_status_history 
WHERE order_id = 14 
ORDER BY changed_at DESC;
```

---

## Problem 3.4: Low Stock Alert Trigger (3 points)

Create a trigger that raises a notice when material stock falls below the reorder level.

**Requirements:**
- Fire AFTER UPDATE on `materials`
- Check if new `quantity_in_stock` < `reorder_level`
- Only alert if this wasn't already the case (transitioning to low stock)
- Use `RAISE NOTICE` to output alert message

```sql
-- Create the trigger function


-- Create the trigger

```

**Test your trigger:**
```sql
-- This should raise a notice
UPDATE manufacturing.materials 
SET quantity_in_stock = 5 
WHERE material_id = 1;  -- Aluminum sheet, reorder at 50
```

---

## Problem 3.5: Prevent Deletion of Active Machines (3 points)

Create a BEFORE DELETE trigger that prevents hard deletion of machines that have production runs.

**Requirements:**
- Fire BEFORE DELETE on `machines`
- Check if machine has any production runs (any status)
- If runs exist: raise an exception with a helpful message
- If no runs: allow the deletion

```sql
-- Create the trigger function


-- Create the trigger

```

**Test your trigger:**
```sql
-- This should fail (machine has production runs)
DELETE FROM manufacturing.machines WHERE machine_id = 1;

-- This might succeed (check if machine 14 has runs first)
DELETE FROM manufacturing.machines WHERE machine_id = 14;
```

---

## Submission

Save your solutions in `sql/03-triggers.sql`:

```sql
-- Problem 3.1: Audit Log Trigger
-- Your trigger function and trigger here

-- Problem 3.2: Inventory Movement Trigger  
-- Your trigger function and trigger here

-- Problem 3.3: Order Status History Trigger
-- Your trigger function and trigger here

-- Problem 3.4: Low Stock Alert Trigger
-- Your trigger function and trigger here

-- Problem 3.5: Prevent Deletion of Active Machines
-- Your trigger function and trigger here
```

## Grading Rubric

| Problem | Points | Criteria |
|---------|--------|----------|
| 3.1 | 5 | Handles all 3 operations, correct JSON conversion, tracks changed fields |
| 3.2 | 5 | Only fires on quantity change, calculates change correctly |
| 3.3 | 4 | Only fires on status change, logs old and new status |
| 3.4 | 3 | Correct condition (transition to low stock), uses RAISE NOTICE |
| 3.5 | 3 | Correctly prevents deletion, allows deletion when no runs |
| **Total** | **20** | |
