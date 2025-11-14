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

### Set DNS to Cloudflare

set in `/etc/resolv.conf`:

```
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 2606:4700:4700::1111
nameserver 2606:4700:4700::1001
```

Note: this might get overwritten by NetworkManager and need
      to be set in network connection settings UI

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


