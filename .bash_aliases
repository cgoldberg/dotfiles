#
# ~/.bash_aliases - bash shell aliases and functions
#   * customizations for cgoldberg
#   * sourced in ~/.bashrc for non-login shells
#


# ====================================================== #
#                                                        #
#           888 d8b                                      #
#           888 Y8P                                      #
#           888                                          #
#   8888b.  888 888  8888b.  .d8888b   .d88b.  .d8888b   #
#      "88b 888 888     "88b 88K      d8P  Y8b 88K       #
#  .d888888 888 888 .d888888 "Y8888b. 88888888 "Y8888b.  #
#  888  888 888 888 888  888      X88 Y8b.          X88  #
#  "Y888888 888 888 "Y888888  88888P'  "Y8888   88888P'  #
#                                                        #
# ====================================================== #


# show the zen
alias zen="python -c 'import this'"

# expand aliases when run with sudo
alias sudo="sudo "

# expand aliases when running watch command
alias watch="watch "

# version control
alias g="git"

# pythons
alias py="python3.7"
alias py3="python3.7"
alias py2="python2.7"

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

# directory listings (requires exa)
alias ls="\exa --all --classify --git --group-directories-first --header --long && echo"
alias l="\exa --all --classify --group-directories-first && echo"
alias ll="LC_COLLATE=C \ls -l --almost-all --classify --group-directories-first --human-readable --no-group --color=always && echo"

# extract a tarball
alias untar="\tar zxvf"

# colored grep output
alias grep="\grep --color=auto"

# open shell configurations for editing
alias ebrc="subl -n ${HOME}/.bashrc ${HOME}/.bash_aliases"

# list public bash functions and aliases defined in the current shell
alias funcs="\compgen -a -A function | grep -v ^_ | sort"

# reload shell configurations
alias re-source="source ${HOME}/.bashrc"

# system shutdown
alias shutdown="sudo \poweroff"
alias sd="shutdown"

# system reboot
alias reboot="sudo \reboot"
alias rb="reboot"

# clear terminal
alias cls="\clear"
alias c="cls"

# exit terminal
alias x="\exit"

# show disk space used by files/dirs under the current directory (ncurses interface)
alias du="\ncdu -rx"
alias diskused="du"

#  ¯\_(ツ)_/¯
alias shrug="echo -n '¯\_(ツ)_/¯' | xclip -selection clipboard && echo -n '¯\_(ツ)_/¯' | xclip -selection primary && echo '¯\_(ツ)_/¯ copied to X clipboard'"

# upgrade music server
alias squeezeboxserver-upgrade="sudo ${HOME}/bin/squeezeboxserver-upgrade"

# bounce music server
alias squeezeboxserver-restart="service logitechmediaserver restart"

# ip addresses
alias externalip="curl icanhazip.com"
alias localip="hostname -I"
alias ips="echo -n 'local ip: ' && localip && echo -n 'external ip: ' && externalip"
alias myip="ips"

# show disk space available on all mounted ext4 filesystems
alias diskfree="\df --sync --human-readable --total --type=ext4"
alias df="diskfree"

# show TCP and UDP sockets that are actively listening
alias listening="sudo \netstat --listening --program --symbolic --tcp --udp"

# serve current directory over HTTP on port 8080
alias webserver-py3="python3.7 -m http.server 8080"
alias webserver-py2="python -m SimpleHTTPServer 8080"
alias webserver="webserver-py3"

# scan recursively under home directory and load last modified Python file into editor
alias edlast="find '${HOME}' -type f -name '*.py' -printf '%T@ %p\n' | sort --numeric --stable --key=1 | tail -n 1 | cut -d' ' -f2 | ed"

# count all files in current directory (recursive)
alias countfiles="find . -type f | wc -l"

# show counts of file extensions used in currect directory (recursive)
alias filetypes="find . -type f | grep -v '.git' | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn"

# show last 50 modified files in current dir (recursive)
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | grep -v '.git' | sort -n | tail -n 50"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# purge thumbnail and icon cache
alias purge-thumbs-and-icons="rm -rf ${HOME}/.cache/thumbnails && sudo gtk-update-icon-cache -f /usr/share/icons/hicolor && nautilus -q 2>/dev/null"

# count installed system packages
alias countpackages="dpkg -l | grep '^ii' | wc -l"

# disable line wrapping in terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in terminal (long lines wrapped at terminal width)
alias wrap="tput smam"

# color and side-by-side for diffs (requires colordiff package)
alias diff="colordiff -s"

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep --color=always 'ca fe'"

# go to blue mount point
alias blue="cd /mnt/blue"

# Boston weather with 3-day forecast
alias weather="ansiweather -f 3 -l 4930956 -u imperial -k 1823926ea603031013edbc7b8d2fb104"

# navigate up the directory tree
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."
alias cd.......="cd ../../../../../.."
alias cd........="cd ../../../../../../.."


# ======================================================================================== #
#                                                                                          #
#   .o88o.                                       .    o8o                                  #
#   888 `"                                     .o8    `"'                                  #
#  o888oo  oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o  #
#   888    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8  #
#   888     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.   #
#   888     888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b  #
#  o888o    `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P'  #
#                                                                                          #
# ======================================================================================== #


