#!/bin/bash

# Check if a version number is provided as an argument
if [ $# -lt 2 ]; then
  echo "Usage: $0 <version> <changelog_path>"
  exit 1
fi

# Store the provided version number and changelog path
version="$1"
changelog_path="$2"

# Get the current date
current_date=$(date "+%Y-%m-%d")

# Remove empty subsections (and their titles)
awk '/^$/ {if (i) {b=b $0 "\n"} else {print $0}; next} \
/^###/ {i=1; b=$0; next} {if (i) {print b}; i=0; print $0; next}' "$changelog_path" > "$changelog_path.temp"
mv "$changelog_path.temp" "$changelog_path"

# Replace the "Unreleased" section title with the provided version and current date
sed -i.bak -e "s/## \[Unreleased\]/## \[$version\] - $current_date/" "$changelog_path"

# Add an empty "Unreleased" section above the newly created version
sed -i.bak -e "s/## \[$version\] - $current_date/## [Unreleased]\n\n### Added\n\n### Changed\n\n### Removed\n\n### Fixed\n\n### Deprecated\n\n### Security\n\n\n## [$version] - $current_date/" "$changelog_path"

# Remove the backup file
rm "$changelog_path.bak"