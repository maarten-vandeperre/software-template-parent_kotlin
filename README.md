# creating-and-maintaining-software-templates

**Disclaimer**:  
This project is still WIP, so extra features will be added and no thoroughly testing done yet.

This project covers a parent template for microservices that can be used to manage dependencies and 
common code centrally. It is created for the fictive "maarten" company, which you will see popping up
within the package and module names. Feel free to change it to your company's or organization's name.

## Usage

### Prerequisites
**IMPORTANT:** The bootstrap script requires a Git repository to work properly. Before running the script, you must:
- Either check out an existing Git repository, OR
- Initialize a new Git repository with `git init`

If you try to run the bootstrap script in a folder that is not a Git repository, it will fail.

### Setup Steps
In order to create a project, dependent on this parent template, process the following tasks:
1. Create a new folder for your project (or create a new git repository on GitHub/GitLab).
2. If starting from scratch:
   ```shell
   mkdir my-new-project
   cd my-new-project
   git init
   ```
   OR if you have a remote repository:
   ```shell
   git clone <your-repository-url>
   cd <your-repository-folder>
   ```
3. Execute the bootstrap command:
    ```shell
    bash <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)
    ```
   **Important:**   
  After the script ran (i.e., when you changed the root project name), it can be that you need to do a sync/refresh
  in your IDE. (I had to run a Gradle sync within IntelliJ).
4. You now have a working project in which you can add your specific functionality, linked to a
centrally maintained layer.
   * Whenever an update of the parent template happens, you can just run 
      ```shell
         sh script_update_parent_template.sh
      ```
   * Custom code, directories, ... can be added to the /application folder.
   !!! Be aware that new gradle modules need to be added to the custom-dependencies section of
   _submodules/software-template-parent/parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle

### Working with Runtimes

This project supports both Quarkus and OpenLiberty runtimes. You can switch between them using the `monolithRuntime` property.

**Get Help with Runtime Commands:**
```shell
./gradlew monolithHelp
```
This displays a comprehensive help message showing how to start/stop both Quarkus and OpenLiberty, including URLs and configuration options.

**Start the Application:**
- **Quarkus (default):**
  ```shell
  ./gradlew startMonolith
  ```
  Access at: http://localhost:8080/maarten-monolith/api/dummy

- **OpenLiberty:**
  ```shell
  ./gradlew startMonolith -PmonolithRuntime=openliberty
  ```
  Access at: http://localhost:8080/monolith/api/dummy

**Stop the Application:**
- **Quarkus:** Press Ctrl+C in the terminal where it's running
- **OpenLiberty:**
  ```shell
  ./gradlew stopMonolith -PmonolithRuntime=openliberty
  ```

**Configure Default Runtime:**
You can set the default runtime in `gradle.properties`:
```properties
monolithRuntime=quarkus     # default
# OR
monolithRuntime=openliberty
```

## TODO
* add the version of the generator template in the main configuration.
* platform folder should come over from template - and add a property to select runtime
* allow code changes from _submodules to be copied to .submodules so that it can be committed and pushed
* runtime selection on container creation (for child project)
* check if custom changes to the build.gradle are restored after a parent update script run within the child project
