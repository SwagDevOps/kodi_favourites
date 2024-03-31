## [``kodi_fav_gen``][SwagDevOps/kodi_fav_gen] example implementation

This repository is intended to show off an example for a [``kodi_fav_gen``][SwagDevOps/kodi_fav_gen] implementation.

## Setup

Setup (or update) from stable branches:

```shell
ruby setup
```

Setup (or update) from ``develop`` branches:

```shell
ruby setup update-branch=develop upgrade-branch=develop
```

``update-branch`` is related to current project.\
``upgrade-branch`` relates to [``kodi_fav_gen``][SwagDevOps/kodi_fav_gen].

## Execute

```shell
bin/kodi-favgen generate output='/dev/stdout' files-path='/mnt/storage/files'
```

Where `files-path` is used to define a custom variable used in an ``yml.erb`` favourite file.

<!-- hyperlinks -->

[SwagDevOps/kodi_fav_gen]: https://github.com/SwagDevOps/kodi_fav_gen
