#!/usr/bin/env bash

# this script should be called by the ci/cd pipeline only

# fail on any error
set -e

# get the dir name of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# verify if the file adminer_connection.png is there
if [ ! -f "$SCRIPT_DIR/adminer_connection.png" ]; then
  echo "adminer_connection.png not found!"
  exit 1
fi