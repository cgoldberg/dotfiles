#!/bin/sh

set -e

echo "\ndeleting Dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo "\nsyncing local Dropbox to Bytez NAS..."
rsync -a --delete --human-readable --progress --info=progress2 --safe-links ~/Dropbox/ /mnt/bytez/Dropbox/
echo "\nsyncing Bytez NAS to local WD-Green HDD..."
rsync -a --delete --human-readable --progress --info=progress2 --safe-links /mnt/bytez/ /mnt/wd-green/
echo "\nflushing local file system buffers..."
sync
echo "\neverything synced!\n"
df -hT /mnt/wd-green
echo
df -hT /mnt/bytez
echo "\ndone"
