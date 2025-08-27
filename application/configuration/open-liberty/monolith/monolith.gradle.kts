plugins {
    java
    id("war")
    id("io.openliberty.tools.gradle.Liberty") version "3.8.2"
}

dependencies {
    implementation(platform(project(":platform:openliberty-platform")))

    implementation(project(":application:core:maarten-domain"))
    implementation(project(":application:core:maarten-core-utils"))
    implementation(project(":application:core:maarten-usecases"))
    implementation(project(":application:data-providers:in-memory-db:maarten-driver"))
    implementation(project(":application:apis:maarten-jakarta-apis")) {
        exclude(group = "io.quarkus")
        exclude(group = "io.smallrye")
    }

    providedCompile("jakarta.platform:jakarta.jakartaee-api:10.0.0")
    providedCompile("org.eclipse.microprofile:microprofile:7.0")
// #### custom-dependencies-start ####


// #### custom-dependencies-end ####
}

allOpen {
    annotation("jakarta.ws.rs.Path")
    annotation("jakarta.ws.rs.ApplicationPath")
    annotation("jakarta.enterprise.context.ApplicationScoped")
    annotation("jakarta.enterprise.context.RequestScoped")
}

//clean.dependsOn 'libertyStop'
