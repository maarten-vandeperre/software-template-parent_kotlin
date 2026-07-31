#!/bin/bash

# Script to build Maven project with correct dependency order

echo "Building Maven project with dependency order..."

# Build platforms first
echo "Building platforms..."
mvn clean compile -pl platform/quarkus-platform,platform/spring-platform,platform/openliberty-platform -DskipTests -q

# Build and install core modules (required for Quarkus dev mode)
echo "Building and installing core modules..."
mvn clean install -pl parent-application/core/maarten-domain,parent-application/core/maarten-core-utils,parent-application/core/maarten-usecases -DskipTests -q

# Build and install data providers
echo "Building and installing data providers..."
mvn clean install -pl parent-application/data-providers/in-memory-db/maarten-driver -DskipTests -q

# Build and install APIs
echo "Building and installing APIs..."
mvn clean install -pl parent-application/apis/maarten-jakarta-apis -DskipTests -q

# Build configuration modules
echo "Building configuration modules..."
mvn clean compile -pl parent-application/configuration/quarkus/maarten-monolith -DskipTests -q
mvn clean compile -pl parent-application/configuration/open-liberty/monolith -DskipTests -q

echo ""
echo "✅ Maven build completed successfully!"
echo ""
echo "🚀 To start Quarkus development mode:"
echo "   mvn quarkus:dev -pl parent-application/configuration/quarkus/maarten-monolith"
echo ""
echo "🚀 To start OpenLiberty development mode:"
echo "   mvn liberty:dev -pl parent-application/configuration/open-liberty/monolith"
echo "   (OpenLiberty will run on http://localhost:9080)"
echo ""
echo "📋 Other available commands:"
echo "   mvn compile                    - Compile all modules"
echo "   mvn clean install -DskipTests  - Full build and install to local repository"