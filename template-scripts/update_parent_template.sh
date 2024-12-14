#!/bin/bash

################################################################################################
################################ Update parent template ########################################
################################################################################################

# Script that will update the parent template.
# The script should be run from within the root of the child project.
# The Gradle files will be updated, but the custom-x blocks will remain.

git submodule update --remote

# Update the gradle files

PARENT_DIR=".submodules/software-template-parent"
CHILD_DIR="_submodules/software-template-parent"

# Function to extract custom content from a file
extract_custom_content() {
    awk '/\/\/ #### custom-code-start ####/,/\/\/ #### custom-code-stop ####/' "$1"
    awk '/\/\/ #### custom-project-metadata-start ####/,/\/\/ #### custom-project-metadata-stop ####/' "$1"
}

# Process all .gradle.kts files in the child directory
find "$CHILD_DIR" -type f -name "*.gradle.kts" | while read -r CHILD_FILE; do
    # Determine the corresponding parent file
    RELATIVE_PATH="${CHILD_FILE#$CHILD_DIR/}"
    PARENT_FILE="$PARENT_DIR/$RELATIVE_PATH"

    # Check if the parent file exists
    if [ -f "$PARENT_FILE" ]; then
        # Extract custom content from the child file
        CUSTOM_CONTENT=$(extract_custom_content "$CHILD_FILE")

        # Update the parent file with the custom content
        awk -v custom_content="$CUSTOM_CONTENT" \
            'BEGIN { in_custom = 0 } \
            { \
                if ($0 ~ /\/\/ #### custom-code-start ####/) in_custom = 1; \
                if (!in_custom) print; \
                if ($0 ~ /\/\/ #### custom-code-stop ####/) { in_custom = 0; print custom_content; } \
            }' "$PARENT_FILE" > "${PARENT_FILE}.tmp"

        # Replace the parent file with the updated content
        mv "${PARENT_FILE}.tmp" "$PARENT_FILE"
    fi

done