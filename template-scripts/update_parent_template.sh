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
    local prefix=$1
    local file=$2
    awk "/\/\/ #### ${prefix}-start ####/{flag=1; next} /\/\/ #### ${prefix}-stop ####/{flag=0} flag" "$file"
}

copy_custom_code_to_git_module() {
    local prefix=$1
    echo "Start copying custom blocks with prefix: $prefix"

    # Find and process all .gradle.kts files in the child directory
    find "$CHILD_DIR" -type f -name "*.gradle.kts" | while read -r CHILD_FILE; do
        # Determine the corresponding parent file
        RELATIVE_PATH="${CHILD_FILE#$CHILD_DIR/}"
        PARENT_FILE="$PARENT_DIR/$RELATIVE_PATH"

        # Check if the parent file exists
        if [ -f "$PARENT_FILE" ]; then
            # Extract custom content from the child file into a temporary file
            TEMP_CONTENT_FILE=$(mktemp)
            extract_custom_content "$prefix" "$CHILD_FILE" > "$TEMP_CONTENT_FILE"

            # Update the parent file with the custom content
            awk -v temp_file="$TEMP_CONTENT_FILE" -v prefix="$prefix" '
                BEGIN { in_custom = 0 }
                {
                    if ($0 ~ "\\/\\/ #### " prefix "-start ####") {
                        in_custom = 1;
                        print;  # Print the start marker
                        while ((getline line < temp_file) > 0) print line;  # Inject custom content
                        next;
                    }
                    if ($0 ~ "\\/\\/ #### " prefix "-stop ####") in_custom = 0;
                    if (!in_custom) print;
                }
            ' "$PARENT_FILE" > "${PARENT_FILE}.tmp"

            # Replace the parent file with the updated content
            mv "${PARENT_FILE}.tmp" "$PARENT_FILE"

            # Remove the temporary file
            rm -f "$TEMP_CONTENT_FILE"
        else
            echo "Parent file does not exist for: $CHILD_FILE (skipping)"
        fi
    done

    echo "Finished copying custom blocks with prefix: $prefix"
}

# Main logic to process multiple prefixes
copy_custom_blocks_to_parent() {
    prefixes=("custom-dependencies" "custom-project-metadata" "custom-code")
    for prefix in "${prefixes[@]}"; do
        copy_custom_code_to_git_module "$prefix"
    done
}

delete_child_folder() {
  echo "start delete_child_folder"
  rm -rf _submodules
  echo "end delete_child_folder"
}

copy_git_module_code_to_child() {
  echo "start copy_git_module_code_to_child"
  sh .submodules/software-template-parent/template-scripts/setup-project.sh
  echo "end copy_git_module_code_to_child"
}

reset_git_module() {
  echo "start reset_git_module"
  git submodule deinit -f .
  git submodule update --init
  echo "end reset_git_module"
}


####### script

copy_custom_blocks_to_parent
delete_child_folder
copy_git_module_code_to_child
reset_git_module