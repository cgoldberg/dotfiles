#!/bin/sh

set -e

echo
echo "deleting Dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo
echo "syncing local Dropbox to Bytez NAS..."
rsync -a --delete --human-readable --safe-links ~/Dropbox/ /mnt/bytez/Dropbox/
echo
echo "syncing Bytez NAS to local WD-Green HDD..."
echo
rsync -a --delete --human-readable --progress --info=progress2 --safe-links /mnt/bytez/ /mnt/wd-green/
echo
echo "flushing local file system buffers..."
sync
echo
echo "everything synced!"
echo
df -hT /mnt/wd-green
echo
df -hT /mnt/bytez
echo
echo "done"
