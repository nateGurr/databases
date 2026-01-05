# Exercise 2: LEFT OUTER JOINs (20 points)

## Learning Objectives
- Understand the difference between INNER JOIN and LEFT OUTER JOIN
- Find records that don't have matching entries in related tables
- Identify "orphan" or unmatched data using NULL checks
- Use LEFT JOIN for inclusive queries

## Background

A `LEFT OUTER JOIN` (or simply `LEFT JOIN`) returns **all rows from the left table** and the matching rows from the right table. If there's no match in the right table, the result will contain NULL values for all columns from the right table.

**Syntax:**
```sql
SELECT columns
FROM left_table
LEFT JOIN right_table ON left_table.column = right_table.column;
```

**Common Use Cases:**
- Finding customers who have never placed an order
- Listing all products, including those never sold
- Finding employees without assigned projects
- Checking for data integrity issues

**Pattern for Finding Unmatched Records:**
```sql
SELECT a.*
FROM table_a a
LEFT JOIN table_b b ON a.id = b.a_id
WHERE b.id IS NULL;  -- Returns rows from A with no match in B
```

## Schema Reference

For this exercise, focus on these relationships:
- `patients` → `appointments` (some patients may have no appointments)
- `patients` → `insurance_providers` (some patients have no insurance)
- `doctors` → `appointments` (some doctors may have no appointments yet)
- `medications` → `prescriptions` (some medications may never have been prescribed)

## Problems

### Problem 2.1 (4 points)
**Finding Patients Without Insurance**

Write a query to find all patients who do not have an insurance provider assigned (i.e., `insurance_id` is NULL). This is a simple pattern using LEFT JOIN to verify unmatched records.

Display the patient's full name, date of birth, and phone number. Order by last name.

**Expected columns:** `patient_name`, `date_of_birth`, `phone`

<details>
<summary>💡 Hint</summary>

You can do this with a simple WHERE clause on the `patients` table, but try using LEFT JOIN with `insurance_providers` to practice the pattern: patients LEFT JOIN insurance_providers, then check WHERE `insurance_providers.id IS NULL`.

</details>

---

### Problem 2.2 (4 points)
**Patients Without Appointments**

Write a query to find all patients who have **never had an appointment** at MedCare. These might be patients who registered but never scheduled a visit.

Display the patient's full name, email, registration date (`created_at`), and days since registration.

**Expected columns:** `patient_name`, `email`, `created_at`, `days_since_registration`

<details>
<summary>💡 Hint</summary>

Use LEFT JOIN between `patients` and `appointments`, then filter with `WHERE appointments.id IS NULL`. Use `CURRENT_DATE - created_at::date` or `DATE_PART` to calculate days.

</details>

---

### Problem 2.3 (4 points)
**Medications Never Prescribed**

Write a query to find all medications in the database that have **never been prescribed** to any patient. This helps identify inventory that may not be needed or medications that are rarely used.

Display the medication name, category, and whether it's a controlled substance.

**Expected columns:** `medication_name`, `category`, `is_controlled`

Order alphabetically by category, then by medication name.

<details>
<summary>💡 Hint</summary>

LEFT JOIN `medications` with `prescriptions`, then check for NULL prescription IDs.

</details>

---

### Problem 2.4 (4 points)
**All Patients with Their Insurance Status**

Write a query that shows **all patients** along with their insurance provider name and plan type. Patients without insurance should still appear in the results with NULL values for insurance information.

Include a calculated column called `insurance_status` that shows:
- 'Insured' if they have an insurance provider
- 'Uninsured' if they don't

**Expected columns:** `patient_name`, `provider_name`, `plan_type`, `insurance_status`

Order by insurance status (Uninsured first), then by patient last name.

<details>
<summary>💡 Hint</summary>

Use `CASE WHEN insurance_providers.id IS NULL THEN 'Uninsured' ELSE 'Insured' END` for the status column. LEFT JOIN patients to insurance_providers.

</details>

---

### Problem 2.5 (4 points)
**Lab Tests Never Ordered**

Write a query to find all lab tests in the system that have **never been ordered** for any patient. This can help the clinic understand which tests in their catalog are underutilized.

Display the test name, category, base price, and typical turnaround time.

**Expected columns:** `test_name`, `category`, `base_price`, `turnaround_hours`

Order by category, then by base price descending.

<details>
<summary>💡 Hint</summary>

LEFT JOIN `lab_tests` with `lab_results` on `test_id`, then filter for NULL results.

</details>

---

## Submission

Save your solutions in `sql/02-left-joins.sql`. Each solution should be clearly commented with the problem number.

```sql
-- Problem 2.1
-- Your solution here

-- Problem 2.2
-- Your solution here

-- (etc.)
```
