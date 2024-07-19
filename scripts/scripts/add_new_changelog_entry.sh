#!/bin/bash

# Usage: ./add_new_changelog_entry.sh <changelog_path> "<entry_text>" "<new_version>"
# Example: ./add_new_changelog_entry.sh CHANGELOG.md "### Added..." "2.3.0"
changelog_path="$1"
entry_text="$2"
new_version="$3"

# Check if the changelog file, entry text, and new version are provided
if [ -z "$changelog_path" ] || [ -z "$entry_text" ] || [ -z "$new_version" ]; then
  echo "Usage: ./add_new_changelog_entry.sh <changelog_path> \"<entry_text>\" \"<new_version>\""
  exit 1
fi

# Check if the changelog file exists
if [ ! -f "$changelog_path" ]; then
  echo "Changelog file not found."
  exit 1
fi

# Generate a timestamp
current_date=$(date +'%Y-%m-%d')

# Normalize newlines in the entry text
entry_text=$(printf '%s' "$entry_text" | tr -s '\n')
entry_text=$(printf '%s' "$entry_text" | awk '{ printf "%s\\n", $0 }')

# Create the new changelog entry
new_entry="## [$new_version] - $current_date\n\n$entry_text"

# Use awk to insert the new entry above the first occurrence of the last version
awk -v new_entry="$new_entry" '
  /^## \[[0-9]+\.[0-9]+\.[0-9]+\] - [0-9]+\-[0-9]+\-[0-9]+$/ && !inserted {
    print new_entry
    inserted = 1
  }
  { print }
' "$changelog_path" > "$changelog_path.tmp"

# Overwrite the original file with the modified content
mv "$changelog_path.tmp" "$changelog_path"

echo "Text added successfully."