#!/bin/bash

################################################################################################
################################### Bootstrap script ###########################################
################################################################################################

# Script that will bootstrap (i.e., init, setup and configure a new repository based upon this template).
# It will be an aggregator of individual scripts that have a single purpose.
#
# run it as bash <(curl -s https://github.com/maarten-vandeperre/software-template-parent_kotlin/tree/main/template-scripts/bootstrap-complete.sh)

#clean folder
rm -rf ./* ./.*
run it as bash <(curl -s https://github.com/maarten-vandeperre/software-template-parent_kotlin/tree/main/template-scripts/init-new-project.sh)
run it as bash <(curl -s https://github.com/maarten-vandeperre/software-template-parent_kotlin/tree/main/template-scripts/setup-project.sh)