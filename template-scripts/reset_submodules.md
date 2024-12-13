```shell
    git submodule deinit -f .
    git submodule update --init
```
The first command completely "unbinds" all submodules, the second then makes a fresh checkout of them.
It takes longer than the other methods, but will work whatever the state of your submodules.

If your sub-modules have their own sub-modules, instead of second command, try:

git submodule update --init --recursive --checkout
Where --recursive is obvious, but --checkout prevents "Skipping submodule ..."