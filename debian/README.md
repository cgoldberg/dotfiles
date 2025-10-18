# Debian Tweaks

----

### Add Packages

```
sudo apt install audacious
sudo apt install build-essential
sudo apt install btop
sudo apt install htop
sudo apt install python-dev
sudo apt install gvfs-backends
sudo apt install libfuse2 (needed for AppImages)
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


