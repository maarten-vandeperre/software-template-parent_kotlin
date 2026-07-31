# Gradle to Maven Migration Guide

This project has been successfully migrated from Gradle to Maven. Here's what changed and how to use the new Maven setup.

## What Changed

### Build System
- **Removed**: All Gradle files (`.gradle`, `settings.gradle`, `gradle.properties`, `gradlew`, `gradlew.bat`, `.gradle/` directory)
- **Added**: Maven `pom.xml` files for all modules
- **Updated**: Template scripts to generate Maven project structure instead of Gradle

### Project Structure
The Maven project maintains the same modular structure:
```
├── pom.xml (parent)
├── platform/
│   ├── quarkus-platform/pom.xml
│   ├── spring-platform/pom.xml
│   └── openliberty-platform/pom.xml
├── parent-application/
│   ├── core/
│   │   ├── maarten-domain/pom.xml
│   │   ├── maarten-core-utils/pom.xml
│   │   └── maarten-usecases/pom.xml
│   ├── data-providers/
│   │   └── in-memory-db/maarten-driver/pom.xml
│   ├── apis/
│   │   └── maarten-jakarta-apis/pom.xml
│   └── configuration/
│       ├── quarkus/maarten-monolith/pom.xml
│       └── open-liberty/monolith/pom.xml
└── template-scripts/ (updated for Maven)
```

### Runtime Support
- **Quarkus**: Full Maven support with `quarkus-maven-plugin`
- **OpenLiberty**: Maven support with `liberty-maven-plugin`
- **Spring Boot**: Maven support with `spring-boot-maven-plugin`

## Building the Project

### Option 1: Use the Build Script (Recommended)
```bash
./mvn-build.sh
```
This script builds modules in the correct dependency order to avoid reactor build issues.

### Option 2: Manual Maven Commands
```bash
# Build specific module groups in order:
mvn clean compile -pl platform/quarkus-platform,platform/spring-platform,platform/openliberty-platform -DskipTests
mvn clean install -pl parent-application/core/maarten-domain,parent-application/core/maarten-core-utils,parent-application/core/maarten-usecases -DskipTests
mvn clean install -pl parent-application/data-providers/in-memory-db/maarten-driver -DskipTests
mvn clean install -pl parent-application/apis/maarten-jakarta-apis -DskipTests
mvn clean compile -pl parent-application/configuration/quarkus/maarten-monolith,parent-application/configuration/open-liberty/monolith -DskipTests
```

## Running Applications

### Quarkus Development Mode
```bash
mvn quarkus:dev -pl parent-application/configuration/quarkus/maarten-monolith
```

### OpenLiberty Development Mode
```bash
mvn liberty:dev -pl parent-application/configuration/open-liberty/monolith
```

## Template Script Changes

The template scripts have been updated to generate Maven projects:

### setup-project.sh
- Now links to `pom.xml` instead of Gradle files
- Updates Maven `relativePath` references for submodule structure

### configure-code-structure.sh
- Generates `pom.xml` files for new modules
- Creates child project `pom.xml` with module references
- Updates parent `pom.xml` with new module declarations

### bootstrap-complete.sh
- Updates root project name in `pom.xml` instead of `settings.gradle`
- Adds Maven dependencies to Quarkus monolith `pom.xml`

## Dependencies and Versions

### Current Versions
- **Kotlin**: 2.1.0
- **Quarkus**: 3.15.1
- **Spring Boot**: 3.4.0
- **OpenLiberty**: 24.0.0.8
- **Java Target**: 21

### Dependency Management
All dependency versions are managed in the parent `pom.xml` using Maven BOMs:
- Kotlin BOM
- Quarkus BOM  
- Spring Boot Dependencies BOM

## Migration Benefits

1. **Industry Standard**: Maven is widely used and supported
2. **IDE Integration**: Better IDE support across different tools
3. **Ecosystem**: Larger ecosystem of Maven plugins and tools
4. **Dependency Management**: Robust dependency resolution and management
5. **Enterprise**: Better suited for enterprise environments

## Troubleshooting

### Reactor Build Issues
If you encounter dependency resolution issues, use the build script (`./mvn-build.sh`) which builds modules in the correct order.

### Module Dependencies
Make sure all inter-module dependencies are properly declared in each module's `pom.xml` file.

### Quarkus Plugin Issues
The Quarkus plugin requires all dependencies to be compiled and available. Always build dependency modules first before building the Quarkus monolith.

## Migration Checklist

- [x] Convert all Gradle build files to Maven pom.xml files
- [x] Remove Gradle-specific files and directories
- [x] Update template scripts for Maven project generation
- [x] Test compilation of all modules
- [x] Test Quarkus development mode
- [x] Create build script for proper dependency order
- [x] Document migration process