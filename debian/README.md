# Debian Tweaks

----

### Install packages

```
sudo apt install \
    audacious btop build-essential fonts-ubuntu fonts-ubuntu-console \
    gnome-terminal gvfs-backends htop libfuse2 nemo python-dev-is-python3 \
    python-is-python3 python3-dev

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

### Remap CAPS-LOCK to CTRL

```
sudo apt install keyboard-configuration console-setup
```

```
sudo vi /etc/default/keyboard # (update: `XKBOPTIONS="ctrl:nocaps"`)
```

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


