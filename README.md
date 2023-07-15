## [``kodi_fav_gen``][SwagDevOps/kodi_fav_gen] example implementation

This repository is intended to show off an example for a [``kodi_fav_gen``][SwagDevOps/kodi_fav_gen] implementation.

## Setup 

Setup (or update) from stable branches:

```shell
ruby bin/setup.rb
```

Setup (or update) from ``develop`` branches (with verbose ``git``):

```shell
KODI_FAVGEN__CODE_BRANCH='develop' \
KODI_FAVGEN__FAVS_BRANCH='develop' \
KODI_FAVGEN__VCS_VERBOSE='true' \
ruby bin/setup.rb
```

## Execute

```shell
ruby bin/kodi-favgen output='/dev/stdout' files-path='/mnt/storage/files'
```

Where `files-path` is used to define a custom variable used in an ``yml.erb`` favourite file.

<!-- hyperlinks -->

[SwagDevOps/kodi_fav_gen]: https://github.com/SwagDevOps/kodi_fav_gen 
