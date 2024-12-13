#!/bin/bash

################################################################################################
################################ Update parent template ########################################
################################################################################################

# Script that will update the parent template.
# The script should be run from within the root of the child project.
# The Gradle files will be updated, but the custom-x blocks will remain.

git submodule update --remote

# Update the gradle files

NEW_DIR="_submodules/software-template-parent"
TARGET_DIR=".submodules/software-template-parent"

# Check if the new directory exists
if [[ ! -d "$NEW_DIR" ]]; then
  echo "Error: New directory '$NEW_DIR' not found!"
  exit 1
fi

# Check if the target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory '$TARGET_DIR' not found!"
  exit 1
fi

# Process all .gradle.kts files in the target directory and subdirectories
find "$TARGET_DIR" -type f -name "*.gradle.kts" | while read -r OLD_FILE; do
  # Extract the relative path of the old file
  RELATIVE_PATH="${OLD_FILE#$TARGET_DIR/}"

  # Locate the corresponding new file
  NEW_FILE="$NEW_DIR/$RELATIVE_PATH"

  # Check if the corresponding new file exists
  if [[ ! -f "$NEW_FILE" ]]; then
    echo "Warning: New file '$NEW_FILE' not found! Skipping $OLD_FILE."
    continue
  fi

  # Read the content of the new file, excluding the custom code block
  NEW_CONTENT=$(awk '/\/\/ #### custom-code-start ####/{exit} {print}' "$NEW_FILE")

  # Extract the custom code block from the old file
  CUSTOM_CODE=$(awk '/\/\/ #### custom-code-start ####/{flag=1} /\/\/ #### custom-code-end ####/{print; flag=0} flag {print}' "$OLD_FILE")

  # Construct the new file content with the preserved custom code
  {
    echo "$NEW_CONTENT"
    echo "$CUSTOM_CODE"
  } > "$OLD_FILE.tmp"

  # Replace the old file with the new content
  mv "$OLD_FILE.tmp" "$OLD_FILE"

  echo "Updated: $OLD_FILE"
done

echo "All .gradle.kts files have been updated."