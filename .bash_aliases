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

# editors
alias sublime="subl"
alias edit="subl"
alias ed="subl"
alias e="subl -n ."
alias vi="vim"
alias v="vim"

# pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"

# directory listings
alias ls="\ls -l --human-readable --almost-all --classify --group-directories-first --no-group --color=auto"
alias l="\ls --almost-all --classify --group-directories-first --color=auto"
alias ll="l"
alias la="l"

# extract a tarball
alias untar="tar zxvf"

# colored grep output
alias grep="grep --color=auto"

# better ICMP ECHO_REQUEST
alias ping="prettyping"

# open shell configurations for editing
alias ebrc="subl -n ~/.bashrc ~/.bash_aliases"

# list public bash functions and aliases defined in the current shell
alias funcs="compgen -a -A function | grep -v ^_ | sort"

# reload shell configurations
alias re-source="source ~/.bashrc"

# system shutdown
alias shutdown="sudo poweroff"
alias sd="shutdown"

# system reboot
alias reboot="sudo reboot"
alias rb="reboot"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias x="exit"

#  ¯\_(ツ)_/¯
alias shrug="echo -n '¯\_(ツ)_/¯' | xclip && echo '¯\_(ツ)_/¯ copied to X clipboard'"

# upgrade music server
alias squeezeboxserver-upgrade="sudo ~/bin/squeezeboxserver-upgrade"

# bounce music server
alias squeezeboxserver-restart="service logitechmediaserver restart"

# ip addresses
alias externalip="curl icanhazip.com"
alias localip="hostname -I"
alias ips="echo -n 'local ip: ' && localip && echo -n 'external ip: ' && externalip"

# show disk space available on all mounted ext4 filesystems
alias diskfree="\df --sync --human-readable --total --type=ext4"
alias df="diskfree"

# show disk space used by top 100 files and directories under the current directory
alias du="diskused"

# watch disk space used by largest directories under the current directory
alias dw="diskwatch"

# serve current directory over HTTP on port 8080
alias webserver-py3="python3 -m http.server 8080"
alias webserver-py2="python -m SimpleHTTPServer 8080"
alias webserver="webserver-py3"

# count files recursively under current directory
alias countfiles="find . -type f | wc -l"

# show last 50 modified files under current dir
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | grep -v '.git' | sort -n | tail -n 50"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# purge thumbnail and icon cache
alias purge-thumbs="rm -rf ${HOME}/.cache/thumbnails && sudo gtk-update-icon-cache -f /usr/share/icons/hicolor && nautilus -q 2>/dev/null"

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


# create and activate python2.7 virtualenv in ./ENV
venv () {
    local dir="ENV"
    if [[ ! -d ./$dir ]]; then
        echo "creating py2.7 virtualenv in ./$dir"
        virtualenv "$dir"
    fi
    echo "activating py2 virtualenv in ./$dir"
    source ./$dir/bin/activate
}


# create and activate python3 virtualenv in ./ENV
venv3 () {
    local dir="ENV"
    if [[ ! -d ./$dir ]]; then
        echo "creating py3 virtualenv in ./$dir"
        python3 -m venv "$dir"
    fi
    echo "activating py3 virtualenv in ./$dir"
    source ./$dir/bin/activate
}


# open a browser and go to the online Debian man page for the given command
# usage: wman <pattern>
wman () {
    python -c "import webbrowser; webbrowser.open('https://manpages.debian.org/${1}')" > /dev/null 2>&1
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
    watch --interval=3 echo "Largest directories under ${PWD}:; du -hx ${PWD} 2>/dev/null | sort -h | tail -n 20; echo; echo Total for ${PWD}:; tree -a ${PWD} | tail -n 1"
}


# convert all .png images in the current directory to .jpg format
# save with renamed extensions and delete originals (requires gnu parallel)
convert-pngs-to-jpgs () {
    findpngs () { find . -maxdepth 1 -type f -iname "*.png" -prune; }
    if [[ -n $(findpngs) ]]; then
        ( findpngs | parallel convert -quality 95% {} {.}.jpg ) &&
        ( findpngs | parallel rm {} )
    else
        echo 'nothing to convert'
    fi
}


