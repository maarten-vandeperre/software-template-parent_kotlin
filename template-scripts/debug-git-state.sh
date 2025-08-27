#!/bin/bash

################################################################################################
################################### Git State Debug Script ###################################
################################################################################################

echo "=== Git Repository Debug Information ==="
echo

echo "1. Checking .gitmodules file:"
if [ -f ".gitmodules" ]; then
    echo "✓ .gitmodules exists:"
    cat .gitmodules
else
    echo "✗ .gitmodules does not exist"
fi
echo

echo "2. Git config submodule entries:"
git config --file .git/config --get-regexp submodule || echo "✓ No submodule config found"
echo

echo "3. .git/modules directory:"
if [ -d ".git/modules" ]; then
    echo "✗ .git/modules exists:"
    ls -la .git/modules
else
    echo "✓ No .git/modules directory"
fi
echo

echo "4. Git index submodule entries (160000 mode):"
git ls-files --stage | grep '^160000' || echo "✓ No submodule entries in index"
echo

echo "5. Current git status:"
git status --short
echo

echo "5a. Git diff --cached (staged changes):"
git diff --cached --name-status || echo "✓ No staged changes"
echo

echo "6. Submodule directories:"
ls -la | grep -E "(_submodules|\.submodules)" || echo "✓ No submodule directories found"
echo

echo "7. Testing git submodule command:"
if git submodule status > /dev/null 2>&1; then
    echo "✓ Git submodule command works"
    git submodule status
else
    echo "✗ Git submodule command fails:"
    git submodule status 2>&1
fi
echo

echo "=== End Debug Information ==="