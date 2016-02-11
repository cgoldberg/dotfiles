set -e

echo "\nrunning master backup job:"
echo "----------------------------------------------------------------"
echo "\ndeleting Dropbox cache..."
rm -rf ~/Dropbox/.dropbox.cache/*
echo "----------------------------------------------------------------"
echo "\nsyncing local Dropbox to Bytez NAS..."
rsync -a --delete --human-readable --info=progress2 --safe-links ~/Dropbox/ /mnt/bytez/Dropbox/
echo "----------------------------------------------------------------"
echo "\nsyncing Bytez NAS to local WD-Green HDD..."
rsync -a --delete --human-readable --progress --info=progress2 --safe-links /mnt/bytez/ /mnt/wd-green/
echo "----------------------------------------------------------------"
echo "\nflushing local file system buffers..."
sync
echo "----------------------------------------------------------------\n"
df -hT /mnt/wd-green
echo "----------------------------------------------------------------\n"
df -hT /mnt/bytez
echo "----------------------------------------------------------------\n"
echo "done"
