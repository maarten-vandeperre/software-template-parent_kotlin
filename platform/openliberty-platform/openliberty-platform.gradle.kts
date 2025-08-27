plugins {
  `java-platform`
}

javaPlatform {
  allowDependencies()
}

dependencies {
  api("jakarta.platform:jakarta.jakartaee-api:10.0.0")
  api("org.eclipse.microprofile:microprofile:7.0")
}