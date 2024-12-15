plugins {
    kotlin("jvm") version "1.9.22"
    kotlin("plugin.allopen") version "1.9.22"
}

repositories {
    mavenCentral()
    mavenLocal()
}


var givenGroup = "com.redhat.demo"
var givenVersion = "1.0.0-SNAPSHOT"


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
        kotlinOptions {
            jvmTarget =  JavaVersion.VERSION_21.toString()
            javaParameters = true
        }
    }

    it.dependencies {
        implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    }
}

tasks.register("runMonolith") {
    group = "application"
    description = "Runs Quarkus in dev mode from the application/configuration/quarkus/maarten-monolith module"

    dependsOn(":application:configuration:quarkus:maarten-monolith:quarkusDev")

    doLast {
        println("Quarkus dev mode started from application/configuration/quarkus/maarten-monolith")
    }
}



// #### custom-code-start ####

// #### custom-code-end ####