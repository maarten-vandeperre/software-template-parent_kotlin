# OpenLiberty Monolith

This OpenLiberty configuration serves the Jakarta APIs from the `maarten-jakarta-apis` project.

## Local Development

### Prerequisites
- Java 17 or higher
- Gradle

### Starting the Server

To start the OpenLiberty server locally, run the following command from the project root:

```bash
./gradlew :application:configuration:open-liberty:monolith:libertyStart
```

This will:
- Build the WAR file
- Start the OpenLiberty server
- Deploy the application

For development mode with hot reload (note: may have issues with current setup), you can try:
```bash
./gradlew :application:configuration:open-liberty:monolith:libertyDev
```

### Accessing the Application

Once started, the application will be available at:
- **Base URL**: http://localhost:8080/monolith/
- **API Endpoint**: http://localhost:8080/monolith/api/hello

### Available Endpoints

- `GET /api/hello` - Returns a greeting message from the `maarten-jakarta-apis` GreetingResource

### Development Mode Features

The `libertyDev` task runs the server in development mode with:
- Automatic reload when source files change
- Hot deployment of changes
- Console output and logging

### Stopping the Server

To stop the server, press `Ctrl+C` in the terminal where it's running, or run:

```bash
./gradlew :application:configuration:open-liberty:monolith:libertyStop
```

### Building for Production

To build the WAR file for production deployment:

```bash
./gradlew :application:configuration:open-liberty:monolith:war
```

The WAR file will be created in `build/libs/monolith.war`.