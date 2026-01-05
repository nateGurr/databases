# Exercise 2: SQL Functions (20 points)

## Learning Objectives

- Create reusable SQL functions for business logic
- Understand function parameter types and return types
- Use functions for calculations, data transformation, and validation
- Apply functions in queries and constraints

## Background

PrecisionParts needs reusable functions for common business calculations. Functions encapsulate logic that would otherwise be repeated across many queries, stored procedures, and application code.

## Function Syntax Reference

```sql
CREATE OR REPLACE FUNCTION function_name(param1 TYPE, param2 TYPE)
RETURNS return_type
LANGUAGE plpgsql
AS $$
DECLARE
    -- variable declarations
BEGIN
    -- function body
    RETURN result;
END;
$$;
```

---

## Problem 2.1: Calculate Material Value (4 points)

Create a function that calculates the total inventory value for a given material.

**Function specification:**
- **Name:** `calculate_material_value`
- **Parameter:** `p_material_id INTEGER`
- **Returns:** `NUMERIC(12,2)`
- **Logic:** `quantity_in_stock * unit_cost`
- **Edge case:** Return 0 if material not found or is soft-deleted

```sql
-- Create your function here

```

**Test your function:**
```sql
-- Should return the value of Aluminum 6061-T6 Sheet
SELECT manufacturing.calculate_material_value(1);

-- Should return 0 for deleted material
SELECT manufacturing.calculate_material_value(34);
```

---

## Problem 2.2: Production Run Duration (4 points)

Create a function that calculates how long a production run took (or is taking).

**Function specification:**
- **Name:** `get_run_duration_hours`
- **Parameter:** `p_run_id INTEGER`
- **Returns:** `NUMERIC(10,2)` (hours with 2 decimal places)
- **Logic:**
  - If run is completed: `end_time - start_time`
  - If run is in progress: `current_timestamp - start_time`
  - If run hasn't started: Return 0
- **Note:** Use `EXTRACT(EPOCH FROM interval) / 3600` to convert to hours

```sql
-- Create your function here

```

**Test your function:**
```sql
-- Test with a completed run
SELECT manufacturing.get_run_duration_hours(1);

-- Test with a running production
SELECT manufacturing.get_run_duration_hours(6);
```

---

## Problem 2.3: Part Production Cost Estimate (5 points)

Create a function that estimates the production cost for a part based on its bill of materials.

**Function specification:**
- **Name:** `estimate_part_cost`
- **Parameters:** 
  - `p_part_id INTEGER`
  - `p_quantity INTEGER DEFAULT 1`
- **Returns:** `NUMERIC(12,2)`
- **Logic:**
  1. Sum the cost of all materials: `SUM(quantity_required * material.unit_cost)`
  2. Multiply by the requested quantity
  3. Add 15% for labor and overhead
- **Edge case:** Return 0 if part not found or has no materials

```sql
-- Create your function here

```

**Test your function:**
```sql
-- Cost for 1 unit
SELECT manufacturing.estimate_part_cost(1);

-- Cost for 100 units  
SELECT manufacturing.estimate_part_cost(1, 100);

-- Part with no materials defined
SELECT manufacturing.estimate_part_cost(999);
```

---

## Problem 2.4: Quality Pass Rate (4 points)

Create a function that returns the quality pass rate for a specific part.

**Function specification:**
- **Name:** `get_part_quality_rate`
- **Parameter:** `p_part_number VARCHAR`
- **Returns:** `NUMERIC(5,2)` (percentage)
- **Logic:**
  - Count quality checks where `result IN ('pass', 'conditional')`
  - Divide by total checks for that part
  - Return as percentage (0-100)
- **Edge case:** Return 100.00 if no quality checks exist

```sql
-- Create your function here

```

**Test your function:**
```sql
-- Check pass rate for brake caliper
SELECT manufacturing.get_part_quality_rate('AERO-BRK-001');

-- Check a part with all passes
SELECT manufacturing.get_part_quality_rate('IND-BRG-001');
```

---

## Problem 2.5: Using Functions in Queries (3 points)

Write a query that uses your functions to create a part profitability report. For each active part, show:

**Expected columns:**
- `part_number`
- `part_name`
- `category`
- `estimated_cost` (use your estimate_part_cost function)
- `base_price`
- `profit_margin` (base_price - estimated_cost)
- `quality_rate` (use your get_part_quality_rate function)

Order by profit margin descending.

```sql
-- Write your query here

```

---

## Submission

Save your solutions in `sql/02-functions.sql`:

```sql
-- Problem 2.1: Calculate Material Value
-- Your function here

-- Problem 2.2: Production Run Duration
-- Your function here

-- Problem 2.3: Part Production Cost Estimate
-- Your function here

-- Problem 2.4: Quality Pass Rate
-- Your function here

-- Problem 2.5: Using Functions in Queries
-- Your query here
```

## Grading Rubric

| Problem | Points | Criteria |
|---------|--------|----------|
| 2.1 | 4 | Correct calculation, handles NULL/deleted materials |
| 2.2 | 4 | Handles all run states (completed, running, not started) |
| 2.3 | 5 | Correct BOM calculation with labor overhead, handles edge cases |
| 2.4 | 4 | Correct percentage calculation, proper handling of no checks |
| 2.5 | 3 | Query correctly uses functions, proper joins and ordering |
| **Total** | **20** | |
