#!/bin/bash

################################################################################################
##################################### Set up project ###########################################
################################################################################################

# Script that will configure the project structure of the child project.
# The script should be run from within the root of the child project.

echo "Copy submodules data"
mkdir ./_submodules
cp -R ./.submodules/software-template-parent ./_submodules/software-template-parent

echo "Prepare metadata files"
# !!! pay attention, some link to the .submodules and some (that need check in afterwards) to _submodules
cp -R ./_submodules/software-template-parent/.gitignore ./.gitignore
cp -R ./_submodules/software-template-parent/settings.gradle ./_submodules/software-template-parent/settings.gradle
cp -R ./_submodules/software-template-parent/build.gradle ./_submodules/software-template-parent/build.gradle
cp -R ./_submodules/software-template-parent/gradle.properties ./_submodules/software-template-parent/gradle.properties
ln -s $(pwd)/.submodules/software-template-parent/gradle $(pwd)/gradle
ln -s $(pwd)/_submodules/software-template-parent/build.gradle $(pwd)/build.gradle
ln -s $(pwd)/_submodules/software-template-parent/gradle.properties $(pwd)/gradle.properties
ln -s $(pwd)/.submodules/software-template-parent/gradlew $(pwd)/gradlew
ln -s $(pwd)/.submodules/software-template-parent/gradlew.bat $(pwd)/gradlew.bat
ln -s $(pwd)/_submodules/software-template-parent/settings.gradle $(pwd)/settings.gradle
ln -s $(pwd)/.submodules/software-template-parent/template-scripts/update_parent_template.sh $(pwd)/script_update_parent_template.sh

echo "Remove content that's copied (too much)"

sleep 2

rm -rf  _submodules/software-template-parent/.git
rm -rf  _submodules/software-template-parent/gradle
rm -rf  _submodules/software-template-parent/gradlew
rm -rf  _submodules/software-template-parent/gradlew.bat

echo "Prepare Gradle settings"
gradle_settings_file=_submodules/software-template-parent/settings.gradle
# Check if the file exists
if [[ ! -f "$gradle_settings_file" ]]; then
  echo "Error: File '$gradle_settings_file' not found!"
  exit 1
fi

directory=_submodules/software-template-parent
# Check if the directory exists
if [[ ! -d "$directory" ]]; then
  echo "Error: Directory '$directory' not found!"
  exit 1
else
  # Process each .gradle file in the directory
  find "$directory" -type f -name "*.gradle" | while read -r file; do
    # Check if the file exists to avoid issues with wildcard expansion
    if [[ -f "$file" ]]; then
      # Replace ":parent-application" with ":_submodules:software-template-parent:parent-application"
      sed -i '' '/:_submodules/!s/:parent-application/:_submodules:software-template-parent:parent-application/g' "$file"
      echo "Processed: $file"
    fi
  done

  echo "All .gradle files in '$directory' have been updated."
fi

git add .