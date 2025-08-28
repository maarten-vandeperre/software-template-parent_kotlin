plugins {
  `java-platform`
}

//test
javaPlatform {
  allowDependencies()
}
dependencies {
  api(platform("io.quarkus:quarkus-bom:${properties.get("quarkusPlatformVersion")}"))
}




