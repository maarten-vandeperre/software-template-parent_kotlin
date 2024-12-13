#!/bin/bash

################################################################################################
################################ Update parent template ########################################
################################################################################################

# Script that will update the parent template.
# The script should be run from within the root of the child project.

git submodule update --remote
# TODO