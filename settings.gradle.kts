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

include(":platform:quarkus-platform")
include(":platform:spring-platform")
include(":platform:openliberty-platform")

include(":parent-application:core:maarten-domain")
include(":parent-application:core:maarten-core-utils")
include(":parent-application:core:maarten-usecases")

include(":parent-application:data-providers:in-memory-db:maarten-driver")

include(":parent-application:apis:maarten-jakarta-apis")

include(":parent-application:configuration:quarkus:maarten-monolith")
include(":parent-application:configuration:open-liberty:monolith")


// #### custom-code-start ####

rootProject.name="software-template-parent_kotlin" // custom code: will be changed by the child and should remain

// #### custom-code-end ####






rootProject.children
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .flatMap { child -> if (child.children.isEmpty()) listOf(child) else child.children }
    .forEach { subproject ->
        println("configure: " + subproject.name + ".gradle.kts")
        subproject.buildFileName = subproject.name + ".gradle.kts"
    }
