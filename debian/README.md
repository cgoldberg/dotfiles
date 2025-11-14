# Debian Tweaks

----

### Install packages

```
sudo apt install \
    audacious btop build-essential fonts-ubuntu fonts-ubuntu-console \
    gnome-terminal gvfs-backends htop libfuse2 nemo python-is-python3

```

### Install dependencies for building Python from source with all optional modules

```
sudo apt build-dep python3
sudo apt install \
    build-essential python3-dev python-dev-is-python3 gdb lcov pkg-config \
    libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
    libncurses-dev libreadline-dev libsqlite3-dev libssl-dev lzma tk-dev \
    uuid-dev zlib1g-dev libzstd-dev inetutils-inetd
```

----

### Remove packages

```
sudo apt remove --purge avahi*
sudo apt remove --purge cups*
```

----

### Set DNS

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

### Remap CAPS-LOCK to CTRL

```
sudo apt install keyboard-configuration console-setup
```

set `XKBOPTIONS="ctrl:nocaps"` in `/etc/default/keyboard`


```
sudo dpkg-reconfigure keyboard-configuration
sudo systemctl restart keyboard-setup.service
sudo setupcon
sudo update-initramfs -u
```

----

### Build ImageMagick from source

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


