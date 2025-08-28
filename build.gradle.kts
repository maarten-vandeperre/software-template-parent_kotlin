plugins {
    kotlin("jvm") version "2.1.0"
    kotlin("plugin.allopen") version "2.1.0"
}

repositories {
    mavenCentral()
    mavenLocal()
}


val givenGroup = "com.redhat.demo"
val givenVersion = "1.0.0-SNAPSHOT"


// #### custom-project-metadata-start ####

// #### custom-project-metadata-end ####


group = givenGroup
version = givenVersion

subprojects.filter { !(it.name == "platform" || it.parent?.name == "platform") }.forEach {
    println("configure ${it.name}")
    it.group = givenGroup
    it.version = givenVersion

    it.repositories {
        mavenCentral()
        mavenLocal()
    }

    it.apply(plugin = "idea")
    it.apply(plugin = "org.jetbrains.kotlin.jvm")
    it.apply(plugin = "org.jetbrains.kotlin.plugin.allopen")

    it.configure<JavaPluginExtension> {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21

        sourceSets.getByName("main") {
            java.srcDir("src/main/kotlin")
        }
        sourceSets.getByName("test") {
            java.srcDir("src/test/kotlin")
        }
    }

    it.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
            javaParameters.set(true)
        }
    }

    it.dependencies {
        implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    }
}

// Configure monolith tasks based on runtime property
// Runtime can be configured in gradle.properties or via command line: -PmonolithRuntime=openliberty
// Valid values: "quarkus", "openliberty"
val monolithRuntime = project.findProperty("monolithRuntime") as String? ?: "quarkus"

when (monolithRuntime.lowercase()) {
    "quarkus" -> {
        tasks.register("startMonolith") {
            group = "application"
            description = "Runs Quarkus in dev mode from the parent-application/configuration/quarkus/maarten-monolith module"
            dependsOn(":parent-application:configuration:quarkus:maarten-monolith:quarkusDev")
            doLast {
                println("Quarkus dev mode started from parent-application/configuration/quarkus/maarten-monolith")
            }
        }

        tasks.register("stopMonolith") {
            group = "application"
            description = "Stops Quarkus dev mode (Ctrl+C required in the dev mode terminal)"
            doLast {
                println("To stop Quarkus dev mode, press Ctrl+C in the terminal where quarkusDev is running")
            }
        }
    }
    "openliberty" -> {
        tasks.register("startMonolith") {
            group = "application"
            description = "Runs Open Liberty from the parent-application/configuration/open-liberty/monolith module"
            dependsOn(":parent-application:configuration:open-liberty:monolith:libertyStart")
            doLast {
                println("Open Liberty started from parent-application/configuration/open-liberty/monolith")
            }
        }

        tasks.register("stopMonolith") {
            group = "application"
            description = "Stops Open Liberty from the parent-application/configuration/open-liberty/monolith module"
            dependsOn(":parent-application:configuration:open-liberty:monolith:libertyStop")
            doLast {
                println("Open Liberty stopped from parent-application/configuration/open-liberty/monolith")
            }
        }
    }
    else -> {
        tasks.register("startMonolith") {
            group = "application"
            description = "Invalid runtime configuration"
            doFirst {
                throw GradleException("Invalid monolithRuntime property: '$monolithRuntime'. Valid values are: 'quarkus', 'openliberty'")
            }
        }

        tasks.register("stopMonolith") {
            group = "application"
            description = "Invalid runtime configuration"
            doFirst {
                throw GradleException("Invalid monolithRuntime property: '$monolithRuntime'. Valid values are: 'quarkus', 'openliberty'")
            }
        }
    }
}



// #### custom-code-start ####

// #### custom-code-end ####