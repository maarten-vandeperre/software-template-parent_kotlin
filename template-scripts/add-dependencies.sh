#!/bin/bash

################################################################################################
############################# Add Dependencies Script ########################################
################################################################################################

echo "Adding custom dependencies to both Quarkus and OpenLiberty monoliths..."
echo

# Dependencies to add (using a here document for proper multiline handling)
dependencies=$(cat << 'EOF'
    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":application:apis:jakartaapis"))
EOF
)

# Function to add dependencies to a gradle file
add_dependencies() {
    local gradle_file="$1"
    local file_description="$2"
    
    if [ -f "$gradle_file" ]; then
        echo "Processing: $file_description"
        echo "File: $gradle_file"
        
        # Check if custom-dependencies section exists
        if grep -q "// #### custom-dependencies-start ####" "$gradle_file"; then
            # Use a different approach with sed to replace the section
            # First, create a temporary file with the dependencies
            temp_deps_file=$(mktemp)
            echo "$dependencies" > "$temp_deps_file"
            
            # Use awk with a file read approach
            awk '
            /^\/\/ #### custom-dependencies-start ####$/ { 
                print; 
                while ((getline line < "'$temp_deps_file'") > 0) {
                    print line;
                }
                close("'$temp_deps_file'");
                while (getline && !/^\/\/ #### custom-dependencies-end ####$/) {}; 
                print; 
                next 
            } 
            { print }
            ' "$gradle_file" > "${gradle_file}.tmp" && mv "${gradle_file}.tmp" "$gradle_file"
            
            # Clean up temporary file
            rm "$temp_deps_file"
            
            echo "✓ Dependencies added successfully"
        else
            echo "✗ Custom dependencies section not found (missing markers)"
        fi
    else
        echo "✗ File not found: $gradle_file"
    fi
    echo
}

# Add dependencies to Quarkus monolith
echo "=== Quarkus Monolith ==="
quarkus_gradle_file="_submodules/software-template-parent/parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle.kts"
if [ ! -f "$quarkus_gradle_file" ]; then
    quarkus_gradle_file="parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle.kts"
fi
add_dependencies "$quarkus_gradle_file" "Quarkus Monolith"

# Add dependencies to OpenLiberty monolith
echo "=== OpenLiberty Monolith ==="
openliberty_gradle_file="_submodules/software-template-parent/parent-application/configuration/open-liberty/monolith/monolith.gradle.kts"
if [ ! -f "$openliberty_gradle_file" ]; then
    openliberty_gradle_file="parent-application/configuration/open-liberty/monolith/monolith.gradle.kts"
fi
add_dependencies "$openliberty_gradle_file" "OpenLiberty Monolith"

echo "=== Summary ==="
echo "Dependencies that were added:"
echo "$dependencies"
echo
echo "The dependencies are added between the markers:"
echo "// #### custom-dependencies-start ####"
echo "// #### custom-dependencies-end ####"