# Debian Tweaks

----

### Install Packages

```
sudo apt install audacious
sudo apt install build-essential
sudo apt install btop
sudo apt install htop
sudo apt install gvfs-backends
sudo apt install libfuse2 # (needed for AppImages)
sudo apt install python-is-python3
```

### Install dependencies for building Python from source with all optional modules

```
sudo apt build-dep python3
sudo apt install build-essential python3-dev python-dev-is-python3 \
    gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev \
    liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
    lzma lzma-dev tk-dev uuid-dev zlib1g-dev libzstd-dev inetutils-inetd
```

----

### Remove Packages

```
sudo apt remove --purge avahi*
sudo apt remove --purge cups*
```

----

### Remap CAPS-LOCK to CTRL

```
sudo apt install keyboard-configuration
sudo apt install console-setup
sudo vi /etc/default/keyboard
```

update: `XKBOPTIONS="ctrl:nocaps"`

```
sudo dpkg-reconfigure keyboard-configuration
sudo systemctl restart keyboard-setup.service
sudo setupcon
sudo update-initramfs -u
```

----

### Build ImageMagick from source

install deps:

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


