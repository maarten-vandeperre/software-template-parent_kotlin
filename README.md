# creating-and-maintaining-software-templates

**Disclaimer**:  
This project is still WIP, so extra features will be added and no thoroughly testing done yet.

This project covers a parent template for microservices that can be used to manage dependencies and 
common code centrally. It is created for the fictive "maarten" company, which you will see popping up
within the package and module names. Feel free to change it to your company's or organization's name.

## Usage
In order to create a project, dependent on this parent template, process the following tasks:
1. Create a new git repository.
2. Check out the newly created repository (and 'cd' into it).
3. Execute the following command:
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
   _submodules/software-template-parent/parent-application/configuration/quarkus/maarten-monolith/maarten-monolith.gradle.kts
   * A gradle task is added to start the quarkusDev task on the monolith module without mentioning the module structure (i.e., startMonolith)
       ```shell
       ./gradlew startMonolith
       ```

## TODO
* add the version of the generator template in the main configuration.
* platform folder should come over from template - and add a property to select runtime
* allow code changes from _submodules to be copied to .submodules so that it can be committed and pushed
* runtime selection on ./gradlew startMonolith command and container creation (for child project)
* check if custom changes to the build.gradle.kts are restored after a parent update script run within the child project
