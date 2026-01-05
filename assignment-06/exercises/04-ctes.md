# Exercise 4: Common Table Expressions (CTEs) (20 points)

## Learning Objectives

- Write readable queries using the WITH clause
- Chain multiple CTEs together
- Use recursive CTEs for hierarchical data
- Understand when CTEs improve query organization

## Concept Overview

### Basic CTE Syntax

A CTE (Common Table Expression) is a named temporary result set:

```sql
WITH active_pets AS (
    SELECT pet_id, pet_name, species_id
    FROM pets
    WHERE is_active = true
)
SELECT p.pet_name, s.species_name
FROM active_pets p
JOIN species s ON p.species_id = s.species_id;
```

### Multiple CTEs

You can define multiple CTEs, separated by commas:

```sql
WITH 
dog_owners AS (
    SELECT DISTINCT o.owner_id, o.first_name, o.last_name
    FROM owners o
    JOIN pets p ON o.owner_id = p.owner_id
    WHERE p.species_id = 1
),
cat_owners AS (
    SELECT DISTINCT o.owner_id, o.first_name, o.last_name
    FROM owners o
    JOIN pets p ON o.owner_id = p.owner_id
    WHERE p.species_id = 2
)
SELECT d.first_name, d.last_name, 'Both' AS pet_types
FROM dog_owners d
JOIN cat_owners c ON d.owner_id = c.owner_id;
```

### Recursive CTEs

Recursive CTEs reference themselves to traverse hierarchical data:

```sql
WITH RECURSIVE org_chart AS (
    -- Base case: top-level (no manager)
    SELECT staff_id, first_name, last_name, reports_to, 1 AS level
    FROM staff
    WHERE reports_to IS NULL
    
    UNION ALL
    
    -- Recursive case: employees with managers
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to, oc.level + 1
    FROM staff s
    JOIN org_chart oc ON s.reports_to = oc.staff_id
)
SELECT * FROM org_chart ORDER BY level, last_name;
```

### Recursive CTE Components

1. **Anchor member**: The base case (non-recursive part)
2. **UNION ALL**: Connects anchor to recursive member
3. **Recursive member**: References the CTE itself
4. **Termination**: Occurs when recursive member returns no rows

---

## Exercise Tasks

### Task 4.1: Basic CTE - Monthly Revenue Analysis (4 points)

Create a CTE that calculates monthly revenue for 2024, then use it to find months above the average. Display:
- `month_name` (use TO_CHAR)
- `monthly_revenue`
- `running_total` (cumulative sum - can use a window function or additional CTE)
- `above_average` (boolean: true if above average)

### Task 4.2: Multiple CTEs - Pet Health Summary (4 points)

Create a comprehensive pet health summary using multiple CTEs:

1. **CTE 1 (pet_visits)**: Count total visits per pet
2. **CTE 2 (pet_vaccines)**: Count vaccinations per pet
3. **CTE 3 (pet_treatments)**: Count treatments per pet

Then join all CTEs to display:
- `pet_name`
- `owner_name`
- `visit_count`
- `vaccine_count`
- `treatment_count`
- `health_score` (visits + vaccines + treatments - a simple metric)

Order by health_score descending.

### Task 4.3: Recursive CTE - Staff Hierarchy (5 points)

Use a recursive CTE to display the complete staff hierarchy at PawCare. Display:
- `staff_id`
- `full_name`
- `role`
- `level` (1 = CEO, 2 = reports to CEO, etc.)
- `management_chain` (full path from CEO, e.g., "Sarah Mitchell > John Smith > Current Person")

Order by level, then by full_name.

### Task 4.4: Recursive CTE - Organizational Tree (3 points)

Using the hierarchy from Task 4.3, answer these questions with separate queries:

**Part A**: How many staff members report directly or indirectly to each manager?

Display for each manager:
- `manager_name`
- `direct_reports`
- `total_reports` (including indirect)

**Part B**: What is the maximum depth of the organization chart?

### Task 4.5: CTE for Readability - Complex Business Query (4 points)

Rewrite the following complex query using CTEs to make it more readable:

"Find the top 3 clinics by revenue in 2024, show their most common procedure, busiest vet, and average patient weight."

Use at least 3 named CTEs to break down this query logically. Display:
- `clinic_name`
- `total_revenue`
- `most_common_procedure`
- `busiest_vet`
- `avg_patient_weight`

---

## Expected Output Hints

### Task 4.1
12 rows for 2024 months, with running totals and comparison to average.

### Task 4.2
One row per pet with aggregated health metrics. Most active pets should have higher health scores.

### Task 4.3
All ~45 staff members with their hierarchy level. CEO is level 1, clinic managers level 2, etc.

### Task 4.4
Shows management span - clinic managers should have more total reports than senior vets.

### Task 4.5
3 rows (top clinics) with comprehensive metrics. Uses CTEs for clarity.

---

## CTE vs Subquery

| Feature | CTE | Subquery |
|---------|-----|----------|
| Readability | Better for complex queries | Can become nested and hard to read |
| Reusability | Can reference multiple times | Must repeat the subquery |
| Recursion | Supported | Not supported |
| Performance | Usually same as subquery | Usually same as CTE |

---

## Submission

Save your solutions in `sql/exercise04.sql` with each task clearly labeled with comments.
