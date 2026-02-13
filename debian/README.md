# Debian Configuration

----

## Add package sources

- remove `/etc/apt/sources.list` if it exists (old format)
- update or add `/etc/apt/sources.list.d/debian.sources`:

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

## Update kernel to backports version

```
sudo apt install -t trixie-backports linux-image-amd64 linux-headers-amd64
```

----

## Install packages

```
sudo apt install \
    audacious build-essential cifs-utils curl git gvfs-backends htop \
    libfuse2 nano nemo python-is-python3 smplayer

```

----

## Remove packages

```
sudo apt remove --purge \
    cups* apache* libreoffice* blueman bluez bolt modemmanager
```

(this removes cellular data, print services, bluetooth support, thunderbolt support, etc)

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

## Install/Configure Gnome Shell extensions

- install: `sudo apt install gnome-shell-extensions`
- add system extensions:
  - Native Window Placement
- add user-installed extensions:
  - Astra Monitor
  - Dash to Panel
  - Quick Shutdown

----

## Set systemd log limits and retention

- set in `/etc/systemd/journald.conf`:

```
[Journal]
# Storage
Storage=persistent
Compress=yes
Seal=yes
SplitMode=uid

# Persistent disk usage
SystemMaxUse=2G
SystemKeepFree=5G
SystemMaxFileSize=200M
SystemMaxFiles=20

# Runtime (RAM) logs
RuntimeMaxUse=300M
RuntimeKeepFree=300M
RuntimeMaxFileSize=100M
RuntimeMaxFiles=10

# Durability
SyncIntervalSec=1m

# Rate limiting
RateLimitIntervalSec=30s
RateLimitBurst=2000

# Forwarding
ForwardToSyslog=yes
ForwardToKMsg=no
ForwardToConsole=no
ForwardToWall=no

# Log levels
MaxLevelStore=debug
MaxLevelSyslog=debug
MaxLevelKMsg=notice
MaxLevelConsole=info
MaxLevelWall=emerg
```

- wipe old logs:

```
sudo systemctl stop systemd-journald
sudo rm -rf /var/log/journal/*
sudo rm -rf /run/log/journal/*
sudo systemctl start systemd-journald
```

----

## Disable autosuspend for all USB devices

- set kernel command-line parameter:
  - edit `/etc/default/grub`
  - find `GRUB_CMDLINE_LINUX_DEFAULT`, and add `usbcore.autosuspend=-1`
    - i.e. `GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1"`
  - `sudo update-grub`
- after reboot, check status with:

```
cat /proc/cmdline | grep usbcore
cat /sys/module/usbcore/parameters/autosuspend
```

----

## Disable Energy Efficient Ethernet so network doesn't go to sleep

- install: `sudo apt install ethtool`
- find the active ethernet interface:
  - `ip -br link`
- assuming `eno1` is the interface, check status:
  - `sudo /usr/sbin/ethtool --show-eee eno1 | grep 'EEE status'`
- if it is "active", create a systemd unit to disable it:

```
sudo tee /etc/systemd/system/disable-eee@.service <<'EOF'
[Unit]
Description=Disable EEE on %i
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool --set-eee %i eee off

[Install]
WantedBy=multi-user.target
EOF
```

- enable it for the interface: `sudo systemctl enable disable-eee@eno1`
- after reboot, check status: `sudo /usr/sbin/ethtool --show-eee eno1 | grep 'EEE status'`
- it should be "disabled"

----

## Configure custom DNS

- install: `sudo apt install systemd-resolved`
- set in `/etc/systemd/resolved.conf`:

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

- verify with: `resolvectl status`

----

## Set mount options for main disk

- set mount options in `/etc/fstab` to:

```
defaults,relatime,errors=remount-ro
```

----

## Mount NAS at boot

- create mount points:

```
sudo mkdir -p /mnt/bitz
sudo chmod 755 /mnt/bitz
sudo mkdir -p /mnt/bytez
sudo chmod 755 /mnt/bytez
```

- create `/root/.smbcredentials`:

```
username=cgoldberg
password=secret
```

- secure it:

```
sudo chmod 600 /root/.smbcredentials
```

- set in `/etc/fstab`:

```
//10.0.0.5/public /mnt/bitz cifs credentials=/root/.smbcredentials,relatime,nofail,serverino,nosharesock,_netdev,cache=strict,actimeo=60,rsize=1048576,wsize=1048576,gid=1000,uid=1000,file_mode=0664,dir_mode=0775,iocharset=utf8  0  0
//10.0.0.6/public /mnt/bytez cifs credentials=/root/.smbcredentials,relatime,nofail,serverino,nosharesock,_netdev,cache=strict,actimeo=60,rsize=1048576,wsize=1048576,gid=1000,uid=1000,file_mode=0664,dir_mode=0775,iocharset=utf8  0  0
```

----


## Un-enshittify Chromium browser

- apply settings from https://github.com/corbindavenport/just-the-browser

```
sudo mkdir -p /etc/chromium/policies/managed
sudo touch /etc/chromium/policies/managed/managed_policies.json
```

- add to `managed_policies.json`:

```
{
  "AIModeSettings": 1,
  "CreateThemesSettings": 2,
  "GeminiSettings": 1,
  "GenAILocalFoundationalModelSettings": 1,
  "HelpMeWriteSettings": 2,
  "HistorySearchSettings": 2,
  "TabCompareSettings": 2,
  "BuiltInDnsClientEnabled": false,
  "DefaultBrowserSettingEnabled": false,
  "DevToolsGenAiSettings": 2
}
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
