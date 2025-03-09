#!/bin/bash

# Get the location from first command-line argument or use default
LOCATION=${1:-"./hosts/nixos-mini"}

# Check if the location exists
if [ ! -d "$LOCATION" ]; then
    echo "Error: Directory '$LOCATION' does not exist."
    echo "Usage: $0 [directory_path]"
    exit 1
fi

# Loop through the files in the specified location
for file in "$LOCATION"/*; do
  if [ -f "$file" ]; then
    echo -e "\n=== File: $file ===\n"
    cat "$file"
    echo -e "\n"
  fi
done
