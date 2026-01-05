# EduLearn LMS - Data Analysis

## Instructions

Analyze the unnormalized CSV data in `../data/unnormalized_lms.csv` and document the following:

## 1. Data Anomalies

### 1.1 Update Anomalies
Identify at least 2 update anomalies. For each, describe:
- What data needs to be updated
- How many rows would need to change
- What happens if some rows are missed

**Your Analysis:**
<!-- TODO: Document update anomalies here -->


### 1.2 Insert Anomalies
Identify at least 3 insert anomalies. For each, describe:
- What new data you want to insert
- Why the current structure prevents this
- Example scenario

**Your Analysis:**
<!-- TODO: Document insert anomalies here -->


### 1.3 Delete Anomalies
Identify at least 2 delete anomalies. For each, describe:
- What data you want to delete
- What unrelated data would be lost
- Why this is problematic

**Your Analysis:**
<!-- TODO: Document delete anomalies here -->


---

## 2. Normal Form Violations

### 2.1 First Normal Form (1NF) Violations
Create a table listing columns that violate 1NF:

| Column Name | Example Value | Problem |
|-------------|---------------|---------|
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

**Your Analysis:**
<!-- TODO: Identify multi-valued columns -->


### 2.2 Second Normal Form (2NF) Violations
If we consider `(student_email, course_code)` as a candidate composite key:

| Attribute | Depends Only On | Not The Full Key |
|-----------|-----------------|------------------|
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

**Your Analysis:**
<!-- TODO: Identify partial dependencies -->


### 2.3 Third Normal Form (3NF) Violations
Identify transitive dependencies:

| Attribute | Depends On | Which Depends On |
|-----------|------------|------------------|
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

Show the transitive dependency chain:
```
<!-- TODO: e.g., course_code → instructor_email → instructor_name -->
```

---

## 3. Functional Dependencies

Document all functional dependencies you identify in the data.

### 3.1 Student Dependencies
```
<!-- TODO: e.g., student_email → student_name -->
```

### 3.2 Instructor Dependencies
```
<!-- TODO: Document instructor-related dependencies -->
```

### 3.3 Course Dependencies
```
<!-- TODO: Document course-related dependencies -->
```

### 3.4 Module Dependencies
```
<!-- TODO: Document module-related dependencies -->
```

### 3.5 Assignment Dependencies
```
<!-- TODO: Document assignment-related dependencies -->
```

### 3.6 Enrollment Dependencies
```
<!-- TODO: Document enrollment-related dependencies -->
```

### 3.7 Department Dependencies
```
<!-- TODO: Document department-related dependencies -->
```
