#!/bin/bash

################################################################################################
############################### Quick Submodule Fix Script ###################################
################################################################################################

echo "=== Quick Submodule Fix Script ==="
echo

echo "1. Current git status:"
git status --short
echo

echo "2. Removing .gitmodules if it exists:"
if [ -f ".gitmodules" ]; then
    echo "Removing .gitmodules file"
    rm .gitmodules
else
    echo "No .gitmodules file found"
fi
echo

echo "3. Current git status after removal:"
git status --short
echo

echo "4. Adding and committing all changes:"
if [ -n "$(git status --porcelain)" ]; then
    echo "Staging all changes..."
    git add -A
    echo "Committing..."
    git commit -m "Clean up before submodule addition"
    echo "Commit completed"
else
    echo "No changes to commit"
fi
echo

echo "5. Final git status:"
git status --short
echo

echo "6. Testing git submodule command:"
if git submodule status > /dev/null 2>&1; then
    echo "✓ Git submodule command works now"
else
    echo "✗ Git submodule command still fails:"
    git submodule status 2>&1
fi
echo

echo "7. Attempting to add submodule:"
if git submodule add -b main https://github.com/maarten-vandeperre/software-template-parent_kotlin .submodules/software-template-parent; then
    echo "✓ Submodule added successfully!"
    git submodule init
    git submodule update --remote
    git add .
    git commit -m "Configure submodule to track branch main"
    echo "✓ Submodule configuration completed!"
else
    echo "✗ Failed to add submodule"
    echo "Debug info:"
    echo "Git config:"
    git config --get-regexp submodule || echo "No submodule config"
    echo ".git/modules content:"
    ls -la .git/modules 2>/dev/null || echo "No .git/modules"
    echo "Index submodules:"
    git ls-files --stage | grep '^160000' || echo "No submodules in index"
fi

echo
echo "=== End Quick Fix Script ==="