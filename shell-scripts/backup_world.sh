#!/bin/sh

set -e

echo "\ndeleting Dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo "\nsyncing local Dropbox to Bytez NAS..."
rsync -a --delete --human-readable --safe-links ~/Dropbox/ /mnt/bytez/Dropbox/
echo
echo "syncing Bytez NAS to local WD-Green HDD..."
echo
rsync -a --delete --human-readable --progress --safe-links /mnt/bytez/ /mnt/wd-green/
echo "flushing local file system buffers..."
sync
echo
echo "Everything synced!"
echo
df -hT /mnt/wd-green
echo
df -hT /mnt/bytez
echo
echo "Done"
