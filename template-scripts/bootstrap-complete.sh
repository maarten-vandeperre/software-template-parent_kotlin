#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as: bash <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)

version="1.0.1"
echo "script version: $version"
sleep 10

#clean folder (preserve important hidden files)
find . -mindepth 1 -name ".*" ! -name ".git" ! -name ".gitignore" ! -name ".gitmodules" ! -name ".github" ! -name "." ! -name ".." -exec rm -rf {} +

mkdir .temp-scripts
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/init-new-project.sh > .temp-scripts/init-new-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/setup-project.sh  > .temp-scripts/setup-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/configure-code-structure.sh  > .temp-scripts/configure-code-structure.sh

echo "Init new project"
if sh .temp-scripts/init-new-project.sh; then
    echo "Project initialization completed successfully"
else
    echo "Warning: Project initialization had issues, but continuing..."
fi

# Check if .gitmodules exists before waiting for submodules
if [ -f ".gitmodules" ]; then
    echo "Awaiting the completion of Git submodule downloads (1 minute)..."
    sleep 60
else
    echo "No Git submodules detected, continuing..."
fi

echo "Set up project"
if sh .temp-scripts/setup-project.sh; then
    echo "Project setup completed successfully"
else
    echo "Warning: Project setup had issues, but continuing..."
fi

echo "Awaiting project setup..."
sleep 10

echo "Configure code structure"
if sh .temp-scripts/configure-code-structure.sh; then
    echo "Code structure configuration completed successfully"
else
    echo "Warning: Code structure configuration had issues, but continuing..."
fi

echo "$version" > version.txt
git add version.txt

rm -rf .temp-scripts

echo "Configure project name and dependencies..."

# Ask for root project name
echo -n "Enter the root project name (current: software-template-parent_kotlin): "
read root_project_name

# Use default if no input provided
if [ -z "$root_project_name" ]; then
    root_project_name="software-template-parent_kotlin"
fi

echo "Setting root project name to: $root_project_name"

# Update settings.gradle with the new root project name
if [ -f "_submodules/software-template-parent/settings.gradle" ]; then
    sed -i.bak "s/rootProject.name=\"software-template-parent_kotlin\"/rootProject.name=\"$root_project_name\"/" _submodules/software-template-parent/settings.gradle
    rm _submodules/software-template-parent/settings.gradle.bak
    echo "Updated root project name in _submodules/software-template-parent/settings.gradle"
elif [ -f "settings.gradle" ]; then
    sed -i.bak "s/rootProject.name=\"software-template-parent_kotlin\"/rootProject.name=\"$root_project_name\"/" settings.gradle
    rm settings.gradle.bak
    echo "Updated root project name in settings.gradle"
else
    echo "Warning: No settings.gradle file found to update"
fi

# Add custom dependencies to Quarkus maarten-monolith.gradle
echo "Adding dependencies to Quarkus monolith..."
quarkus_gradle_file="_submodules/software-template-parent/parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle"
# Fallback to direct path if submodule path doesn't exist
if [ ! -f "$quarkus_gradle_file" ]; then
    quarkus_gradle_file="parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle"
fi

if [ -f "$quarkus_gradle_file" ]; then
    # Create temporary file with the dependencies
    temp_deps=$(cat << 'EOF'
    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":application:apis:jakartaapis"))
EOF
)
    # Replace the custom-dependencies section using a temporary file approach
    temp_deps_file=$(mktemp)
    echo "$temp_deps" > "$temp_deps_file"
    
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
    ' "$quarkus_gradle_file" > "${quarkus_gradle_file}.tmp" && mv "${quarkus_gradle_file}.tmp" "$quarkus_gradle_file"
    
    rm "$temp_deps_file"
    echo "✓ Dependencies added to: $quarkus_gradle_file"
else
    echo "✗ Quarkus gradle file not found at expected locations"
fi

# Add custom dependencies to OpenLiberty monolith.gradle
echo "Adding dependencies to OpenLiberty monolith..."
openliberty_gradle_file="_submodules/software-template-parent/parent-application/configuration/open-liberty/monolith/monolith.gradle"
# Fallback to direct path if submodule path doesn't exist
if [ ! -f "$openliberty_gradle_file" ]; then
    openliberty_gradle_file="parent-application/configuration/open-liberty/monolith/monolith.gradle"
fi

if [ -f "$openliberty_gradle_file" ]; then
    # Create temporary file with the dependencies
    temp_deps=$(cat << 'EOF'
    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":application:apis:jakartaapis"))
EOF
)
    # Replace the custom-dependencies section using a temporary file approach
    temp_deps_file=$(mktemp)
    echo "$temp_deps" > "$temp_deps_file"
    
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
    ' "$openliberty_gradle_file" > "${openliberty_gradle_file}.tmp" && mv "${openliberty_gradle_file}.tmp" "$openliberty_gradle_file"
    
    rm "$temp_deps_file"
    echo "✓ Dependencies added to: $openliberty_gradle_file"
else
    echo "✗ OpenLiberty gradle file not found at expected locations"
fi

echo "Done..."
echo "Configuration complete:"
echo "* Root project name set to: $root_project_name"
echo "* Project specific dependencies added to both Quarkus and OpenLiberty monoliths"
