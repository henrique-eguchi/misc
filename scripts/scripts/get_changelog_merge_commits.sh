#!/bin/bash

# Get the last generated tag on the master branch
LAST_TAG=$(git describe --abbrev=0 --tags master)

# Get the commit hashes of the merge commits since the last tag
MERGE_COMMITS=$(git log --merges --grep="Merge pull request #[0-9]\+" --pretty=format:"%H" $LAST_TAG..HEAD)

# Initialize variables for each section
ADDED=""
FIXES=""
CHANGED=""
UNRELEASED=""

# Iterate over each merge commit
for commit in $MERGE_COMMITS; do
    # Extract the pull request title from the merge commit message
    PR_TITLE=$(git log --format=%B -n 1 $commit | awk 'NR==3')

    # Convert pull request title to lowercase for case-insensitive matching
    PR_TITLE_LOWER=$(echo "$PR_TITLE" | awk '{print tolower($0)}')

    # Check for specific keywords and assign to the corresponding section
    if [[ $PR_TITLE_LOWER == *"[feature]"* || $PR_TITLE_LOWER == *"[feat]"* ]]; then
        ADDED+="- $PR_TITLE"$'\n'
    elif [[ $PR_TITLE_LOWER == *"[bugfix]"* || $PR_TITLE_LOWER == *"[fix]"* || $PR_TITLE_LOWER == *"[fixed]"* ]]; then
        FIXES+="- $PR_TITLE"$'\n'
    elif [[ $PR_TITLE_LOWER == *"[refactor]"* || $PR_TITLE_LOWER == *"[perf]"* || $PR_TITLE_LOWER == *"[style]"* ]]; then
        CHANGED+="- $PR_TITLE"$'\n'
    fi
done

# Print the sections if they have any entries
if [[ -n $ADDED ]]; then
    UNRELEASED+="### Added"$'\n'
    UNRELEASED+="$ADDED"
    UNRELEASED+=$'\n'
fi

if [[ -n $CHANGED ]]; then
    UNRELEASED+="### Changed"$'\n'
    UNRELEASED+="$CHANGED"
    UNRELEASED+=$'\n'
fi

if [[ -n $FIXES ]]; then
    UNRELEASED+="### Fixed"$'\n'
    UNRELEASED+="$FIXES"$'\n'
fi

echo "$UNRELEASED"
