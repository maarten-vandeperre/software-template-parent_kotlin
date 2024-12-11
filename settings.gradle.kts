pluginManagement {
    val quarkusPluginVersion: String by settings
    val quarkusPluginId: String by settings
    val springBootPluginVersion: String by settings
    val springBootPluginId: String by settings
    repositories {
        mavenCentral()
        gradlePluginPortal()
        mavenLocal()
    }
    plugins {
        id(quarkusPluginId) version quarkusPluginVersion
        id(springBootPluginId) version springBootPluginVersion
    }
}
rootProject.name="software-template-parent_kotlin"

include(":platform:quarkus-platform")
include(":platform:spring-platform")

include(":application:core:maarten-domain")
include(":application:core:maarten-core-utils")
include(":application:core:domain")
include(":application:core:usecases")

include(":application:data-providers:in-memory-db:maarten-driver")
include(":application:data-providers:in-memory-db:mapping")

include(":application:apis:jakarta-apis")

include(":application:configuration:quarkus:configuration")

rootProject.children
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .forEach { subproject ->
        println("configure: " + subproject.name + ".gradle.kts")
        subproject.buildFileName = subproject.name + ".gradle.kts"
    }



// #### custom-code-start ####


// #### custom-code-end ####