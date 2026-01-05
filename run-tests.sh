#!/usr/bin/env bash

# Run verification script for any assignment
# Usage: ./run-tests.sh <assignment-folder-name>
# Example: ./run-tests.sh assignment-01

# fail on any error
set -e

# get the dir name of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# get the parameter as the assignment folder name
ASSIGNMENT_FOLDER="$1"
if [ -z "$ASSIGNMENT_FOLDER" ]; then
  echo "Usage: $0 <assignment-folder-name>"
  echo "Example: $0 assignment-01"
  exit 1
fi

# navigate to the assignment folder
cd "$SCRIPT_DIR/$ASSIGNMENT_FOLDER"

# run the verification script
bash ./verify.sh