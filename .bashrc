# ~/.bashrc
# - bash shell configurations, aliases, functions
# - sourced for non-login shells
#
#    bbbbbbbb
#    b::::::b                                             hhhhhhh
#    b::::::b                                             h:::::h
#    b::::::b                                             h:::::h
#     b:::::b                                             h:::::h
#     b:::::bbbbbbbbb      aaaaaaaaaaaaa      ssssssssss   h::::h hhhhh
#     b::::::::::::::bb    a::::::::::::a   ss::::::::::s  h::::hh:::::hhh
#     b::::::::::::::::b   aaaaaaaaa:::::ass:::::::::::::s h::::::::::::::hh
#     b:::::bbbbb:::::::b           a::::as::::::ssss:::::sh:::::::hhh::::::h
#     b:::::b    b::::::b    aaaaaaa:::::a s:::::s  ssssss h::::::h   h::::::h
#     b:::::b     b:::::b  aa::::::::::::a   s::::::s      h:::::h     h:::::h
#     b:::::b     b:::::b a::::aaaa::::::a      s::::::s   h:::::h     h:::::h
#     b:::::b     b:::::ba::::a    a:::::assssss   s:::::s h:::::h     h:::::h
#     b:::::bbbbbb::::::ba::::a    a:::::as:::::ssss::::::sh:::::h     h:::::h
#     b::::::::::::::::b a:::::aaaa::::::as::::::::::::::s h:::::h     h:::::h
#     b:::::::::::::::b   a::::::::::aa:::as:::::::::::ss  h:::::h     h:::::h
#     bbbbbbbbbbbbbbbb     aaaaaaaaaa  aaaa sssssssssss    hhhhhhh     hhhhhhh
#
# ============================================================================


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# set a color prompt with: chroot (if in a chroot), user@host:dir, git branch (if in a git repo)
custom_prompt='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;34m\]$(__git_ps1 " (%s) ")\[\033[0m\]\$ '
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    custom_prompt="\[\033[00;31m\]${debian_chroot:+($debian_chroot)} $custom_prompt"
fi
PS1="$custom_prompt"


# export environment variables
export GITHUB_USERNAME="cgoldberg"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export PAGER="less"
export EDITOR="vi"
export VISUAL="vi"
if [ -f /usr/bin/subl ]; then
    export VISUAL="subl --new-window --wait"
fi


# don't leave .lesshst files in home directory
export LESSHISTFILE=-


# set termcap colors (used by less pager)
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
export LESS_TERMCAP_md=$(printf '\e[01;38;5;75m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[01;33m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[04;38;5;200m')


# enable programmable completion features (you don't need to enable this, if it's
# already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi


# check window size after each command and update the values of LINES and COLUMNS
shopt -s checkwinsize


# the pattern "**" used in a pathname expansion context will match
# all files and zero or more directories and subdirectories.
shopt -s globstar


# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# better command history handling
# -------------------------------
# append to history file, don't overwrite it
shopt -s histappend
# edit recalled history line before executing
shopt -s histverify
# save each line of a multi-line command in the same history entry
shopt -s cmdhist
# remove duplicate commands from history
HISTCONTROL=ignoredups:erasedups
# don't add entries to history
HISTIGNORE="x:exit" # we get duplicates of 'x' and 'exit' because shell is closed immediately
# number of previous commands stored in memory for current session
HISTSIZE=999
# number of previous commands stored in history file
HISTFILESIZE=999
# immediately add commands to history instead of waiting for end of session
PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"


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


# run sudo with existing environment variables and tab-completion enabled (needed for gui apps)
alias gsudo="sudo --preserve-env"
complete -F _root_command gsudo


# expand aliases when running sudo
alias sudo="sudo "


# expand aliases when running watch
alias watch="watch "


# enable color support for grep
alias grep="\grep --color=always"


# pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"


# kill process group by name (case-insensitive)
alias killall="\killall --ignore-case --process-group --wait"


# show how a command would be interpreted (includes: aliases, builtins, functions, scripts/executables on path)
alias which="type"


