# Debian Configuration

----

## Add package sources

Remove `/etc/apt/sources.list` if it exists (old format)

Update or add `/etc/apt/sources.list.d/debian.sources`:

```
Types: deb deb-src
URIs: https://deb.debian.org/debian/
Suites: trixie trixie-updates trixie-backports
Components: main non-free-firmware contrib non-free
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp

Types: deb deb-src
URIs: https://deb.debian.org/debian-security/
Suites: trixie-security
Components: main non-free-firmware contrib non-free
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.pgp
```

----

## Install packages

```
sudo apt install \
    audacious build-essential cifs-utils curl git gvfs-backends \
    gnome-terminal htop libfuse2 nano nemo python-is-python3 smplayer

```

----

## Install fonts

```
sudo apt install \
    fonts-hack fonts-inconsolata fonts-noto fonts-ubuntu fonts-ubuntu-console
```

----

## Install dependencies for building Python with all optional modules

```
sudo apt build-dep python3
sudo apt install \
    build-essential python3-dev python-dev-is-python3 gdb lcov pkg-config \
    libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
    libncurses-dev libreadline-dev libsqlite3-dev libssl-dev lzma tk-dev \
    uuid-dev zlib1g-dev libzstd-dev inetutils-inetd
```

----

## Remove packages

```
sudo apt remove --purge \
    cups* apache* libreoffice* bluez modemmanager
```

----

## Configure custom DNS

```
sudo apt install systemd-resolved
```

set in `/etc/systemd/resolved.conf`:

```
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
FallbackDNS=8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
DNSOverTLS=yes
ReadEtcHosts=yes
```

```
sudo systemctl restart systemd-resolved
```

verify with: `resolvectl status`

----

## Set mount options NAS

set mount options for main disk in `/etc/fstab` to:

```
defaults,relatime,errors=remount-ro
```

----

## Mount NAS at boot

create mount points:

```
sudo mkdir -p /mnt/bitz
sudo chmod 755 /mnt/bitz
sudo mkdir -p /mnt/bytez
sudo chmod 755 /mnt/bytez
```

create `/root/.smbcredentials`:

```
username=cgoldberg
password=secret
```

secure it:

```
sudo chmod 600 /root/.smbcredentials
```

set in `/etc/fstab`:

```
//10.0.0.5/public /mnt/bitz cifs credentials=/root/.smbcredentials,relatime,nofail,serverino,nosharesock,_netdev,cache=strict,actimeo=60,rsize=1048576,wsize=1048576,gid=1000,uid=1000,file_mode=0664,dir_mode=0775,iocharset=utf8  0  0
//10.0.0.6/public /mnt/bytez cifs credentials=/root/.smbcredentials,relatime,nofail,serverino,nosharesock,_netdev,cache=strict,actimeo=60,rsize=1048576,wsize=1048576,gid=1000,uid=1000,file_mode=0664,dir_mode=0775,iocharset=utf8  0  0
```

----

## Build Transmission GTK from source

- download latest tarball from: https://transmissionbt.com/download

```
sudo apt install -y \
    build-essential cmake git libcurl4-openssl-dev libb64-dev libdeflate-dev \
    libevent-dev libminiupnpc-dev libnatpmp-dev libsystemd-dev gettext \
    libgtkmm-4.0-dev

tar xf transmission-*.tar.xz
cd transmission-*
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cd build
cmake --build .
sudo cmake --install .
```
