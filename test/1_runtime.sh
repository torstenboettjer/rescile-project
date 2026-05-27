#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Testing python package imports..."

# Run the Python inline command
python3 -c "
import importlib
import sys
from pulumi import automation as auto
import pulumi
print('Imports successful!')
"
