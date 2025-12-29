#!/usr/bin/env bash

# this script should be called by the ci/cd pipeline only

# fail on any error
set -e

# get the dir name of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# copy the file adminer_connection.png to the ../artifacts/01/ folder
cp "$SCRIPT_DIR/../assignment-01/adminer_connection.png" "$SCRIPT_DIR/../reports/01/"