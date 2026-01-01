#!/usr/bin/env bash

# this script should be called by the ci/cd pipeline only

# fail on any error
set -e

# get the dir name of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# verify if the file repo_name.png is there
if [ ! -f "$SCRIPT_DIR/repo_name.png" ]; then
  echo "repo_name.png not found!"
  exit 1
fi

# verify if the file actions_enabled.png is there
if [ ! -f "$SCRIPT_DIR/actions_enabled.png" ]; then
  echo "actions_enabled.png not found!"
  exit 1
fi

# verify if the file collaborators.png is there
if [ ! -f "$SCRIPT_DIR/collaborators.png" ]; then
  echo "collaborators.png not found!"
  exit 1
fi

# verify if the file ai_disabled.png is there
if [ ! -f "$SCRIPT_DIR/ai_disabled.png" ]; then
  echo "ai_disabled.png not found!"
  exit 1
fi

# verify if the file adminer_connection.png is there
if [ ! -f "$SCRIPT_DIR/adminer_connection.png" ]; then
  echo "adminer_connection.png not found!"
  exit 1
fi

