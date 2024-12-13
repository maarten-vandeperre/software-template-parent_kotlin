A ***submodule*** is its own ***repo/work-area***, with its own `.git` directory.

So, first `commit/push` your ***submodule's*** changes:

```sh
    $ cd path/to/submodule
    $ git add <stuff>
    $ git commit -m "comment"
    $ git push
```

Then, update your ***main project*** to track the updated version of the ***submodule***:

```sh
    $ cd /main/project
    $ git add path/to/submodule
    $ git commit -m "updated my submodule"
    $ git push
```

