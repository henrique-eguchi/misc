#!/bin/bash

# Check if a version number is provided as an argument
if [ $# -lt 2 ]; then
  echo "Usage: $0 <version> <changelog_path>"
  exit 1
fi

# Store the provided version number and changelog path
version="$1"
changelog_path="$2"

# Read the changelog file and extract the text from the specified version
changelog_text=$(sed -n "/## \[$version\]/,/^## \[/ { /## \[/! p; }" "$changelog_path")

# Remove the ### markdown from the extracted text
changelog_text=$(echo "$changelog_text" | sed 's/^### //')

# Print the extracted text
echo "$changelog_text"