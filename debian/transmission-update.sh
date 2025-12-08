#!/usr/bin/env bash
#
# update Transmission with GTK 4 client from source (Debian 13/Trixie)

set -e


export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

cd ~/code/transmission/build
cmake --build . -t clean
git submodule foreach --recursive git clean -xfd
git pull --rebase --prune
git submodule update --init --recursive --depth=1
cmake --build .
sudo cmake --install .
