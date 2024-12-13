#!/bin/bash

################################################################################################
##################################### Set up project ###########################################
################################################################################################

# Script that will configure the project structure of the child project.
# The script should be run from within the root of the child project (i.e., the folder created by the init-new-project script).

echo "Copy submodules data"
mkdir ./_submodules
cp -R ./.submodules/software-template-parent ./_submodules/software-template-parent

echo "Prepare metadata files"
cp -R ./_submodules/software-template-parent/.gitignore ./gitignore
cp -R ./_submodules/software-template-parent/gradle ./gradle
cp -R ./_submodules/software-template-parent/platform ./platform
cp ./_submodules/software-template-parent/build.gradle.kts ./build.gradle.kts
cp ./_submodules/software-template-parent/gradle.properties ./gradle.properties
cp ./_submodules/software-template-parent/gradlew ./gradlew
cp ./_submodules/software-template-parent/gradlew.bat ./gradlew.bat
cp ./_submodules/software-template-parent/settings.gradle.kts ./settings.gradle.kts

sleep 10

echo "Remove content that's copied (too much)"

rm -rf  _submodules/software-template-parent/.git
rm -rf  _submodules/software-template-parent/gradle
rm -rf  _submodules/software-template-parent/gradle.properties
rm -rf  _submodules/software-template-parent/build.gradle.kts
rm -rf  _submodules/software-template-parent/gradlew
rm -rf  _submodules/software-template-parent/gradlew.bat
rm -rf  _submodules/software-template-parent/settings.gradle.kts

echo "Prepare Gradle settings"
gradle_settings_file=./settings.gradle.kts
# Check if the file exists
if [[ ! -f "$gradle_settings_file" ]]; then
  echo "Error: File '$gradle_settings_file' not found!"
  exit 1
fi

# Replace every ":application" with "_submodules/template"
sed -i '' 's/:application/:_submodules:software-template-parent:application/g' "$gradle_settings_file"

echo "Replacements done in '$gradle_settings_file'."

directory=_submodules/software-template-parent
# Check if the directory exists
if [[ ! -d "$directory" ]]; then
  echo "Error: Directory '$directory' not found!"
  exit 1
else
  # Process each .gradle.kts file in the directory
  for file in "$directory"/*.gradle.kts; do
    # Check if the file exists to avoid issues with wildcard expansion
    if [[ -f "$file" ]]; then
      # Replace ":application" with ":_submodules:software-template-parent:application"
      sed -i '' 's/:application/:_submodules:software-template-parent:application/g' "$file"
      echo "Processed: $file"
    fi
  done

  echo "All .gradle.kts files in '$directory' have been updated."
fi

git add .