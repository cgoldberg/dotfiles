# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# shell aliases and functions (Ubuntu) for cgoldberg
# --------------------------------------------------------

# expand aliases when run with sudo
alias sudo="sudo "

# expand aliases when running watch command
alias watch="watch "

# version control
alias g="git"

# python
alias py="python3"
alias py3="python3"
alias py2="python"

# text editors
alias sublime="subl"
alias edit="subl"
alias ed="subl"
alias e="subl -n ."
alias vi="vim"
alias v="vim"

# text pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"

# directory listings
alias ls="\ls -l --human-readable --almost-all --classify --group-directories-first --no-group --color=auto"
alias l="\ls --almost-all --classify --group-directories-first --color=auto"
alias ll="\ls --almost-all --classify --group-directories-first --color=auto"
alias la="\ls --almost-all --classify --group-directories-first --color=auto"

# colored grep output
alias grep="grep --color=auto"

# open shell configurations for editing
alias ebrc="subl -n ~/.bashrc ~/.bash_aliases"

# list public bash functions and aliases defined in the current shell
alias funcs="compgen -a -A function | grep -v ^_ | sort"

# reload shell configurations
alias re-source="source ~/.bashrc"

# system shutdown
alias sd="sudo poweroff"
alias shutdown="sudo poweroff"

# system reboot
alias rb="sudo reboot"
alias reboot="sudo reboot"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias ex="exit"
alias x="exit"

# upgrade music server
alias squeezeboxserver-upgrade="sudo ~/bin/squeezeboxserver-upgrade"

# ip addresses
alias externalip="curl icanhazip.com"
alias localip="hostname -I"
alias ips="echo -n 'local ip: ' && localip && echo -n 'external ip: ' && externalip"

# show disk space available on all mounted ext4 filesystems
alias df="df --sync --human-readable --total --type=ext4"
alias diskfree="df"

# show disk space used by top 100 files and directories under the current directory
alias du="diskused"

# watch disk space used by largest directories under the current directory
alias dw="diskwatch"

# serve current directory over HTTP on port 8080
alias webserver="python3 -m http.server 8080"
alias webserver-py3="python3 -m http.server 8080"
alias webserver-py2="python -m SimpleHTTPServer 8080"

# count files recursively under current directory
alias countfiles="find . -type f | wc -l"

# show last 50 modified files under current dir
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | grep -v '.git' | sort -n | tail -n 50"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# count installed system packages
alias countpackages="dpkg -l | grep '^ii' | wc -l"

# install packages from distro archive
alias apt-install="sudo apt-get update && sudo apt-get install"

# remove packages and purge their config files
alias apt-remove="sudo apt-get remove --purge"

# show package description
alias apt-show="apt-cache show"

# show package installation status and repository it belongs to
alias apt-policy="apt-cache policy"

# disable line wrapping in terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in terminal (long lines wrapped at terminal width)
alias wrap="tput smam"

# color and side-by-side for diffs (requires colordiff package)
alias diff="colordiff -s"

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep --color=always 'ca fe'"

# change directory to blue mount point
alias hdd="cd /mnt/blue"

# navigate up the directory tree
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."
alias cd.......="cd ../../../../../.."


#----------------------------------------------------------------


# make new directory and change to it
# usage: mkdir <name>
mkdir () {
    mkdir -p "$1" && cd "$1"
}

# search command history by regex (case-insensitive) and show last 200 matches
# usage: h <pattern>
h () {
    history | grep -i --color=always "$1" | tail -n 200
}


# search process info by regex (case-insensitive)
# usage: psgrep <pattern>
psgrep () {
    ps -ef | grep -i --color=always "$1" | grep -v "grep" | sort -n | less
}


# show disk space used by top 100 files and directories under the current directory
diskused () {
    \du --all --human-readable --one-file-system "$PWD" | sort -h | tail -n 100
    echo -e "\nTotal for ${PWD}:"
    tree -a "$PWD" | tail -n 1
}


# watch disk space used by largest directories under the current directory
diskwatch () {
    local command="echo Largest directories under ${PWD}:; du -hx ${PWD} 2>/dev/null | sort -h | tail -n 20; echo; echo Total for ${PWD}:; tree -a ${PWD} | tail -n 1"
    watch --interval=3 $command
}


# rename .jpeg extensions to .jpg and lowercase any .JPG extensions
img-fix-jpg-extensions () {
    rename 's/\.jpe?g$/.jpg/i' *
}


