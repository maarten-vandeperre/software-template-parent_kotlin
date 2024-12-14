#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as: bash <(curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)

version="4"
echo "script version: $version"
sleep 10

#clean folder
find . -mindepth 1 -name ".*" ! -name ".git" ! -name "." ! -name ".." -exec rm -rf {} +

mkdir .temp-scripts
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/init-new-project.sh > .temp-scripts/init-new-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/setup-project.sh  > .temp-scripts/setup-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/configure-code-structure.sh  > .temp-scripts/configure-code-structure.sh

echo "Init new project"
sh .temp-scripts/init-new-project.sh

echo "Awaiting the completion of Git submodule downloads (1 minute)..."
sleep 60

echo "Set up project"
sh .temp-scripts/setup-project.sh


echo "Awaiting project setup..."
sleep 10

echo "Configure code structure"
sh .temp-scripts/configure-code-structure.sh

echo "$version" > version.txt

rm -rf .temp-scripts

echo "Done..."
echo "TODO:"
echo "* Go to settings.gradle.kts and change the property 'rootProject.name'"