# don't leave .wget-hsts file in home directory
alias wget="wget --hsts-file=/dev/null"


# show TCP and UDP sockets that are actively listening
alias listening="sudo netstat --listening --program --symbolic --tcp --udp"


# version control
alias g="git"


# open github website in default browser
alias gith="xdg-open https://github.com"
alias gist="xdg-open https://gist.github.com/${GITHUB_USERNAME}"


# exit shell
alias x="exit"


# extract a tarball
alias untar="tar zxvf"


# open url or file in default browser
alias web="sensible-browser"


# disk space
alias df="\df --human-readable --sync"
alias ds="\df --human-readable --sync | \grep --extended-regexp '/dev/kvm|Filesystem'"


# disk usage (directory sizes)
alias du="du --human-readable --time --max-depth=1"


# ncurses disk usage (requires ncdu package)
alias ncdu="ncdu --disable-delete --group-directories-first --one-file-system --show-itemcount"


# memory usage
alias mem="free --human --si | \grep --extended-regex 'Mem|total'"


# count all files in current directory (recursive)
alias countfiles="find . -type f | wc -l"


# list directories and files in tree format
alias tree="tree -ash -CF --du"


# clear screen and scrollback buffer
alias cls="clear"
alias c="clear"


# ip addresses
alias internalip="echo 'internal ip addresss:' && echo '---------------------' && hostname --all-ip-addresses | awk '{print \$1}'"
alias externalip="echo 'external ip addresses:' && echo '----------------------' && curl ipv4.icanhazip.com && curl ipv6.icanhazip.com"


# python
alias py="python3"
alias activate="source ./venv/bin/activate"
alias act="activate"
alias deact="deactivate"


# show the zen of python
alias zen="python -c 'import this'"


# create a python virtual environment and activate it if none exists, otherwise just activate it
alias venv="[ ! -d './venv' ] && python3 -m venv --upgrade-deps venv && source ./venv/bin/activate || activate"


# serve current directory over HTTP on port 8000 (bind all interfaces)
alias webserver="python3 -m http.server"


# list directory contents
alias ls="LC_COLLATE=C \ls --almost-all --classify --group-directories-first --color=always"
alias ll="LC_COLLATE=C \ls -l --almost-all --classify --group-directories-first --human-readable --no-group --color=always"
alias l="ll"


# editors (sublime/vim)
if [ -f /usr/bin/subl ]; then
    alias edit="subl"
    alias ed="subl"
    alias e="subl --new-window ."
else
    alias edit="vi"
    alias ed="vi"
    alias e="vi ."
fi


# open ~/.bashrc for editing
alias ebrc="edit ${HOME}/.bashrc"


# --------------------------------- FUNCTIONS ---------------------------------


# print messages to stderr along with date/time
err() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $*" 1>&2
}


# chop lines at screen width
# usage example: echo $really_long_line | nowrap
nowrap () {
    cut -c-$(tput cols)
}


# colored diffs
dff () {
    if [ -z "$1" ]  || [ -z "$2" ]; then
        err "please enter 2 files to diff"
        return 1
    fi
    \diff --color=always --report-identical-files "$1" "$2" | less
}
alias diff="dff"


# grep recursively for pattern (case-insensitive)
# usage: rg <pattern>
rg () {
    if [ -z "$1" ]; then
        err "please enter a search pattern"
        return 1
    fi
    \rgrep \
    --binary-files=without-match \
    --color=always \
    --devices=skip \
    --ignore-case \
    --line-number \
    --no-messages \
    --with-filename \
    --exclude-dir=.git \
    --exclude-dir=.tox \
    --exclude-dir=.pytest_cache \
    --exclude-dir=__pycache__ \
    --exclude-dir=.venv \
    --exclude-dir=venv \
    "$1" | less
}
alias rgrep="rg"


# preview markdown with github cli
# requires github cli and gh-markdown-preview extension
#   - folow installation instructions at: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#   - run: gh extension install yusukebe/gh-markdown-preview
preview-md () {
    if [ ! -f /usr/bin/gh ]; then
        echo "github cli is not installed"
        return 1
    fi
    gh markdown-preview --light-mode "$1"
}