# convert all .png images in the current directory to .jpg format
# save with renamed extensions and delete originals
convert-pngs-to-jpgs () {
    findpngs () { find . -maxdepth 1 -type f -iname "*.png" -prune; }
    if [[ -n $(findpngs) ]]; then
        ( findpngs | parallel convert -quality 95% {} {.}.jpg ) &&
        ( findpngs | parallel rm {} )
    else
        echo 'nothing to convert'
    fi
}


# list dimensions of images in the current directory
img-sizes () {
    shopt -s nullglob nocaseglob
    for f in  *{gif,jpg,png}; do
        if [[ -e "$f" ]]; then
            identify -ping -format "%[width]x%[height] - $f\n" "$f" 2> /dev/null
        fi
    done
    shopt -u nullglob nocaseglob
}


# set permissions in music library so Squeezebox server can scan and play audio files
fix-squeezebox-permissions () {
    local music_dir="/mnt/blue/Tunes/"
    # for directories, set read/write/execute permissions for owner and read/execute permissions for group/others
    find "$music_dir" -type d -exec chmod 755 {} \; -print
    # for audio files, set read/write permissions for owner and read permission for group/others
    find "$music_dir" -type f -iname '*.flac' -o -iname '*.mp3' -exec chmod 644 {} \; -print
}


# search recursively under current directory for text file contents matching regex (case-insensitive)
rgrep () {
    grep -iInr --color=always --exclude-dir='.git' "$1" . | less
}


# search entire filesystem for filenames matching glob pattern (case-insensitive)
# update the mlocate database before searching
locatefiles () {
    updatedb --require-visibility 0 --output ~/.locatedb &&
    locate --existing --ignore-case --database ~/.locatedb "$@"
}


# search recursively under current directory for filenames matching pattern (case-insensitive)
findfiles () {
    find . -type f -iname "*$1*" | grep -i --color=always "$1"
}


# mount NAS (if needed) and change directory to the mount point
nas () {
    local share="public"
    local server="bytez"
    local user="$(id -nu ${UID})"
    local mount_dir="/run/user/${UID}/gvfs/smb-share:server=${server},share=${share},user=${user}"
    if [[ ! -d "$mount_dir" ]]; then
        gvfs-mount "smb://${user}@${server}/${share}"
    fi
    cd "$mount_dir"
}


# package maintenance
apt-up () {
    # reload package index files from sources
    sudo apt-get update &&
    # upgrade installed packages using smart conflict resolution
    sudo apt-get dist-upgrade &&
    # check for broken dependencies
    sudo apt-get check &&
    # fix broken dependencies
    sudo apt-get install --fix-broken &&
    # purge packages that are no longer needed
    sudo apt-get autoremove --purge &&
    # purge orphaned configs from removed packages
    purge-apt-configs &&
    # remove cached packages
    sudo apt-get clean &&
    # reload package index files from sources
    sudo apt-get update &&
    # display package count
    echo "$(countpackages) packages currently installed"
}


# purge configuration data from packages marked as removed
purge-apt-configs () {
    if dpkg -l | grep --quiet '^rc'; then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
        sudo apt-get update
    else
        echo "no package configs to remove"
    fi
}


# purge all Dropbox files from local cache
purge-dropbox-cache () {
    if ! dropbox running; then
        dropbox stop && sleep 2
    fi
    cache_dir="~/Dropbox/.dropbox.cache/"
    if [[ -d "$cache_dir" ]]; then
        \du -ah "$cache_dir"
        echo "purging local Dropbox cache..."
        rm -rf "$cache_dir"
    fi
    dropbox start
}


# show all 256 terminal colors (foreground and background)
colors () {
    for fgbg in 38 48; do
        for color in {0..256}; do
            echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
            if [[ $(((${color} + 1) % 10)) == 0 ]]; then
                echo
            fi
        done
        echo
    done
}


# send an HTTP GET and display timings (poor man's http profiler)
# usage: http-profile <url>
http-profile () {
    w="URL:\t\t$1\n"
    w+="Local IP:\t%{local_ip}\n"
    w+="Remote IP:\t%{remote_ip}\n\n"
    w+="Status code:\t%{http_code}\n"
    w+="Response size:\t%{size_download}\n\n"
    w+="DNS time:\t%{time_namelookup}\n"
    w+="Connect time:\t%{time_connect}\n"
    w+="PreXfer time:\t%{time_pretransfer}\n"
    w+="StartXfer time:\t%{time_starttransfer}\n"
    w+="Total time:\t%{time_total}\n\n"
    curl -sS --compressed -o /dev/null -w "$w" "$1"
}
