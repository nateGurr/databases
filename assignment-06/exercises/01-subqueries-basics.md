# Exercise 1: Introduction to Subqueries (20 points)

## Learning Objectives

- Understand the difference between subqueries and joins
- Write scalar subqueries in SELECT and WHERE clauses
- Use table subqueries with IN, NOT IN operators
- Recognize when subqueries are more readable than joins

## Concept Overview

A **subquery** (also called an inner query or nested query) is a query embedded within another SQL statement. Subqueries can appear in:

- **SELECT clause** - Returns a single value (scalar subquery)
- **FROM clause** - Returns a table (derived table)
- **WHERE clause** - Filters based on another query's results

### Scalar Subqueries

A scalar subquery returns exactly one value (one row, one column):

```sql
SELECT 
    pet_name,
    weight_kg,
    (SELECT AVG(weight_kg) FROM pets) AS avg_weight
FROM pets;
```

### Table Subqueries with IN

The `IN` operator checks if a value exists in a set returned by a subquery:

```sql
-- Find all pets of species that have vaccines defined
SELECT pet_name, species_id
FROM pets
WHERE species_id IN (
    SELECT DISTINCT species_id 
    FROM vaccines
);
```

### NOT IN

The opposite - finds values NOT in the subquery results:

```sql
-- Find owners who have never had an appointment
SELECT first_name, last_name
FROM owners
WHERE owner_id NOT IN (
    SELECT DISTINCT o.owner_id 
    FROM owners o
    JOIN pets p ON o.owner_id = p.owner_id
    JOIN appointments a ON p.pet_id = a.pet_id
    WHERE a.appointment_id IS NOT NULL
);
```

---

## Exercise Tasks

### Task 1.1: Scalar Subquery in SELECT (4 points)

Write a query that displays each pet's name, weight, and how their weight compares to the average weight of all pets. Include:
- `pet_name`
- `weight_kg`
- `avg_all_pets` (the average weight of ALL pets)
- `weight_difference` (the pet's weight minus the average)

Order by weight difference descending.

### Task 1.2: Scalar Subquery in WHERE (4 points)

Find all pets whose weight is above the average weight of their species. Display:
- `pet_name`
- `species_name` (from the species table)
- `weight_kg`

Hint: You'll need a correlated subquery for this one (we'll cover these more in Exercise 2).

### Task 1.3: Using IN with Subqueries (4 points)

Find all owners who have pets that have been seen by the emergency clinic (clinic_id = 4). Display:
- `first_name`
- `last_name`
- `email`

Do NOT use JOIN - use subqueries with IN.

### Task 1.4: Using NOT IN (4 points)

Find all pets that have NEVER had a vaccination recorded. Display:
- `pet_name`
- `species_name`
- `owner's full name` (concatenate first and last name)

Use NOT IN rather than a LEFT JOIN.

### Task 1.5: Subquery in FROM Clause (4 points)

Calculate the total revenue by clinic by using a subquery in the FROM clause. Display:
- `clinic_name`
- `total_revenue` (sum of invoice totals)
- `avg_invoice` (average invoice total)

The subquery should aggregate invoice data by clinic, then the outer query should join with clinics to get the name.

---

## Expected Output Hints

### Task 1.1
Should return all pets with weight data, showing comparison to overall average (~12-15 kg).

### Task 1.2
Returns pets heavier than their species average. For example, a Golden Retriever heavier than the average dog.

### Task 1.3
Returns owners whose pets visited the emergency clinic - should be around 3 owners.

### Task 1.4
Should return several pets, particularly newer pets or exotic species that may not have vaccination records.

### Task 1.5
Should show 5 clinics (including the emergency clinic with higher revenue per visit).

---

## Submission

Save your solutions in `sql/exercise01.sql` with each task clearly labeled with comments.
