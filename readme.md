
## What?

Use the [Interplanetary File System](https://ipfs.io/) to download gentoo source files.

## How?

First, put this repo into /usr/portage/distfiles and fill it with symlinks to /ipfs/Qm...
If you already have a repo under \$DISTDIR, take a backup!

    cd "${DISTDIR:-/usr/portage/distfiles}"
    git init
    git remote add ipfs-distfiles https://github.com/piedar/ipfs-distfiles-gentoo
    git fetch --all
    git reset --hard ipfs-distfiles/master

Next, launch the ipfs daemon to mount /ipfs and serve the symlinks.
(The `fusermount -u` commands will clean up mountpoint in case of failure.)

    ipfs daemon --mount ; fusermount -u /ipfs ; fusermount -u /ipns ;

## Notes

If the /ipfs mount fails, portage will detect it as a checksum failure and overwrite the symlinks.
This is nice as a fallback, but once the ipfs daemon is running again do `git reset --hard ipfs-distfiles/master` to restore the links.

Use the scripts under `./.bin/` to import more files into the repo.

### todo

- [ ] more ebuilds
- [ ] rewrite import script to python or nim
