#!/bin/bash
# =============================================================================
# EduLearn LMS - Assignment 04 Verification Script
# =============================================================================
# This script verifies student submissions for the normalization assignment
# Usage: ./verify.sh
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_NAME="${CONTAINER_NAME:-databases-postgres}"
DB_NAME="${DB_NAME:-edulearn_lms}"
DB_USER="${DB_USER:-postgres}"
DB_SCHEMA="edulearn"
SQL_DIR="./sql"

# Score tracking
TOTAL_POINTS=0
MAX_POINTS=100

echo "========================================"
echo "  EduLearn LMS Assignment 4 - Verification"
echo "========================================"
echo ""

# Function to run SQL and capture result
run_sql() {
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -t -c "$1" 2>/dev/null | grep -v '^$' | head -1 | tr -d ' '
}

# Function to run SQL with search path set
run_sql_with_schema() {
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "SET search_path TO $DB_SCHEMA; $1" -t -A 2>/dev/null
}

# Function to print test result
print_result() {
    local test_name=$1
    local passed=$2
    local points=$3

    if [ "$passed" = true ]; then
        echo -e "${GREEN}PASS${NC}: $test_name (+$points pts)"
        TOTAL_POINTS=$((TOTAL_POINTS + points))
    else
        echo -e "${RED}FAIL${NC}: $test_name (0/$points pts)"
    fi
}

# ============================================
# STEP 1: Check environment
# ============================================
echo "----------------------------------------"
echo "Step 1: Checking environment..."
echo "----------------------------------------"

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${RED}Error: Container '$CONTAINER_NAME' is not running.${NC}"
    echo "Please start the database with: docker-compose up -d"
    exit 1
fi
echo -e "${GREEN}PASS:${NC} Container '$CONTAINER_NAME' is running"
echo ""

# ============================================
# STEP 2: Check for required files
# ============================================
echo "----------------------------------------"
echo "Step 2: Checking for required files..."
echo "----------------------------------------"

SCHEMA_FILE="$SQL_DIR/02_schema.sql"
SEED_FILE="$SQL_DIR/03_seed.sql"
INDEXES_FILE="$SQL_DIR/04_indexes.sql"

if [ -f "$SCHEMA_FILE" ]; then
    echo -e "${GREEN}PASS:${NC} Found: 02_schema.sql"
else
    echo -e "${YELLOW}⚠${NC} Missing: 02_schema.sql"
fi

if [ -f "$SEED_FILE" ]; then
    echo -e "${GREEN}PASS:${NC} Found: 03_seed.sql"
else
    echo -e "${YELLOW}⚠${NC} Missing: 03_seed.sql"
fi

if [ -f "$INDEXES_FILE" ]; then
    echo -e "${GREEN}PASS:${NC} Found: 04_indexes.sql"
else
    echo -e "${YELLOW}⚠${NC} Missing: 04_indexes.sql"
fi
echo ""

# ============================================
# STEP 3: Verify Schema (40 points)
# ============================================
echo "----------------------------------------"
echo "Step 3: Verifying schema (40 points)..."
echo "----------------------------------------"

# Check if schema exists (5 pts)
SCHEMA_EXISTS=$(run_sql "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$DB_SCHEMA';")
if [ "$SCHEMA_EXISTS" = "1" ]; then
    print_result "Schema '$DB_SCHEMA' exists" true 5
else
    print_result "Schema '$DB_SCHEMA' exists" false 5
fi

# Required tables (20 pts - 2 each)
REQUIRED_TABLES=("departments" "instructors" "students" "student_phones" "courses" "modules" "assignments" "enrollments" "grades" "certificates")

for table in "${REQUIRED_TABLES[@]}"; do
    EXISTS=$(run_sql "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_SCHEMA' AND table_name = '$table';")
    if [ "$EXISTS" = "1" ]; then
        print_result "Table '$table' exists" true 2
    else
        print_result "Table '$table' exists" false 2
    fi
done

# Check foreign key constraints (10 pts)
FK_COUNT=$(run_sql "SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_type = 'FOREIGN KEY' AND table_schema = '$DB_SCHEMA';")
FK_COUNT=${FK_COUNT:-0}
if [ "$FK_COUNT" -ge 8 ]; then
    print_result "Foreign key constraints (found $FK_COUNT, min 8)" true 10
else
    print_result "Foreign key constraints (found $FK_COUNT, min 8)" false 10
fi

