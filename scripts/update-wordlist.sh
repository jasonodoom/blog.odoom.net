#!/usr/bin/env bash

# Script to generate/update aspell personal word list from blog posts
# This extracts all unique words from existing posts to build a custom dictionary

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORDLIST="$REPO_ROOT/.aspell.en.pws"
POST_DIR="$REPO_ROOT/hugo-site/content/post"

echo "Generating word list from existing blog posts..."

# Create temporary file for words
TEMP_WORDS=$(mktemp)

# Extract words from all posts
for file in "$POST_DIR"/*.md; do
  if [ -f "$file" ]; then
    # Skip frontmatter (between +++ markers) and extract content
    awk 'BEGIN {p=0} /^\+\+\+$/ {p++; next} p==2 {print}' "$file" >> "$TEMP_WORDS"
  fi
done

# Process words:
# 1. Convert to lowercase
# 2. Extract only words (letters only)
# 3. Remove single letters
# 4. Sort and deduplicate
WORDS=$(cat "$TEMP_WORDS" | \
  tr '[:upper:]' '[:lower:]' | \
  tr -cs '[:alpha:]' '\n' | \
  grep -v '^.$' | \
  sort -u)

# Count unique words
WORD_COUNT=$(echo "$WORDS" | wc -l | tr -d ' ')

# Create aspell personal word list format
# First line must be: personal_ws-1.1 en WORD_COUNT
echo "personal_ws-1.1 en $WORD_COUNT" > "$WORDLIST"
echo "$WORDS" >> "$WORDLIST"

# Clean up
rm "$TEMP_WORDS"

echo "✓ Generated $WORDLIST with $WORD_COUNT unique words"