# run jekyll server for blog and open local url in browser
blog () {
    local blog_dir="${HOME}/code/cgoldberg.github.io"
    local jekyll_server="127.0.0.1:4000"
    if [ ! -d "${blog_dir}" ]; then
        err "${blog_dir} not found"
        return 1
    elif [ ! -x "$(command -v bundle)" ]; then
        err "bundler not found"
        return 1
    fi
    killblog
    echo "running server at: ${jekyll_server}"
    cd ${blog_dir}
    bundle exec jekyll s >/dev/null & disown # silence stdout
    sleep 3.5
    echo "opening browser at: http://${jekyll_server}"
    xdg-open "http://${jekyll_server}"
}


# kill jekyll server running blog
killblog () {
    local blog_dir="${HOME}/code/cgoldberg.github.io"
    local jekyll_proc="jekyll s"
    local jekyll_server="127.0.0.1:4000"
    if [ ! -d "${blog_dir}" ]; then
        err "${blog_dir} not found. no server running"
        return 1
    fi
    if [[ $(psgrep "${jekyll_proc}") ]]; then
        echo "killing server at: ${jekyll_server}"
        pkill -9 -f "${jekyll_proc}" && pidwait -f "${jekyll_proc}"
        psgrep "${jekyll_proc}"
    fi
}


# show spinner for indicating progress
spinner() {
    local shs=( - \\ \| / ) pnt=0
    printf '\e7'
    while ! read -rsn1 -t .2 _; do
        printf '%b\e8' "${shs[pnt++%${#shs[@]}]}"
    done
}


# start spinner background task
start_spinner () {
    tput civis;
    exec {doSpinner}> >(spinner "$@")
}


# stop spinner background task
stop_spinner () {
    echo >&"${doSpinner}" && exec {doSpinner}>&-;
    tput cnorm;
    echo
}


# search command history by regex (case-insensitive) show last n matches
# usage: h <pattern>
h () {
    local num="50"
    history -n; history -w; history -c; history -r;
    history | \grep -v "  h " | \grep --ignore-case --color=always "$1" | tail -n "${num}"
}


# create directory (make parent directories as needed)
makedir () {
    mkdir --parents --verbose "$1"
    cd "$1"
}
alias md="makedir"


# reload shell configuration
re-source () {
    echo 'sourcing ~/.bashrc ...'
    unalias -a # remove all aliases
    source "${HOME}/.bashrc"
    # if a virtual env is active, reactivate it, since the prompt prefix gets clobbered
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        source "${VIRTUAL_ENV}/bin/activate"
    fi
}


# clean pip, pipx, poetry cache
clean-pip () {
    echo "cleaning pip and pipx cache ..."
    local dirs=(
        "${HOME}/.cache/pip/"
        "${HOME}/.cache/pip-tools/"
        "${HOME}/.local/pipx/.cache/"
    )
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
}


# clean python dev/temp files from local directory (recurse subdirectories)
clean-py () {
    echo "cleaning python dev/temp files ..."
    local dirs=(
        "build/"
        "dist/"
    )
    local recurse_dirs=(
        "*.egg-info/"
        ".mypy_cache/"
        ".pytest_cache/"
        ".tox/"
        ".venv/"
        "__pycache__/"
        "venv/"
    )
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        echo "deactivating venv"
        deactivate
    fi
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
    for d in ${recurse_dirs[@]}; do
        echo "recursively deleting ${d}"
        rm -rf ./**/${d}/
    done
}


