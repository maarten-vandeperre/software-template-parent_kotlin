#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as: bash <(curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)

#clean folder
find . -mindepth 1 -name ".*" ! -name ".git" ! -name "." ! -name ".." -exec rm -rf {} + > /dev/null

mkdir .temp-scripts
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/init-new-project.sh > .temp-scripts/init-new-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/setup-project.sh  > .temp-scripts/setup-project.sh

echo "Awaiting the completion of Git submodule downloads..."
sleep 60

sh .temp-scripts/init-new-project.sh
sh .temp-scripts/setup-project.sh

echo "1" > version.txt

#rm -rf .temp-scripts