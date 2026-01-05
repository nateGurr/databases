-- =============================================================================
-- Master Database Initialization Script
-- Creates all databases and users for assignments 02-07
-- =============================================================================

-- Assignment 02: NeoBank (uses public schema in postgres database)
-- Uses the default postgres database, no extra database needed

-- Assignment 03: ShopFlow
CREATE DATABASE shopflow_db;
CREATE USER shopflow_admin WITH PASSWORD 'shopflow_secure_2024';
GRANT ALL PRIVILEGES ON DATABASE shopflow_db TO shopflow_admin;

-- Assignment 04: EduLearn LMS
CREATE DATABASE edulearn_lms;
CREATE USER edulearn WITH PASSWORD 'edulearn_pass';
GRANT ALL PRIVILEGES ON DATABASE edulearn_lms TO edulearn;

-- Assignment 05: MedCare Clinic
CREATE DATABASE medcare;
CREATE USER medcare WITH PASSWORD 'medcare123';
GRANT ALL PRIVILEGES ON DATABASE medcare TO medcare;

-- Assignment 06: PawCare Veterinary
CREATE DATABASE pawcare;
CREATE USER pawcare WITH PASSWORD 'pawcare123';
GRANT ALL PRIVILEGES ON DATABASE pawcare TO pawcare;

-- Assignment 07: PrecisionParts Manufacturing
CREATE DATABASE precision_parts;
