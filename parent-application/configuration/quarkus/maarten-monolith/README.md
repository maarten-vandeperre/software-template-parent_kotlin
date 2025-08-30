# Quarkus Monolith

This Quarkus configuration serves the Jakarta APIs from the `maarten-jakarta-apis` project.

## Local Development

### Prerequisites
- Java 17 or higher
- Gradle

### Starting the Server

To start the Quarkus server in development mode, run the following command from the project root:

```bash
./gradlew :parent-application:configuration:quarkus:maarten-monolith:quarkusDev
```

This will:
- Build the application
- Start the Quarkus server in development mode
- Enable live coding and hot reload

### Accessing the Application

Once started, the application will be available at:
- **Base URL**: http://localhost:8080/maarten-monolith/api/
- **API Endpoint**: http://localhost:8080/maarten-monolith/api/hello

### Available Endpoints

- `GET /api/hello` - Returns a greeting message from the `maarten-jakarta-apis` GreetingResource

### Development Mode Features

The `quarkusDev` task runs the server in development mode with:
- Live coding - automatic reload when source files change
- Hot deployment of changes
- Debug mode on port 5005
- Interactive console with options to:
  - Press `[e]` to edit command line args
  - Press `[r]` to resume testing
  - Press `[o]` to toggle test output
  - Press `[h]` for more options

### Stopping the Server

To stop the server, press `Ctrl+C` in the terminal where it's running.

### Building for Production

To build the application as a regular JAR:

```bash
./gradlew :parent-application:configuration:quarkus:maarten-monolith:build
```

To build the application as an uber-jar (fat JAR with all dependencies):

```bash
./gradlew :parent-application:configuration:quarkus:maarten-monolith:build -Dquarkus.package.jar.type=uber-jar  
```

The JAR file will be created in `build/libs/`.

### Running the Built Application

After building, you can run the application with:

```bash
java -jar build/libs/maarten-monolith-1.0.0-SNAPSHOT-runner.jar
```

For uber-jar:

```bash
java -jar build/libs/maarten-monolith-1.0.0-SNAPSHOT.jar
```