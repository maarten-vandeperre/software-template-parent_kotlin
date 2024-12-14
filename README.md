# creating-and-maintaining-software-templates

## Usage
In order to create a project, dependent on this parent template, process the following tasks:
1. Create a new git repository.
2. Check out the repository.
3. Execute the following command:
    ```shell
    bash <(curl -s https://raw.githubusercontent.com/maarten-vandeperre/software-template-parent_kotlin/refs/heads/main/template-scripts/bootstrap-complete.sh)
    ```

## TODO
* add the version of the generator template in the main configuration.
* gradlew, gradle folder, ... should be "ln"-ed from this one, with ability to override
* platform folder should come over from template - and add a property to select runtime
* select custom code blocks - e.g., not needed in parent use cases