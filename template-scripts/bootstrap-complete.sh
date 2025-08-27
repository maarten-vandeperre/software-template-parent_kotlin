#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as: bash <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)

version="1.0.0"
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

# Update settings.gradle.kts with the new root project name
sed -i.bak "s/rootProject.name=\"software-template-parent_kotlin\"/rootProject.name=\"$root_project_name\"/" settings.gradle.kts
rm settings.gradle.kts.bak

# Add custom dependencies to Quarkus maarten-monolith.gradle.kts
echo "Adding dependencies to Quarkus monolith..."
quarkus_gradle_file="application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle.kts"
if [ -f "$quarkus_gradle_file" ]; then
    # Create temporary file with the dependencies
    temp_deps=$(cat << 'EOF'
    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":application:apis:jakartaapis"))
EOF
)
    # Replace the custom-dependencies section
    awk -v deps="$temp_deps" '
    /^\/\/ #### custom-dependencies-start ####$/ { 
        print; 
        print deps; 
        while (getline && !/^\/\/ #### custom-dependencies-end ####$/) {}; 
        print; 
        next 
    } 
    { print }
    ' "$quarkus_gradle_file" > "${quarkus_gradle_file}.tmp" && mv "${quarkus_gradle_file}.tmp" "$quarkus_gradle_file"
fi

# Add custom dependencies to OpenLiberty monolith.gradle.kts
echo "Adding dependencies to OpenLiberty monolith..."
openliberty_gradle_file="application/configuration/open-liberty/monolith/monolith.gradle.kts"
if [ -f "$openliberty_gradle_file" ]; then
    # Create temporary file with the dependencies
    temp_deps=$(cat << 'EOF'
    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":application:apis:jakartaapis"))
EOF
)
    # Replace the custom-dependencies section
    awk -v deps="$temp_deps" '
    /^\/\/ #### custom-dependencies-start ####$/ { 
        print; 
        print deps; 
        while (getline && !/^\/\/ #### custom-dependencies-end ####$/) {}; 
        print; 
        next 
    } 
    { print }
    ' "$openliberty_gradle_file" > "${openliberty_gradle_file}.tmp" && mv "${openliberty_gradle_file}.tmp" "$openliberty_gradle_file"
fi

echo "Done..."
echo "Configuration complete:"
echo "* Root project name set to: $root_project_name"
echo "* Project specific dependencies added to both Quarkus and OpenLiberty monoliths"