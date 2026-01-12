#!/usr/bin/env bash
#
# update Transmission with GTK 4 client from latest tag in source (Debian 13/Trixie)

set -e


export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

cd ~/code/transmission/build
git checkout main
git fetch --tags
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
cmake --build . -t clean
git submodule foreach --recursive git clean -xfd
git pull --rebase --prune
git submodule update --init --recursive --depth=1
cmake --build .
sudo cmake --install .
git checkout main