pycheck () {
    pycodestyle_cmd () { python3 -m pycodestyle "$@"; }
    pylint_cmd () { python3 -m pylint --output-format="colorized" /
        --msg-template='{C}, line: {line} column: {column}, {symbol} {msg_id} ({category})' "$@"; }
    echo "${REVERSEMAGENTA}linting .py files...${RESTORE}"
    echo
    echo "${REVERSEMAGENTA}pycodestyle:${RESTORE}"
    if [[ $# -eq 0 ]]; then
        pycodestyle_cmd .
    else
        pycodestyle_cmd "$@"
    fi
    if [[ $? -eq 0 ]]; then
        echo "no style issues found!"
    fi
    echo
    echo "${REVERSEMAGENTA}pylint:${RESTORE}"
    if [[ $# -eq 0 ]]; then
        pylint_cmd *.py
    else
        pylint_cmd "$@"
    fi
}


# activate Python 2.7 virtual environment in ./ENV (create fresh one if needed)
venv () {
    local dir="ENV"
    local pyversion="Python 2.7"
    if [[ ! -d ./${dir} ]]; then
        echo "creating ${pyversion} virtual environment in ./${dir}"
        virtualenv "${dir}"
    fi
    echo "activating ${pyversion} virtual environment in ./${dir}"
    source ./${dir}/bin/activate
}


# activate Python 3.7 virtual environment in ./ENV (create fresh one if needed)
venv3 () {
    local dir="ENV"
    local pyversion="Python 3.7"
    if [[ ! -d ./${dir} ]]; then
        echo "creating ${pyversion} virtual environment in ./${dir}"
        python3.7 -m venv "${dir}"
    fi
    echo "activating ${pyversion} virtual environment in ./${dir}"
    source ./${dir}/bin/activate
}


# lists contents after changing directory
cd () {
    if [[ $# -eq 0 ]]; then
        builtin cd && ls
    else
        builtin cd "$1" && ls
    fi
}


# open a file or URL in the preferred application and hide all console output
open () {
    nohup xdg-open "$@" > /dev/null 2>&1
}
alias o="open"


# open a file or URL in the preferred application and hide all console output
google () {
    nohup chromium-browser "$@" > /dev/null 2>&1
}
alias goog="google"


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
    ps -ef | \grep -i --color=always "$1" | grep -v "grep" | sort -n | less
}


# watch disk space used by largest directories under the current directory
diskwatch () {
    local interval="3"
    local num_dirs="25"
    local msg="${num_dirs} largest directories in ${PWD} \(updates every ${interval} secs\):"
    watch --no-title --interval=${interval} \
        echo "${msg}; echo; du -hx ${PWD} 2>/dev/null |
            sort -hr |
            tail -n 20;
            echo;
            echo Total:;
            tree -a ${PWD} |
            tail -n 1"
}
alias dw="diskwatch"


# convert all .png and .webp images in the current directory to .jpg format
# save with renamed extensions and delete originals (requires gnu parallel and webp)
convert-images-to-jpgs () {
    findpngs () { find . -maxdepth 1 -type f -iname "*.png" -o -iname "*.webp"; }
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
squeezeboxserver-fix-permissions () {
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
    updatedb --require-visibility 0 --output "${HOME}"/.locatedb &&
    locate --existing --ignore-case --database "${HOME}"/.locatedb "$@"
}
alias lf="locatefiles"


# search recursively under current directory for filenames (and directories) matching pattern (case-insensitive)
findfiles () {
    find . -xdev -type f,d -iname "*$1*" | grep -i --color=always "$1"
}
alias ff="findfiles"
alias f="findfiles"


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
    curl -sS -o /dev/null -X POST \
        -d '{"id":1,"method":"slim.request","params":["'${SQUEEZEBOX_PLAYER}'",["button","jump_fwd"]]}' \
        "http://${SQUEEZEBOX_SERVER}/jsonrpc.js"
}


# pause/resume audio from Squeezebox player
pause () {
    curl -sS -o /dev/null -X POST -d '{"id":1,"method":"slim.request","params":["'${SQUEEZEBOX_PLAYER}'",["pause"]]}' "$SQUEEZEBOX_ENDPOINT"
}


ctail () {
    tail -f -n 80 "$1" |
        sed --unbuffered \
        -e 's/\(.*FATAL.*\)/\o033[31m\1\o033[39m/' \
        -e 's/\(.*ERROR.*\)/\o033[31m\1\o033[39m/' \
        -e 's/\(.*WARN.*\)/\o033[33m\1\o033[39m/' \
        -e 's/\(.*INFO.*\)/\o033[32m\1\o033[39m/' \
        -e 's/\(.*DEBUG.*\)/\o033[34m\1\o033[39m/' \
        -e 's/\(.*TRACE.*\)/\o033[30m\1\o033[39m/' \
        -e 's/\(.*[Ee]xception.*\)/\o033[39m\1\o033[39m/'
}