# rename all files in current directory with ".jpeg" extension to ".jpg" and lowercase any .JPG extensions
img-fix-jpg-extensions () {
    rename 's/\.jpe?g$/.jpg/i' *
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


# expand initial tabs into 4 spaces and convert line endings
# conversion done in-place (requires dos2unix and moreutils packages)
fix-whitespace () {
    if [[ $# -eq 0 ]]; then
        echo "filename argument required"
    else
        expand -i -t 4 "$1" | sponge "$1"
        dos2unix --quiet "$1"
    fi
}



# set permissions in music library so Squeezebox server can scan and play audio files
squeezebox-fix-permissions () {
    local music_dir="/mnt/blue/Tunes/"
    fix_perms () {
        find "$music_dir" -type d -exec chmod 755 {} \; -print
        find "$music_dir" -type f -iname '*.flac' -exec chmod 644 {} \; -print
        find "$music_dir" -type f -iname '*.mp3' -exec chmod 644 {} \; -print
    }
    echo "setting file permissions in Music Library..."
    echo "  * directories: read/write/execute for owner, read/execute for group/others"
    echo "  * audio files: read/write for owner, read for group/others"
    echo
    read -p "are you sure? <y/N> " prompt
    if [[ "$prompt" =~ [yY]$ ]]; then
        fix_perms
    fi
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
    sudo apt --no-allow-insecure-repositories update && echo &&
    # upgrade installed packages
    sudo apt full-upgrade && echo &&
    # check for broken dependencies
    sudo apt-get check && echo &&
    # fix broken dependencies
    sudo apt --fix-broken install && echo &&
    # fix missing dependencies
    sudo apt --fix-missing install && echo &&
    # purge packages that are no longer needed
    sudo apt --purge autoremove && echo &&
    # purge orphaned configs from removed packages
    purge-apt-configs &&
    # remove cached packages
    sudo apt clean && echo &&
    # reload package index files from sources
    sudo apt --no-allow-insecure-repositories update && echo &&
    # display package count
    echo "${REVERSEGREEN}$(countpackages) packages currently installed${RESTORE}"
}


# purge configuration data from packages marked as removed
purge-apt-configs () {
    if dpkg -l | grep --quiet '^rc'; then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
        sudo apt --no-allow-insecure-repositories update
    else
        echo "no package configs to remove"
    fi
}


# purge all Dropbox files from local cache
purge-dropbox-cache () {
    if ! dropbox running; then
        dropbox stop && sleep 2
    fi
    cache_dir="${HOME}/Dropbox/.dropbox.cache/"
    if [[ -d "$cache_dir" ]]; then
        \du -ah "$cache_dir"
        echo "purging local Dropbox cache..."
        rm -rf "$cache_dir"
        sleep 1
    fi
    dropbox start > /dev/null 2>&1
}


# download and install latest Dropbox daemon
dropbox-update-daemon () {
    if ! dropbox running; then
        dropbox stop && sleep 2
    fi
    dropbox update && dropbox start > /dev/null 2>&1
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


# download latest Selenium server from official release archive
# (requires: libxml-xpath-perl)
download_selenium_server () {
    local baseurl="https://selenium-release.storage.googleapis.com"
    local latest=$(curl -sS $baseurl | xpath -q -e "./ListBucketResult/Contents/Key/text()" |
        grep "selenium-server-standalone" | sort -V | tail -n 1)
    echo -n "Downloading: " && echo $latest | cut -d'/' -f2
    curl -O# ${baseurl}/${latest}
}


# skip to next track in Squeezebox playlist
next () {
    curl -sS -o /dev/null -X POST -d '{"id":1,"method":"slim.request","params":["'${SQUEEZEBOX_PLAYER}'",["button","jump_fwd"]]}' "$SQUEEZEBOX_ENDPOINT"
}


# pause/resume audio from Squeezebox player
pause () {
    curl -sS -o /dev/null -X POST -d '{"id":1,"method":"slim.request","params":["'${SQUEEZEBOX_PLAYER}'",["pause"]]}' "$SQUEEZEBOX_ENDPOINT"
}
