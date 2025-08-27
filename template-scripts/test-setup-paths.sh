#!/bin/bash

echo "=== Testing Setup Script Paths ==="
echo

echo "1. Checking for .submodules directory (git submodule location):"
if [ -d ".submodules" ]; then
    echo "✓ .submodules directory exists"
    if [ -f ".submodules/software-template-parent/build.gradle.kts" ]; then
        echo "✓ build.gradle.kts found in git submodule"
    else
        echo "✗ build.gradle.kts NOT found in git submodule"
    fi
else
    echo "✗ .submodules directory does not exist"
fi

echo

echo "2. Checking for _submodules directory (working directory):"
if [ -d "_submodules" ]; then
    echo "✓ _submodules directory exists"
    if [ -f "_submodules/software-template-parent/build.gradle.kts" ]; then
        echo "✓ build.gradle.kts found in working directory"
    else
        echo "✗ build.gradle.kts NOT found in working directory"
    fi
else
    echo "✗ _submodules directory does not exist"
fi

echo

echo "3. Directory contents comparison:"
echo "Contents of .submodules/software-template-parent/:"
ls -la .submodules/software-template-parent/ 2>/dev/null | head -10 || echo "Directory not accessible"

echo
echo "Contents of _submodules/software-template-parent/:"  
ls -la _submodules/software-template-parent/ 2>/dev/null | head -10 || echo "Directory not accessible"

echo
echo "=== Test Complete ==="