#!/usr/bin/env bash

# master backup job:
# - rsyncs local dropbox to remote NAS
# - rsyncs remote NAS to secondary local HDD mirror
# - report disk space of all mounted file systems

set -e

if [ ! -d "/mnt/bytez/" ]; then
    echo "error: can't find mount point for remote NAS (bytez)"
    exit 1
fi

if [ ! -d "/mnt/wd-green/" ]; then
    echo "error: can't find mount point for secondary local HDD mirror (wd-green)"
    exit 1
fi

SEP="----------------------------------------"
echo "starting master backup job:"
echo $SEP
echo "deleting local dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo $SEP
echo "syncing local dropbox to remote NAS..."
rsync -a --delete --human-readable --info=progress2 --safe-links ~/Dropbox/ /mnt/bytez/Dropbox/
echo $SEP
echo "syncing remote NAS to local backup..."
rsync -a --delete --human-readable --progress --info=progress2 --safe-links /mnt/bytez/ /mnt/wd-green/
echo $SEP
echo "flushing local file system buffers..."
sync
echo $SEP
df -hT
echo $SEP
echo "done"
