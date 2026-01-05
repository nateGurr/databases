# Exercise 1: Soft-Delete Patterns (15 points)

## Learning Objectives

- Understand the soft-delete pattern and its advantages over hard deletes
- Query data that includes soft-deleted records
- Implement soft-delete and restore operations
- Use views to abstract soft-delete logic

## Background

PrecisionParts uses **soft-delete** instead of permanent deletion for critical data. When a record is "deleted," the `deleted_at` timestamp is set rather than removing the row. This preserves:

- **Audit trail**: Historical data for compliance
- **Data integrity**: No orphaned foreign key references
- **Recoverability**: Accidentally deleted records can be restored

## Schema Reference

Key tables with soft-delete support:
- `employees` - has `deleted_at` column
- `materials` - has `deleted_at` column
- `parts` - has `deleted_at` column
- `machines` - has `deleted_at` column

Corresponding views for active records only:
- `active_employees`
- `active_materials`
- `active_parts`
- `active_machines`

---

## Problem 1.1: Find All Soft-Deleted Records (3 points)

Write a query that shows all soft-deleted records across the four main tables. Return the table name, record identifier, name/description, deletion date, and days since deletion.

**Expected columns:**
- `table_name`
- `record_id`
- `record_name`
- `deleted_at`
- `days_since_deletion`

**Expected output:** Should show the 2 deleted employees, 1 deleted material, 1 deleted part, and 1 deleted machine.

```sql
-- Write your query here

```

---

## Problem 1.2: Impact Analysis of Deleted Records (4 points)

The Quality Manager wants to know if any soft-deleted employees performed quality checks before being deactivated. Write a query that:

1. Lists all soft-deleted employees
2. Shows how many quality checks each performed
3. Shows the date range of their inspections
4. Includes employees who performed zero checks

**Expected columns:**
- `employee_id`
- `employee_name`
- `role`
- `deleted_at`
- `total_checks`
- `first_check_date`
- `last_check_date`

```sql
-- Write your query here

```

---

## Problem 1.3: Soft-Delete a Material (3 points)

The warehouse discovered that material `RAW-PTFE-ROD` (PTFE Rod Stock) has been discontinued by the supplier. Write an UPDATE statement to soft-delete this material.

**Requirements:**
- Set `deleted_at` to the current timestamp
- Only update if the material is not already deleted

```sql
-- Write your UPDATE statement here

```

After running your update, verify with:
```sql
SELECT sku, name, deleted_at 
FROM manufacturing.materials 
WHERE sku = 'RAW-PTFE-ROD';
```

---

## Problem 1.4: Restore a Deleted Record (3 points)

Management has decided to re-hire employee `EMP029` (Michael Foster). Write an UPDATE statement to restore this employee.

**Requirements:**
- Set `deleted_at` back to NULL
- Set `is_active` to TRUE
- Only update if the employee is currently soft-deleted

```sql
-- Write your UPDATE statement here

```

After restoring, verify the employee appears in the active employees view:
```sql
SELECT * FROM manufacturing.active_employees 
WHERE employee_id = 'EMP029';
```

---

## Problem 1.5: Cascade Soft-Delete Analysis (2 points)

When a machine is soft-deleted, we need to check if it affects any active production runs. Write a query that finds:

1. All soft-deleted machines
2. Any production runs that reference these machines
3. The status of those production runs

This helps identify if soft-deleting a machine might cause operational issues.

**Expected columns:**
- `machine_id`
- `machine_name`
- `machine_deleted_at`
- `run_id`
- `run_status`
- `part_number`

```sql
-- Write your query here

```

---

## Submission

Save your solutions in `sql/01-soft-delete.sql` with each problem clearly labeled:

```sql
-- Problem 1.1: Find All Soft-Deleted Records
-- Your query here

-- Problem 1.2: Impact Analysis of Deleted Records
-- Your query here

-- Problem 1.3: Soft-Delete a Material
-- Your UPDATE statement here

-- Problem 1.4: Restore a Deleted Record  
-- Your UPDATE statement here

-- Problem 1.5: Cascade Soft-Delete Analysis
-- Your query here
```

## Grading Rubric

| Problem | Points | Criteria |
|---------|--------|----------|
| 1.1 | 3 | Correctly queries all 4 tables with UNION, calculates days since deletion |
| 1.2 | 4 | Uses LEFT JOIN to include employees with zero checks, correct aggregation |
| 1.3 | 3 | Correct UPDATE with WHERE clause preventing double-deletion |
| 1.4 | 3 | Restores both deleted_at and is_active with proper WHERE clause |
| 1.5 | 2 | Correctly identifies production runs affected by deleted machines |
| **Total** | **15** | |
