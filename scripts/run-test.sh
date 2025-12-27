#!/usr/bin/env bash

# fail on any error
set -e

# get the dir name of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# get the parameter as the assignment folder name
ASSIGNMENT_FOLDER="$1"
if [ -z "$ASSIGNMENT_FOLDER" ]; then
  echo "Usage: $0 <assignment-folder-name>"
  exit 1
fi

# navigate to the assignment folder
cd "$SCRIPT_DIR/$ASSIGNMENT_FOLDER"

# run the assignment script
./test-assignment.sh