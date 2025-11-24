# Debian Configuration

----

## Add package sources

Remove `/etc/apt/sources.list` if it exists (old format).

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
    audacious btop build-essential gnome-terminal gvfs-backends htop \
    libfuse2 nano nemo python-is-python3

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
sudo apt remove --purge avahi*
sudo apt remove --purge cups*
sudo apt remove --purge bluez
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

## Build ImageMagick from source

install dependencies:

```
sudo apt install libjpeg-dev libpng-dev
```

build and install:

```
git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
./configure
make
sudo make install
sudo ldconfig /usr/local/lib
```

uninstall:

```
sudo make uninstall
```


