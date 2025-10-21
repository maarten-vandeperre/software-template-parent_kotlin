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
mkdir application/core/usecases/src
mkdir application/core/usecases/src/main
mkdir application/core/usecases/src/main/kotlin
mkdir application/core/usecases/src/main/resources
mkdir application/core/usecases/src/main/kotlin/com
mkdir application/core/usecases/src/main/kotlin/com/specificcode
mkdir application/core/usecases/src/main/kotlin/com/specificcode/core
mkdir application/core/usecases/src/main/kotlin/com/specificcode/core/usecases
mkdir application/core/usecases/src/test
mkdir application/core/usecases/src/test/kotlin
mkdir application/core/usecases/src/test/resources
mkdir application/core/usecases/src/test/kotlin/com
mkdir application/core/usecases/src/test/kotlin/com/specificcode
mkdir application/core/usecases/src/test/kotlin/com/specificcode/core
mkdir application/core/usecases/src/test/kotlin/com/specificcode/core/usecases
mkdir application/core/domain
mkdir application/core/domain/src
mkdir application/core/domain/src/main
mkdir application/core/domain/src/main/kotlin
mkdir application/core/domain/src/main/resources
mkdir application/core/domain/src/main/kotlin/com
mkdir application/core/domain/src/main/kotlin/com/specificcode
mkdir application/core/domain/src/main/kotlin/com/specificcode/core
mkdir application/core/domain/src/main/kotlin/com/specificcode/core/domain
mkdir application/core/domain/src/test
mkdir application/core/domain/src/test/kotlin
mkdir application/core/domain/src/test/resources
mkdir application/core/domain/src/test/kotlin/com
mkdir application/core/domain/src/test/kotlin/com/specificcode
mkdir application/core/domain/src/test/kotlin/com/specificcode/core
mkdir application/core/domain/src/test/kotlin/com/specificcode/core/domain
mkdir application/apis
mkdir application/apis/jakartaapis
mkdir application/apis/jakartaapis/src
mkdir application/apis/jakartaapis/src/main
mkdir application/apis/jakartaapis/src/main/kotlin
mkdir application/apis/jakartaapis/src/main/resources
mkdir application/apis/jakartaapis/src/main/kotlin/com
mkdir application/apis/jakartaapis/src/main/kotlin/com/specificcode
mkdir application/apis/jakartaapis/src/main/kotlin/com/specificcode/apis
mkdir application/apis/jakartaapis/src/main/kotlin/com/specificcode/apis/jakartaapis
mkdir application/apis/jakartaapis/src/main/resources/META-INF
touch application/apis/jakartaapis/src/main/resources/META-INF/beans.xml
mkdir application/apis/jakartaapis/src/test
mkdir application/apis/jakartaapis/src/test/kotlin
mkdir application/apis/jakartaapis/src/test/resources
mkdir application/apis/jakartaapis/src/test/kotlin/com
mkdir application/apis/jakartaapis/src/test/kotlin/com/specificcode
mkdir application/apis/jakartaapis/src/test/kotlin/com/specificcode/apis
mkdir application/apis/jakartaapis/src/test/kotlin/com/specificcode/apis/jakartaapis

echo "Create domain gradle file"
cat << EOF > application/core/domain/domain.gradle
dependencies {
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-domain"))
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-core-utils"))
}
EOF

echo "Create domain Sample file"
cat << EOF > application/core/domain/src/main/kotlin/com/specificcode/core/domain/Sample.kt
package com.specificcode.core.domain

class Sample
EOF

echo "Create usecases gradle file"
cat << EOF > application/core/usecases/usecases.gradle
dependencies {
    implementation(project(":application:core:domain"))
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-domain"))
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-core-utils"))
}
EOF

echo "Create usecases Sample file"
cat << EOF > application/core/usecases/src/main/kotlin/com/specificcode/core/usecases/Sample.kt
package com.specificcode.core.usecases

class Sample
EOF

echo "Create jakartaapis gradle file"
cat << EOF > application/apis/jakartaapis/jakartaapis.gradle
dependencies {
    implementation(platform(project(":_submodules:software-template-parent:platform:runtime-platform")))

    implementation(project(":application:core:domain"))
    implementation(project(":application:core:usecases"))
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-domain"))
    implementation(project(":_submodules:software-template-parent:parent-application:core:maarten-core-utils"))
    implementation("jakarta.ws.rs:jakarta.ws.rs-api")
}
EOF

echo "Create jakartaapis Sample file"
cat << EOF > application/apis/jakartaapis/src/main/kotlin/com/specificcode/apis/jakartaapis/Sample.kt
package com.specificcode.apis.jakartaapis

import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@Path("/dummy")
class GreetingResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun hello() = "No hello, no fooling around: start API development!"
}
EOF

echo "Update settings.gradle"

GRADLE_SETTINGS_FILE=_submodules/software-template-parent/settings.gradle
# Append the lines before the marker
sed '/\/\/ #### custom-code-end ####/i\
include(":application:core:domain")\
include(":application:core:usecases")\
include(":application:apis:jakartaapis")\
\
' "$GRADLE_SETTINGS_FILE" > "${GRADLE_SETTINGS_FILE}.tmp" && mv "${GRADLE_SETTINGS_FILE}.tmp" "$GRADLE_SETTINGS_FILE"

echo "Add to git"
git add application
git add _submodules/software-template-parent/settings.gradle

echo "end configure code structure"