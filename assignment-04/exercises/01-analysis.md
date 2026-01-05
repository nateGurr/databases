# Exercise 1: Data Analysis (25 points)

## Objective

Analyze the unnormalized LMS data to identify problems, anomalies, and functional dependencies. This analysis will guide your normalization decisions.

## Instructions

Review the data in `data/unnormalized_lms.csv` and create a Markdown file `sql/01_analysis.md` that documents your findings.

---

## Part 1.1: Identify Data Anomalies (10 points)

For each type of anomaly, provide **at least 2 specific examples** from the data:

### Update Anomalies
Identify situations where updating one piece of information requires updating multiple rows.

**Example format:**
> If Dr. Sarah Smith changes her office from "Room 301" to "Room 305", we must update rows: 1, 3, 6, 7, 10, 11, 14 (7 rows!)

Find and document:
1. Two examples of instructor-related update anomalies
2. Two examples of course-related update anomalies
3. One example of student-related update anomalies

### Insert Anomalies
Identify situations where you cannot insert certain data without unrelated data.

**Example format:**
> We cannot add a new course "AI500 - Artificial Intelligence" to the catalog without having at least one student enrolled in it.

Find and document:
1. How would you add a new instructor who hasn't been assigned any courses yet?
2. How would you add a new module to an existing course?
3. How would you record a new department?

### Delete Anomalies
Identify situations where deleting data causes unintended loss of other information.

**Example format:**
> If we delete enrollment_id 11 (Frank Garcia's only enrollment), we lose all record that Frank Garcia exists as a student.

Find and document:
1. What happens if David Miller drops ML400?
2. What information would be lost if we deleted all WEB300 enrollments?

---

## Part 1.2: Identify Normal Form Violations (8 points)

### 1NF Violations (2 points)
List all columns that contain non-atomic (multi-valued) data:

| Column Name | Example Value | Problem |
|-------------|---------------|---------|
| ? | ? | Contains multiple values separated by commas |

### 2NF Violations (3 points)
Assuming the primary key is `enrollment_id`, identify partial dependencies where a non-key attribute depends on only PART of what could be a composite key:

| Attribute | Depends Only On | Not The Full Key |
|-----------|-----------------|------------------|
| ? | ? | ? |

### 3NF Violations (3 points)
Identify transitive dependencies (non-key attribute depends on another non-key attribute):

| Attribute | Depends On | Which Depends On |
|-----------|------------|------------------|
| ? | ? | (primary key) |

---

## Part 1.3: Document Functional Dependencies (7 points)

List ALL functional dependencies you can identify in the data.

### Format
```
determinant → dependent_attribute(s)
```

### Student-Related Dependencies (2 points)
```
student_email → ???
```

### Instructor-Related Dependencies (2 points)
```
instructor_email → ???
```

### Course-Related Dependencies (2 points)
```
course_code → ???
```

### Enrollment-Related Dependencies (1 point)
```
enrollment_id → ???
(student_email, course_code) → ???
```

---

## Deliverable

Create `sql/01_analysis.md` with the following structure:

```markdown
# EduLearn LMS - Data Analysis

## 1. Data Anomalies

### 1.1 Update Anomalies
[Your examples here]

### 1.2 Insert Anomalies
[Your examples here]

### 1.3 Delete Anomalies
[Your examples here]

## 2. Normal Form Violations

### 2.1 First Normal Form (1NF) Violations
[Your findings]

### 2.2 Second Normal Form (2NF) Violations
[Your findings]

### 2.3 Third Normal Form (3NF) Violations
[Your findings]

## 3. Functional Dependencies

### 3.1 Student Dependencies
[List of FDs]

### 3.2 Instructor Dependencies
[List of FDs]

### 3.3 Course Dependencies
[List of FDs]

### 3.4 Module Dependencies
[List of FDs]

### 3.5 Assignment Dependencies
[List of FDs]

### 3.6 Enrollment Dependencies
[List of FDs]

### 3.7 Department Dependencies
[List of FDs]
```

---

## Grading Rubric

| Criterion | Points |
|-----------|--------|
| Update anomalies (5 examples) | 4 |
| Insert anomalies (3 examples) | 3 |
| Delete anomalies (2 examples) | 3 |
| 1NF violations identified | 2 |
| 2NF violations identified | 3 |
| 3NF violations identified | 3 |
| Functional dependencies documented | 7 |
| **Total** | **25** |
