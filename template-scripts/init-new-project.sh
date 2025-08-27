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

# Clean up any stale submodule references if .gitmodules is missing but git has submodule config
if [ ! -f ".gitmodules" ] && git config --file .git/config --get-regexp submodule > /dev/null 2>&1; then
    echo "Detected stale submodule configuration without .gitmodules file. Cleaning up..."
    
    # Remove submodule entries from .git/config
    git config --file .git/config --remove-section submodule.software-template-parent 2>/dev/null || true
    git config --file .git/config --remove-section "submodule._submodules/software-template-parent" 2>/dev/null || true
    
    # Remove submodule directory from .git/modules if it exists
    if [ -d ".git/modules" ]; then
        rm -rf .git/modules/_submodules 2>/dev/null || true
        rm -rf ".git/modules/software-template-parent" 2>/dev/null || true
    fi
    
    # Remove any existing submodule directory
    rm -rf _submodules 2>/dev/null || true
    
    echo "Stale submodule references cleaned up."
fi

## Prompt the user for a directory name
#read -p "Enter the name of the directory (or empty to continue in the current one): " dir_name
#
## Check if the input is empty
#if [[ -z "$dir_name" ]]; then
#  echo "No directory name provided. Continuing in current folder."
#else
#  echo "Create directory: $dir_name"
#  mkdir $dir_name
#
#  script_root="$(pwd)/$dir_name"
#  echo "Set script root to $script_root"
#  cd $script_root
#fi

echo "init submodule: parent template folder"
if git submodule add -b main https://github.com/maarten-vandeperre/software-template-parent_kotlin .submodules/software-template-parent; then
    echo "Submodule added successfully"
    git submodule init
    git submodule update --remote
    git add .
    git commit -m "Configure submodule to track branch main"
    echo "Submodule configuration completed successfully"
else
    echo "Failed to add submodule. This might indicate the repository is in an inconsistent state."
    echo "Please check your Git repository status and try again."
    exit 1
fi