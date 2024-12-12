#!/bin/bash

################################################################################################
######################################## Init script ###########################################
################################################################################################

# script that will initiate a new repository based upon this template.
# it will configure this project as a git submodule

# Check if the 'git submodule' command works
if ! git submodule > /dev/null 2>&1; then
  echo "Error: 'git submodule' command is not available. Please ensure you have Git installed with submodule support."
  exit 1
fi

echo "'git submodule' command is available."

# Prompt the user for a directory name
read -p "Enter the name of the directory: " dir_name

# Check if the input is empty
if [[ -z "$dir_name" ]]; then
  echo "No directory name provided. Exiting."
  exit 1
fi

echo "Create directory: $dir_name"
mkdir $dir_name

script_root="$(pwd)/$dir_name"
echo "Set script root to $script_root"
cd $script_root

echo "init submodule: parent template folder"
git submodule add -b main https://github.com/maarten-vandeperre/software-template-parent_kotlin .submodules/software-template-parent
git submodule init
git submodule update
git add .gitmodules
git commit -m "Configure submodule to track branch branch_name"