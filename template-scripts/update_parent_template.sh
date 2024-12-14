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
        # Extract custom content from the child file into a temporary file
        TEMP_CONTENT_FILE=$(mktemp)
        extract_custom_content "$CHILD_FILE" > "$TEMP_CONTENT_FILE"

        # Update the parent file with the custom content
        awk -v temp_file="$TEMP_CONTENT_FILE" '
            BEGIN { in_custom = 0 }
            {
                if ($0 ~ /\/\/ #### custom-code-start ####/) {
                    in_custom = 1;
                    print;  # Print the start marker
                    while ((getline line < temp_file) > 0) print line;  # Inject custom content
                    next;
                }
                if ($0 ~ /\/\/ #### custom-code-stop ####/) in_custom = 0;
                if (!in_custom) print;
            }
        ' "$PARENT_FILE" > "${PARENT_FILE}.tmp"

        # Replace the parent file with the updated content
        mv "${PARENT_FILE}.tmp" "$PARENT_FILE"

        # Remove the temporary file
        rm -f "$TEMP_CONTENT_FILE"
    fi
done