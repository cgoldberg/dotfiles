# Debian Tweaks

----

### Install Packages

```
sudo apt install audacious -y
sudo apt install build-essential -y
sudo apt install btop -y
sudo apt install fonts-ubuntu -y
sudo apt install fonts-ubuntu-console -y
sudo apt install gnome-terminal -y
sudo apt install htop -y
sudo apt install gvfs-backends -y
sudo apt install libfuse2 -y # (needed for AppImages)
sudo apt install python-is-python3 -y
sudo apt install python-dev-is-python3 -y
sudo apt install python3-dev -y
```

### Install dependencies for building Python from source with all optional modules

```
sudo apt build-dep python3
sudo apt install build-essential python3-dev python-dev-is-python3 \
    gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev \
    liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev libssl-dev \
    lzma tk-dev uuid-dev zlib1g-dev libzstd-dev inetutils-inetd
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


