#!/usr/bin/env bash
#
# build/install Transmission with GTK 4 client from source (Debian 13/Trixie)

set -e


sudo apt install -y \
    cmake libcurl4-openssl-dev libb64-dev libdeflate-dev libevent-dev \
    libminiupnpc-dev libnatpmp-dev libsystemd-dev gettext libgtkmm-4.0-dev

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

cd ~/code
git clone --recurse-submodules --shallow-submodules --depth=1 \
    https://github.com/transmission/transmission.git
cd transmission
cmake -B build -DCMAKE_BUILD_TYPE=Release
cd build
cmake --build .
sudo cmake --install .
