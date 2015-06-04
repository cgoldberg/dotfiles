#!/bin/sh

set -e

echo
echo "Clearing Dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo
echo "Syncing. Copying Dropbox to Bytez NAS..."
echo
rsync -a --delete --human-readable --progress --safe-links --verbose ~/Dropbox/ /mnt/bytez/Dropbox/
echo
echo "Syncing: Copying Bytez NAS to Local wd-green HDD..."
echo
rsync -a --delete --human-readable --progress --safe-links --verbose /mnt/bytez/ /mnt/wd-green/
echo
echo
sync
echo "Everything synced!"
echo
df -hT /mnt/wd-green
echo
df -hT /mnt/bytez
echo
echo
echo "Copied Dropbox to Bytez NAS."
echo "Copied Bytez NAS to Local wd-green HDD."
echo
echo "Done."
