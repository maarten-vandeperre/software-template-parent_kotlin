plugins {
    id("war")
    id("io.openliberty.tools.gradle.Liberty") version "3.9.2"
}

dependencies {
    implementation(platform(project(":platform:quarkus-platform")))

    implementation(project(":application:core:maarten-domain"))
    implementation(project(":application:core:maarten-core-utils"))
    implementation(project(":application:core:maarten-usecases"))
    implementation(project(":application:data-providers:in-memory-db:maarten-driver"))
    implementation(project(":application:apis:maarten-jakarta-apis"))

    providedCompile("jakarta.platform:jakarta.jakartaee-api:10.0.0")
    providedCompile("org.eclipse.microprofile:microprofile:7.0")
// #### custom-dependencies-start ####


// #### custom-dependencies-end ####
}

//clean.dependsOn 'libertyStop'