# clean selenium dev environment
clean-selenium-dev () {
    local sel_home="${HOME}/code/selenium"
    local dirs=(
        "build/"
        "dist/"
    )
    local recurse_dirs=(
        "*.egg-info/"
        ".mypy_cache/"
        ".pytest_cache/"
        ".tox/"
        ".venv/"
        "__pycache__/"
        "venv/"
    )
    if [ -d "${sel_home}" ]; then
        echo "cleaning up selenium dev environment ..."
        if [ ! -z "${VIRTUAL_ENV}" ]; then
            echo "deactivating venv ..."
            deactivate
        fi
        for d in ${dirs[@]}; do
            if [ -d "${d}" ]; then
                echo "deleting ${d}"
                rm -rf "${d}"
            fi
        done
        for rd in ${recurse_dirs[@]}; do
            echo "recursively deleting ${rd}"
            rm -rf ${sel_home}/py/**/${rd}
        done
    else
        echo "can't find ${sel_home}!"
    fi
}


# clean selenium dev environment, cache, browsers, webdrivers, build artifacts
clean-selenium-dev-full () {
    clean-selenium-dev
    local sel_home="${HOME}/code/selenium"
    local sel_dirs=(
        "${sel_home}/py/selenium/webdriver/common/devtools/"
        "${sel_home}/py/selenium/webdriver/common/linux/"
        "${sel_home}/py/selenium/webdriver/common/macos/"
        "${sel_home}/py/selenium/webdriver/common/windows/"
    )
    local symlinks=(
        "${sel_home}/bazel-bin"
        "${sel_home}/bazel-genfiles"
        "${sel_home}/bazel-out"
        "${sel_home}/bazel-selenium"
        "${sel_home}/bazel-testlogs"
    )
    local dot_dirs=(
        "${HOME}/.cache/bazel/"
        "${HOME}/.cache/bazelisk/"
        "${HOME}/.cache/google-chrome-for-testing/"
        "${HOME}/.cache/Microsoft/"
        "${HOME}/.cache/mozilla/"
        "${HOME}/.cache/pnpm/"
        "${HOME}/.cache/selenium/"
        "${HOME}/.mozilla/"
    )
    echo "cleaning up selenium cache, browsers, webdrivers, build artifacts ..."
    if [ -d "${sel_home}" ]; then
        for sd in ${sel_dirs[@]}; do
            if [ -d "${sd}" ]; then
                echo "deleting ${sd}"
                rm -rf "${sd}"
            fi
        done
    fi
    if [ -d "${sel_home}" ]; then
        for sl in ${symlinks[@]}; do
            if [ -L "${sl}" ]; then
                echo "deleting ${sl}"
                sudo rm -rf "${sl}"
            fi
        done
    fi
    for dd in ${dot_dirs[@]}; do
        if [ -d "${dd}" ]; then
            echo "deleting ${dd}"
            sudo rm -rf "${dd}"
        fi
    done
}


# run selenium grid server in standalone mode (on port 4444)
# download server first with github cli if it's not found
selenium-server () {
    local sel_home="${HOME}/code/selenium"
    local jar="selenium-server.jar"
    if [ ! -f /usr/bin/gh ]; then
        err "github cli is not installed"
        return 1
    fi
    if [ ! -d "${sel_home}" ]; then
        err "can't find selenium repo at: ${sel_home}"
        return 1
    fi
    cd ${sel_home}
    if [ ! -f "${jar}" ]; then
        gh release download --pattern=selenium-server*.jar --output=${jar}
    fi
    java -jar ${jar} standalone
}


# kill all webdrivers and remote server started by selenium
kill-webdriver () {
    \killall --ignore-case --process-group --quiet chromedriver
    \killall --ignore-case --process-group --quiet geckodriver
    \killall --ignore-case --process-group --quiet msedgedriver
    \killall --ignore-case --process-group --quiet webkitwebdriver
    \killall --ignore-case --process-group --quiet java
    sleep 1
    \killall -9 --ignore-case --process-group --quiet --wait chromedriver
    \killall -9 --ignore-case --process-group --quiet --wait geckodriver
    \killall -9 --ignore-case --process-group --quiet --wait msedgedriver
    \killall -9 --ignore-case --process-group --quiet --wait webkitwebdriver
    \killall -9 --ignore-case --process-group --quiet --wait java
}


