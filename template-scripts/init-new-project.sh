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

# Clean up any stale submodule references if .gitmodules is missing
if [ ! -f ".gitmodules" ]; then
    echo "No .gitmodules file found. Performing comprehensive submodule cleanup..."
    
    # Remove all submodule entries from .git/config
    git config --file .git/config --get-regexp submodule 2>/dev/null | while read key value; do
        section=$(echo "$key" | cut -d'.' -f1-2)
        echo "Removing config section: $section"
        git config --file .git/config --remove-section "$section" 2>/dev/null || true
    done
    
    # Clean up .git/modules directory completely
    if [ -d ".git/modules" ]; then
        echo "Removing .git/modules directory"
        rm -rf .git/modules
    fi
    
    # Remove any existing submodule directories
    rm -rf _submodules 2>/dev/null || true
    rm -rf .submodules 2>/dev/null || true
    
    # Remove .gitmodules from index if it exists there
    if git ls-files --cached | grep -q "^\.gitmodules$"; then
        echo "Removing .gitmodules from git index"
        git rm --cached .gitmodules 2>/dev/null || true
    fi
    
    # Clean up any submodule entries from the git index
    git ls-files --stage | grep '^160000' | while read mode hash stage path; do
        echo "Removing submodule from index: $path"
        git rm --cached "$path" 2>/dev/null || true
    done
    
    # Commit any index changes before reset
    if ! git diff --cached --quiet 2>/dev/null; then
        git commit -m "Clean up stale submodule references" 2>/dev/null || echo "Nothing staged to commit"
    fi
    
    # Reset the git index to ensure clean state
    git reset --hard HEAD 2>/dev/null || echo "No HEAD to reset to (empty repository)"
    
    echo "Comprehensive submodule cleanup completed."
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

# Double-check that no .gitmodules exists
if [ -f ".gitmodules" ]; then
    echo "Found existing .gitmodules, removing it to start fresh"
    rm .gitmodules
fi

# Handle any .gitmodules deletion or other changes
echo "Checking for any uncommitted changes..."
if [ -n "$(git status --porcelain)" ]; then
    echo "Found uncommitted changes:"
    git status --short
    
    # Check if .gitmodules is deleted
    if git status --porcelain | grep -E "^.D .gitmodules$"; then
        echo "Detected .gitmodules deletion, staging it..."
    fi
    
    echo "Staging and committing all changes..."
    git add -A
    git commit -m "Clean repository state before adding submodules"
else
    echo "No uncommitted changes found."
fi

# Debug: Show current git status after cleanup
echo "Current git status after cleanup:"
git status --short

# Ensure we have a completely clean working tree
if [ -n "$(git status --porcelain)" ]; then
    echo "ERROR: Working tree is not clean. Cannot proceed with submodule addition."
    echo "Uncommitted changes:"
    git status --short
    exit 1
fi

echo "Attempting to add submodule..."
if git submodule add -b main https://github.com/maarten-vandeperre/software-template-parent_kotlin .submodules/software-template-parent; then
    echo "Submodule added successfully"
    git submodule init
    git submodule update --remote
    git add .
    git commit -m "Configure submodule to track branch main"
    echo "Submodule configuration completed successfully"
else
    echo "Failed to add submodule. Debugging information:"
    echo "Git config submodule entries:"
    git config --file .git/config --get-regexp submodule || echo "No submodule config found"
    echo "Files in .git/modules:"
    ls -la .git/modules 2>/dev/null || echo "No .git/modules directory"
    echo "Current .gitmodules content:"
    cat .gitmodules 2>/dev/null || echo "No .gitmodules file"
    echo "Git index submodule entries:"
    git ls-files --stage | grep '^160000' || echo "No submodule entries in index"
    exit 1
fi