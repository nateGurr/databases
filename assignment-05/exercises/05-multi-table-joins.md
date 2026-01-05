# Exercise 5: Multi-Table Complex Joins (20 points)

## Learning Objectives
- Combine 4+ tables in a single query
- Build complex business reports using multiple join types
- Understand join order and its impact on results
- Apply appropriate join types based on data requirements

## Background

Real-world database queries often require joining many tables together to answer business questions. When working with multiple joins:

1. **Start with the main entity** - Identify which table is central to your query
2. **Add tables one at a time** - Think through each relationship
3. **Consider join types carefully** - INNER vs OUTER at each step
4. **Verify your results** - Unexpected row counts often indicate wrong join types

**Example Multi-Table Query:**
```sql
SELECT 
    p.name AS patient,
    d.name AS doctor,
    dept.name AS department,
    a.scheduled_at,
    diag.description AS diagnosis,
    m.name AS medication
FROM patients p
INNER JOIN appointments a ON p.id = a.patient_id
INNER JOIN doctors d ON a.doctor_id = d.id
INNER JOIN departments dept ON d.department_id = dept.id
LEFT JOIN diagnoses diag ON a.id = diag.appointment_id
LEFT JOIN prescriptions rx ON diag.id = rx.diagnosis_id
LEFT JOIN medications m ON rx.medication_id = m.id;
```

## Problems

### Problem 5.1 (4 points)
**Comprehensive Patient Visit Report**

Create a detailed report showing patient visits with full context. For each **completed** appointment, show:
- Patient full name and insurance provider (or 'Self-Pay' if uninsured)
- Doctor full name and their department
- Appointment date and visit type
- Primary diagnosis (if any)

**Expected columns:** `patient_name`, `insurance_provider`, `doctor_name`, `department`, `appointment_date`, `visit_type`, `primary_diagnosis`

Order by appointment date descending. Limit to 50 rows.

<details>
<summary>💡 Hint</summary>

Join path: `patients` → `insurance_providers` (LEFT) → `appointments` → `doctors` → `departments` → `diagnoses` (LEFT, filter for `is_primary = true`)

Use COALESCE for the insurance provider name to show 'Self-Pay'.

</details>

---

### Problem 5.2 (4 points)
**Doctor Productivity Dashboard**

Create a dashboard query showing doctor performance metrics across multiple dimensions. For each active doctor, show:
- Doctor name and their department
- Total appointments (all statuses)
- Completed appointments only
- Total unique patients seen
- Number of prescriptions written
- Their supervisor's name (if any)

**Expected columns:** `doctor_name`, `department`, `total_appointments`, `completed_appointments`, `unique_patients`, `prescriptions_written`, `supervisor_name`

Order by completed appointments descending.

<details>
<summary>💡 Hint</summary>

This requires joining `doctors` with:
- `departments` (INNER)
- `doctors` again as supervisor (LEFT/self-join)
- `appointments` (LEFT for counts)
- `diagnoses` (LEFT, through appointments)
- `prescriptions` (LEFT, through diagnoses)

Use COUNT(DISTINCT ...) for unique patients.

</details>

---

### Problem 5.3 (4 points)
**Insurance Claims Analysis**

Create a financial report analyzing insurance claims. For each insurance provider, show:
- Provider name and plan type
- Number of patients enrolled
- Total claims submitted
- Total amount billed
- Total amount paid
- Average payment percentage (amount_paid / amount_billed * 100)
- Number of denied claims

**Expected columns:** `provider_name`, `plan_type`, `patient_count`, `total_claims`, `total_billed`, `total_paid`, `avg_payment_pct`, `denied_claims`

Order by total billed descending.

<details>
<summary>💡 Hint</summary>

Start from `insurance_providers`, LEFT JOIN to `patients` for patient counts, LEFT JOIN to `claims` for claim statistics. Use conditional aggregation: `COUNT(CASE WHEN status = 'denied' THEN 1 END)` for denied claims.

</details>

---

### Problem 5.4 (4 points)
**Complete Prescription Chain**

Trace the full chain from patient to medication for all prescriptions. Show:
- Patient name and their primary care status
- Appointment date and reason
- Doctor who prescribed and their department
- Diagnosis (ICD code and description)
- Medication name and category
- Prescription details (dosage, frequency, duration)

**Expected columns:** `patient_name`, `appointment_date`, `doctor_name`, `department`, `icd_code`, `diagnosis`, `medication_name`, `med_category`, `dosage`, `frequency`, `duration_days`

Order by appointment date descending, then by patient name.

<details>
<summary>💡 Hint</summary>

Join chain: `patients` → `appointments` → `doctors` → `departments`
Also: `appointments` → `diagnoses` → `prescriptions` → `medications`

All should be INNER JOINs since we want complete prescription records.

</details>

---

### Problem 5.5 (4 points)
**Lab Results with Full Context**

Create a lab results report with complete context. For each lab result, show:
- Patient name and blood type
- Ordering doctor and their department
- Test name and category
- Result value with reference range
- Whether the result is abnormal
- Related appointment date and reason (if linked to an appointment)

**Expected columns:** `patient_name`, `blood_type`, `doctor_name`, `department`, `test_name`, `test_category`, `result_value`, `reference_range`, `is_abnormal`, `appointment_date`, `appointment_reason`

Filter for only **completed** lab results. Order by collection date descending.

<details>
<summary>💡 Hint</summary>

Join from `lab_results`:
- → `patients` (INNER)
- → `doctors` (INNER for ordering doctor)
- → `departments` (INNER)
- → `lab_tests` (INNER)
- → `appointments` (LEFT - not all labs are linked to appointments)

Create a calculated column for `is_abnormal` based on the `abnormal_flag` column.

</details>

---

## Bonus Challenge (No extra points, just for practice)

**The Ultimate Healthcare Query**

Write a single query that answers: "For each department, what is the most common diagnosis made in 2024, which medication is most frequently prescribed for that diagnosis, and which doctor in that department has written the most prescriptions?"

This requires creative use of window functions, CTEs (from Week 06), and multiple complex joins.

---

## Submission

Save your solutions in `sql/05-multi-table-joins.sql`. Each solution should be clearly commented with the problem number.

```sql
-- Problem 5.1
-- Your solution here

-- Problem 5.2
-- Your solution here

-- (etc.)
```