# delete and re-install all webdrivers and browsers used by selenium
update-webriver () {
    local sel_mgr_path="${HOME}/code/selenium/py/selenium/webdriver/common/linux"
    if [ ! -d "${sel_mgr_path}" ]; then
        err "selenium manager not found"
        return 1
    fi
    local dirs=(
        "${HOME}/.cache/google-chrome-for-testing/"
        "${HOME}/.cache/Microsoft/"
        "${HOME}/.cache/mozilla/"
        "${HOME}/.cache/selenium/"
        "${HOME}/.mozilla/"
    )
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
    echo
    kill-webdriver
    echo "updating chrome/chromedriver ..."
    start_spinner
    ${sel_mgr_path}/selenium-manager --browser=chrome --driver=chromedriver
    stop_spinner
    echo "updating edge/edgedriver ..."
    start_spinner
    ${sel_mgr_path}/selenium-manager --browser=edge --driver=edgedriver
    stop_spinner
    echo "updating firefox/geckodriver ..."
    start_spinner
    ${sel_mgr_path}/selenium-manager --browser=firefox --driver=geckodriver
    stop_spinner
}


# search active processes for pattern (case-insensitive)
# usage: psgrep <pattern>
psgrep () {
    if [ ! -z "$1" ]; then
        ps -ef | \grep -v "grep" \
            | \grep --color=always --extended-regexp --ignore-case "$1" \
            | nowrap
    else
        ps -ef
    fi
}


# search recursively under the current directory for filenames matching pattern (case-insensitive)
# usage: findfiles <pattern>
findfiles () {
    if [ -z "$1" ]; then
        err "usage: findfiles <pattern>"
        return 1
    fi
    find \
        -xdev \
        -iname "*$1*" \
        ! -path "*/.git/*" \
        ! -path "*/.tox/*" \
        ! -path "*/.venv/*" \
        ! -path "*/.pytest_cache/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/venv/*" \
        | \grep --ignore-case --color=always "$1"
}
alias ff="findfiles"


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
    # remove cached packages
    sudo apt clean && echo &&
    # purge orphaned configs from removed packages
    purge-apt-configs && echo &&
    # reload package index files from sources
    sudo apt --no-allow-insecure-repositories update && echo
}


# purge configuration data from packages marked as removed
purge-apt-configs () {
    if dpkg -l | grep --quiet '^rc'; then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
    fi
}


# count tests found under current directory by running pytest discovery
# usage: count-tests <path> (no arg counts everything under current directory)
counttests () {
    if [ -x "$(command -v pytest)" ]; then
        echo "running test discovery ..."
        local num_tests=$(pytest --collect-only -q "$1" | head -n -2 | wc -l)
        echo "tests found: ${num_tests}"
    else
        echo "pytest not found"
    fi
}


# update pyenv, plugins, and pip in every python installation
update-pyenv () {
    local py_versions=(
        "3.8"
        "3.9"
        "3.10"
        "3.11"
        "3.12"
        "3.13"
        "pypy3.11"
    )
    if [ ! -d ~/.pyenv ]; then
        err "pyenv is not installed"
        return 1
    fi
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        echo "deactivating venv"
        deactivate
    fi
    echo "updating pyenv and plugins ..."
    pyenv update
    pyenv rehash
    echo
    for py_version in ${py_versions[@]}; do
        pyenv global ${py_version}
        echo "version installed: $(python --version)"
        echo "version available: Python $(pyenv latest ${py_version})"
        echo "updating pip ..."
        python3 -m pip install --upgrade pip
        echo
    done
    pyenv global 3.13
}


# ruby gems
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"


# pyenv
if [ -d ~/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
fi


# pipx
if [ -f /usr/bin/pipx ]; then
    eval "$(register-python-argcomplete pipx)"
fi


# atuin - shell history/search (https://atuin.sh)
# ctrl-r to activate
# run autuin-update to update the binary
if [ -d ~/.atuin ]; then
    source "$HOME/.atuin/bin/env"
    [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
    eval "$(atuin init bash --disable-up-arrow)"
fi
