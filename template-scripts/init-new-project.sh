#!/bin/bash

################################################################################################
######################################## Init script ###########################################
################################################################################################

# Script that will initiate a new repository based upon this template.
# It will configure this project as a git submodule.
#
# run it as bash <(curl -s https://example.com/script.sh)

# Check if the 'git submodule' command works
if ! git submodule > /dev/null 2>&1; then
  echo "Error: 'git submodule' command is not available. Please ensure you have Git installed with submodule support."
  exit 1
fi

echo "'git submodule' command is available."

# Prompt the user for a directory name
read -p "Enter the name of the directory (or empty to continue in the current one): " dir_name

# Check if the input is empty
if [[ -z "$dir_name" ]]; then
  echo "No directory name provided. Continuing in current folder."
else
  echo "Create directory: $dir_name"
  mkdir $dir_name

  script_root="$(pwd)/$dir_name"
  echo "Set script root to $script_root"
  cd $script_root
fi

echo "init submodule: parent template folder"
git submodule add -b main https://github.com/maarten-vandeperre/software-template-parent_kotlin .submodules/software-template-parent
git submodule init
git submodule update --remote
git add .submodules
git commit -m "Configure submodule to track branch branch_name"