#!/bin/bash
# =============================================================================
# PawCare Veterinary Clinic - Assignment 06 Verification Script
# =============================================================================
# This script verifies student SQL Subquery, CTE & Views solutions
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
DB_NAME="${DB_NAME:-pawcare}"
DB_USER="${DB_USER:-pawcare}"
SQL_DIR="./sql"
SOLUTIONS_DIR="./solutions"
OUTPUT_DIR="./output"

# Score tracking
TOTAL_POINTS=0
MAX_POINTS=100

# Points per exercise
POINTS_EX1=20
POINTS_EX2=20
POINTS_EX3=20
POINTS_EX4=20
POINTS_EX5=20

echo "========================================"
echo "  PawCare Clinic Assignment 6 - Verification"
echo "========================================"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to run SQL and capture result
run_sql() {
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -t -c "$1" 2>&1
}

# Function to run SQL file
run_sql_file() {
    local sql_file="$1"
    local output_file="$2"
    docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$sql_file" > "$output_file" 2>&1
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

# Compare outputs (ignoring whitespace differences)
compare_outputs() {
    local student_output="$1"
    local solution_output="$2"
    
    # Normalize whitespace and compare
    diff -wB <(cat "$student_output" | sed 's/[[:space:]]*$//' | grep -v '^$') \
             <(cat "$solution_output" | sed 's/[[:space:]]*$//' | grep -v '^$') > /dev/null 2>&1
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

FILES_MISSING=0
for file in exercise01 exercise02 exercise03 exercise04 exercise05; do
    if [ -f "$SQL_DIR/$file.sql" ]; then
        echo -e "${GREEN}PASS:${NC} Found: $file.sql"
    else
        echo -e "${YELLOW}⚠${NC} Missing: $file.sql"
        FILES_MISSING=$((FILES_MISSING + 1))
    fi
done
echo ""

if [ $FILES_MISSING -eq 5 ]; then
    echo -e "${RED}ERROR: No exercise files found in $SQL_DIR${NC}"
    echo "Create your solution files and try again."
    exit 1
fi

# ============================================
# STEP 3: Verifying exercises
# ============================================
echo "----------------------------------------"
echo "Step 3: Verifying exercises..."
echo "----------------------------------------"

# Exercise 1: Subqueries
exercise_file="$SQL_DIR/exercise01.sql"
solution_file="$SOLUTIONS_DIR/exercise01.sql"
if [ -f "$exercise_file" ]; then
    student_output="$OUTPUT_DIR/student_ex1.txt"
    solution_output="$OUTPUT_DIR/solution_ex1.txt"
    
    if run_sql_file "$exercise_file" "$student_output" 2>/dev/null; then
        run_sql_file "$solution_file" "$solution_output" 2>/dev/null
        if compare_outputs "$student_output" "$solution_output"; then
            print_result "Exercise 1: Subqueries" true $POINTS_EX1
        else
            print_result "Exercise 1: Subqueries" false $POINTS_EX1
        fi
    else
        echo -e "${RED}FAIL${NC}: Exercise 1 - SQL syntax error (0/$POINTS_EX1 pts)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Exercise 1 - File not found (0/$POINTS_EX1 pts)"
fi

# Exercise 2: Correlated Subqueries
exercise_file="$SQL_DIR/exercise02.sql"
solution_file="$SOLUTIONS_DIR/exercise02.sql"
if [ -f "$exercise_file" ]; then
    student_output="$OUTPUT_DIR/student_ex2.txt"
    solution_output="$OUTPUT_DIR/solution_ex2.txt"
    
    if run_sql_file "$exercise_file" "$student_output" 2>/dev/null; then
        run_sql_file "$solution_file" "$solution_output" 2>/dev/null
        if compare_outputs "$student_output" "$solution_output"; then
            print_result "Exercise 2: Correlated Subqueries" true $POINTS_EX2
        else
            print_result "Exercise 2: Correlated Subqueries" false $POINTS_EX2
        fi
    else
        echo -e "${RED}FAIL${NC}: Exercise 2 - SQL syntax error (0/$POINTS_EX2 pts)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Exercise 2 - File not found (0/$POINTS_EX2 pts)"
fi

# Exercise 3: Set Operations
exercise_file="$SQL_DIR/exercise03.sql"
solution_file="$SOLUTIONS_DIR/exercise03.sql"
if [ -f "$exercise_file" ]; then
    student_output="$OUTPUT_DIR/student_ex3.txt"
    solution_output="$OUTPUT_DIR/solution_ex3.txt"
    
    if run_sql_file "$exercise_file" "$student_output" 2>/dev/null; then
        run_sql_file "$solution_file" "$solution_output" 2>/dev/null
        if compare_outputs "$student_output" "$solution_output"; then
            print_result "Exercise 3: Set Operations" true $POINTS_EX3
        else
            print_result "Exercise 3: Set Operations" false $POINTS_EX3
        fi
    else
        echo -e "${RED}FAIL${NC}: Exercise 3 - SQL syntax error (0/$POINTS_EX3 pts)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Exercise 3 - File not found (0/$POINTS_EX3 pts)"
fi

# Exercise 4: Common Table Expressions
exercise_file="$SQL_DIR/exercise04.sql"
solution_file="$SOLUTIONS_DIR/exercise04.sql"
if [ -f "$exercise_file" ]; then
    student_output="$OUTPUT_DIR/student_ex4.txt"
    solution_output="$OUTPUT_DIR/solution_ex4.txt"
    
    if run_sql_file "$exercise_file" "$student_output" 2>/dev/null; then
        run_sql_file "$solution_file" "$solution_output" 2>/dev/null
        if compare_outputs "$student_output" "$solution_output"; then
            print_result "Exercise 4: Common Table Expressions" true $POINTS_EX4
        else
            print_result "Exercise 4: Common Table Expressions" false $POINTS_EX4
        fi
    else
        echo -e "${RED}FAIL${NC}: Exercise 4 - SQL syntax error (0/$POINTS_EX4 pts)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Exercise 4 - File not found (0/$POINTS_EX4 pts)"
fi

# Exercise 5: Views
exercise_file="$SQL_DIR/exercise05.sql"
solution_file="$SOLUTIONS_DIR/exercise05.sql"
if [ -f "$exercise_file" ]; then
    student_output="$OUTPUT_DIR/student_ex5.txt"
    solution_output="$OUTPUT_DIR/solution_ex5.txt"
    
    if run_sql_file "$exercise_file" "$student_output" 2>/dev/null; then
        run_sql_file "$solution_file" "$solution_output" 2>/dev/null
        if compare_outputs "$student_output" "$solution_output"; then
            print_result "Exercise 5: Views" true $POINTS_EX5
        else
            print_result "Exercise 5: Views" false $POINTS_EX5
        fi
    else
        echo -e "${RED}FAIL${NC}: Exercise 5 - SQL syntax error (0/$POINTS_EX5 pts)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Exercise 5 - File not found (0/$POINTS_EX5 pts)"
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

# Cleanup output directory
rm -rf "$OUTPUT_DIR"