# Check unique constraints (5 pts)
UNIQUE_COUNT=$(run_sql "SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_type = 'UNIQUE' AND table_schema = '$DB_SCHEMA';")
UNIQUE_COUNT=${UNIQUE_COUNT:-0}
if [ "$UNIQUE_COUNT" -ge 5 ]; then
    print_result "Unique constraints (found $UNIQUE_COUNT, min 5)" true 5
else
    print_result "Unique constraints (found $UNIQUE_COUNT, min 5)" false 5
fi
echo ""

# ============================================
# STEP 4: Verify Seed Data (30 points)
# ============================================
echo "----------------------------------------"
echo "Step 4: Verifying seed data (30 points)..."
echo "----------------------------------------"

# Expected counts (3 pts each)
declare -A EXPECTED_COUNTS
EXPECTED_COUNTS["departments"]=3
EXPECTED_COUNTS["instructors"]=4
EXPECTED_COUNTS["students"]=8
EXPECTED_COUNTS["student_phones"]=12
EXPECTED_COUNTS["courses"]=5
EXPECTED_COUNTS["modules"]=18
EXPECTED_COUNTS["assignments"]=15
EXPECTED_COUNTS["enrollments"]=15
EXPECTED_COUNTS["grades"]=9
EXPECTED_COUNTS["certificates"]=7

for table in "${REQUIRED_TABLES[@]}"; do
    EXPECTED=${EXPECTED_COUNTS[$table]}
    ACTUAL=$(run_sql "SELECT COUNT(*) FROM $DB_SCHEMA.$table;" 2>/dev/null || echo "0")
    ACTUAL=${ACTUAL:-0}
    
    if [ "$ACTUAL" = "$EXPECTED" ]; then
        print_result "$table has $ACTUAL rows (expected $EXPECTED)" true 3
    else
        print_result "$table has $ACTUAL rows (expected $EXPECTED)" false 3
    fi
done
echo ""

# ============================================
# STEP 5: Verify Indexes (30 points)
# ============================================
echo "----------------------------------------"
echo "Step 5: Verifying indexes (30 points)..."
echo "----------------------------------------"

# Count custom indexes (20 pts for 10+ indexes)
INDEX_COUNT=$(run_sql "
SELECT COUNT(DISTINCT indexname) 
FROM pg_indexes 
WHERE schemaname = '$DB_SCHEMA' 
AND indexname NOT LIKE '%_pkey'
AND indexname NOT LIKE '%_key';
")
INDEX_COUNT=${INDEX_COUNT:-0}

if [ "$INDEX_COUNT" -ge 10 ]; then
    print_result "Custom indexes created (found $INDEX_COUNT, min 10)" true 20
else
    print_result "Custom indexes created (found $INDEX_COUNT, min 10)" false 20
fi

# Check for specific important indexes (10 pts)
IMPORTANT_INDEXES=("idx_enrollments_student" "idx_enrollments_course" "idx_modules_course" "idx_assignments_course")
FOUND_IMPORTANT=0
for idx in "${IMPORTANT_INDEXES[@]}"; do
    EXISTS=$(run_sql "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = '$DB_SCHEMA' AND indexname = '$idx';")
    if [ "$EXISTS" = "1" ]; then
        FOUND_IMPORTANT=$((FOUND_IMPORTANT + 1))
    fi
done

if [ "$FOUND_IMPORTANT" -ge 4 ]; then
    print_result "Key indexes present ($FOUND_IMPORTANT/4 found)" true 10
else
    print_result "Key indexes present ($FOUND_IMPORTANT/4 found)" false 10
fi
echo ""

# ============================================
# FINAL SCORE
# ============================================
echo "========================================"
echo "           FINAL SCORE"
echo "========================================"
echo ""
echo -e "Total Points: ${GREEN}$TOTAL_POINTS${NC} / $MAX_POINTS"
echo ""

# Grade calculation
if [ $TOTAL_POINTS -ge 90 ]; then
    echo -e "Grade: ${GREEN}A${NC}"
elif [ $TOTAL_POINTS -ge 80 ]; then
    echo -e "Grade: ${GREEN}B${NC}"
elif [ $TOTAL_POINTS -ge 70 ]; then
    echo -e "Grade: ${YELLOW}C${NC}"
elif [ $TOTAL_POINTS -ge 60 ]; then
    echo -e "Grade: ${YELLOW}D${NC}"
else
    echo -e "Grade: ${RED}F${NC}"
fi

echo ""
echo "========================================"
