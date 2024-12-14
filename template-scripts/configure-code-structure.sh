#!/bin/bash

################################################################################################
################################# Configure code structure #####################################
################################################################################################

# Script that will configure the code structure of the child project (i.e., folders and package names).
# The script should be run from within the root of the child project.

echo "Start configure code structure"

echo "Make directories"
mkdir application
mkdir application/core
mkdir application/core/usecases
mkdir application/core/usecases/com
mkdir application/core/usecases/com/specificcode
mkdir application/core/usecases/com/specificcode/core
mkdir application/core/usecases/com/specificcode/core/usecases
mkdir application/core/domain
mkdir application/core/domain/com
mkdir application/core/domain/com/specificcode
mkdir application/core/domain/com/specificcode/core
mkdir application/core/domain/com/specificcode/core/domain

echo "Create domain gradle file"
cat << EOF > application/core/domain/domain.gradle.kts
dependencies {
    implementation(project(":application:core:domain"))
    implementation(project(":_submodules:software-template-parent:application:core:maarten-core-utils"))
}
EOF

echo "Create usecases gradle file"
cat << EOF > application/core/usecases/usecases.gradle.kts
dependencies {
    implementation(project(":application:core:domain"))
    implementation(project(":_submodules:software-template-parent:application:core:maarten-domain"))
    implementation(project(":_submodules:software-template-parent:application:core:maarten-core-utils"))
}
EOF

echo "Update settings.gradle"

GRADLE_SETTINGS_FILE=_submodules/software-template-parent/settings.gradle.kts
# Append the lines before the marker
sed '/\/\/ #### custom-code-end ####/i\
include(":application:core:domain")\
include(":application:core:usecases")\
\
' "$GRADLE_SETTINGS_FILE" > "${GRADLE_SETTINGS_FILE}.tmp" && mv "${GRADLE_SETTINGS_FILE}.tmp" "$GRADLE_SETTINGS_FILE"

echo "Add to git"
git add application
git add _submodules/software-template-parent/settings.gradle.kts

echo "end configure code structure"