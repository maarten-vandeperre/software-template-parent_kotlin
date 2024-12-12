#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as: bash <(curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)

#clean folder
rm -rf ./* || true
rm -rf ./.* || true

mkdir .temp-scripts
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/init-new-project.sh > .temp-scripts/init-new-project.sh
curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/setup-project.sh  > .temp-scripts/setup-project.sh

sh .temp-scripts/init-new-project.sh
sh .temp-scripts/setup-project.sh

rm -rf .temp-scripts