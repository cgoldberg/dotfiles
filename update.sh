#!/usr/bin/env bash
#
# Corey Goldberg (https://github.com/cgoldberg)
#
# update.sh - install or update local configs and scripts from github
#
# install dependencies for full functionality:
#
#  - all platforms:
#    - bat (cargo install bat, scoop install bat)
#    - cargo-cache (cargo install cargo-cache)
#    - delta (cargo install git-delta, scoop install delta)
#    - deno (curl -fsSL https://deno.land/install.sh | sh, scoop install deno)
#    - exiftool (sudo apt install exiftool, scoop install exiftool)
#    - eza (cargo install eza, scoop install eza)
#    - fd (cargo install fd-find, scoop install fd)
#    - ffmpeg (sudo apt install ffmpeg, scoop install ffmpeg)
#    - fzf (https://github.com/junegunn/fzf, scoop install fzf)
#    - gcc (sudo apt install build-essential, scoop install mingw)
#    - gh (https://github.com/cli/cli, scoop install gh)
#    - git-who (https://github.com/sinclairtarget/git-who)
#    - java (sudo apt install default-jdk, scoop install openjdk)
#    - jq (sudo apt install jq, scoop install jq)
#    - magick (sudo apt install imagemagick, scoop install imagemagick)
#    - pandoc (https://github.com/jgm/pandoc, scoop install pandoc)
#    - pipx (pip install --user pipx)
#    - pyupgrade (pipx-install pyupgrade)
#    - refurb (pipx-install refurb)
#    - rg (cargo install ripgrep, scoop install ripgrep)
#    - ruby (sudo apt install ruby, scoop install ruby)
#    - rustup (https://rustup.rs - on Windows: scoop install rustup-gnu)
#    - shellcheck (sudo apt install shellcheck, scoop install shellcheck)
#    - subl (https://sublimetext.com/docs/linux_repositories.html)
#    - yt-dlp (pipx-install yt-dlp[default])
#    - zoxide (cargo install zoxide)
#
#  - linux only:
#    - bmon (sudo apt install bmon)
#    - btop (sudo apt install btop)
#    - githubtakeout (pipx-install githubtakeout)
#    - gnome-terminal (sudo apt install gnome-terminal)
#    - go (https://go.dev/doc/install)
#    - google_drive_export (pipx install google-drive-export)
#    - iostat (sudo apt install sysstat)
#    - metaflac (sudo apt install flac)
#    - ncal (sudo apt install ncal)
#    - pyenv (https://github.com/pyenv/pyenv)
#    - rsync (sudo apt install rsync)
#    - sshpass (sudo apt install sshpass)
#    - toilet (sudo apt install toilet)
#
#  - windows only:
#    - alacritty (scoop install alacritty)

set -eo pipefail


DOTFILES_HOME="${HOME}/code/dotfiles"
BIN_DIR="${HOME}/bin"
REQUIREMENTS=(
    "git"
    "curl"
)
DEPENDENCIES=(
    "bat"
    "cargo-cache"
    "delta"
    "exiftool"
    "deno"
    "eza"
    "fd"
    "ffmpeg"
    "fzf"
    "gcc"
    "gh"
    "git-who"
    "java"
    "jq"
    "magick"
    "pandoc"
    "pipx"
    "pyupgrade"
    "refurb"
    "rg"
    "ruby"
    "rustup"
    "shellcheck"
    "subl"
    "yt-dlp"
    "zoxide"
)
DEPENDENCIES_LINUX=(
    "bmon"
    "btop"
    "githubtakeout"
    "gnome-terminal"
    "go"
    "google_drive_export"
    "iostat"
    "metaflac"
    "ncal"
    "pyenv"
    "rsync"
    "sshpass"
    "toilet"
)
DEPENDENCIES_WINDOWS=(
    "alacritty"
)
CONFIGS=(
    ".bashrc"
    ".bashrc_squeezebox"
    ".bash_logout"
    ".profile"
    ".gitconfig"
)
LINUX_CONFIGS=(
    ".bashrc_linux"
    ".bashrc_linux_selenium"
)
WIN_CONFIGS=(
    ".bashrc_windows"
    ".gitconfig_win"
    ".minttyrc"
)
SCRIPTS=(
    "./bin/colors"
    "./bin/prettyping"
)
LINUX_SCRIPTS=(
    "./bin/backup-gdrive"
    "./bin/backup-github"
    "./bin/backup-nas-to-external"
    "./bin/backup-nas-to-nas"
    "./bin/mount-bitz"
    "./bin/mount-bytez"
    "./bin/now"
    "./bin/sync-nas"
    "./bin/sysinfo"
    "./bin/test-nas-data-xfer"
)
GIT_SCRIPTS=(
    "git-branches"
    "git-clean-untracked"
    "git-contribs"
    "git-info"
    "git-obliterate-repo"
    "git-prs"
    "git-score"
    "git-stat"
    "git-sync"
    "git-syncrepo"
    "git-track-branches"
    "git-whack-branches"
)


err () {
    tput bold; tput setaf 1; echo -en "\u2717 " 1>&2; tput sgr0
    tput bold; echo "$*" 1>&2; tput sgr0
}


die () {
    err "$*"
    exit 1
}


ok () {
    tput bold; tput setaf 10; echo -en "\u2714  " 1>&2; tput sgr0
    tput bold; echo "$*" 1>&2; tput sgr0
}


check-programs () {
    local programs=("$@")
    unset check_failed
    for prog in "${programs[@]}"; do
        if ! type "${prog}" >/dev/null 2>&1; then
            err "${prog} is not installed"
            check_failed="true"
        else
            ok "${prog} is installed"
        fi
    done
}


check-requirements () {
    if [[ "${OSTYPE}" != "msys" ]] && [[ "${OSTYPE}" != "linux"* ]]; then
        die "fatal: unknown operating system"
    fi
    check-programs "${REQUIREMENTS[@]}"
    if [ -n "${check_failed}" ]; then
        echo
        die "fatal: missing requirement"
    fi
}


check-dependencies () {
    check-programs "${DEPENDENCIES[@]}"
    if [ -n "${check_failed}" ]; then
        check_deps_failed="true"
    fi
    if [[ "${OSTYPE}" == "linux"* ]]; then
        check-programs "${DEPENDENCIES_LINUX[@]}"
        if [ -n "${check_failed}" ]; then
            check_linux_deps_failed="true"
        fi
    fi
    if [[ "${OSTYPE}" == "msys" ]]; then
        check-programs "${DEPENDENCIES_WINDOWS[@]}"
        if [ -n "${check_failed}" ]; then
            check_win_deps_failed="true"
        fi
    fi
}


# -----------------------------------------------------------------------------

if [ ! -d "${DOTFILES_HOME}" ]; then
    die "fatal: can't find local dotfiles repo"
fi

check-requirements
check-dependencies
echo
mkdir --parents "${BIN_DIR}"
cd "${DOTFILES_HOME}"

current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's/.*\///')

git checkout "${default_branch}" >/dev/null 2>&1
echo "syncing local branches in ${DOTFILES_HOME} from github ..."
git sync
echo

# --------------------------------- CONFIGS -----------------------------------

if [[ "${OSTYPE}" == "msys" ]]; then
    echo "copying windows configs from dotfiles repo to ${HOME} ..."
    for config in "${WIN_CONFIGS[@]}"; do
        echo -e "  copying: ${config}"
        cp "${config}" "${HOME}"
    done
    echo

    alacritty_dir="${APPDATA//\\//}/alacritty"
    alacritty_config="./alacritty/alacritty.toml"
    echo "copying alacritty config from dotfiles repo to ${alacritty_dir} ..."
    mkdir --parents "${alacritty_dir}"
    echo -e "  copying: ${alacritty_config}"
    cp "${alacritty_config}" "${alacritty_dir}"
    echo
fi

if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux configs from dotfiles repo to ${HOME} ..."
    for config in "${LINUX_CONFIGS[@]}"; do
        echo -e "  copying: ${config}"
        cp "${config}" "${HOME}"
    done
    echo

    btop_dir="${HOME}/.config/btop"
    btop_config="./btop/btop.conf"
    echo "copying btop config from dotfiles repo to ${btop_dir} ..."
    mkdir --parents "${btop_dir}"
    echo -e "  copying: ${btop_config}"
    cp "${btop_config}" "${btop_dir}"
    echo

    sublime_dir="${HOME}/.config/sublime-text/Packages/User"
    sublime_config="./sublime/Preferences.sublime-settings"
    echo "copying sublime config from dotfiles repo to ${sublime_dir} ..."
    mkdir --parents "${sublime_dir}"
    echo -e "  copying: ${sublime_config}"
    cp "${sublime_config}" "${sublime_dir}"
    echo

    gnome_terminal_config="gnome-terminal.properties"
    echo "setting gnome-terminal dconf config from dotfiles repo ..."
    echo -e "  loading: ${gnome_terminal_config}"
    cat "./debian/dconf/${gnome_terminal_config}" | dconf load /org/gnome/terminal/
    echo
fi

echo "copying configs from dotfiles repo to ${HOME} ..."
for config in "${CONFIGS[@]}"; do
    echo -e "  copying: ${config}"
    cp "${config}" "${HOME}"
done
echo

pandoc_template_dir="${HOME}/.pandoc"
pandoc_templates=("./pandoc/template.html" "./pandoc/template.css")
echo "copying pandoc templates from dotfiles repo to ${pandoc_template_dir} ..."
mkdir --parents "${pandoc_template_dir}"
for template in "${pandoc_templates[@]}"; do
    echo -e "  copying: ${template}"
    cp "${template}" "${pandoc_template_dir}"
done
echo

# --------------------------------- SCRIPTS -----------------------------------

if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux scripts from dotfiles repo to ${BIN_DIR} ..."
    for script in "${LINUX_SCRIPTS[@]}"; do
        echo -e "  copying: ${script}"
        cp "${script}" "${BIN_DIR}"
    done
    echo
fi

echo "copying scripts from dotfiles repo to ${BIN_DIR} ..."
for script in "${SCRIPTS[@]}"; do
    echo -e "  copying: ${script}"
    cp "${script}" "${BIN_DIR}"
done
echo

echo "downloading git scripts from github to ${BIN_DIR} ..."
for script in "${GIT_SCRIPTS[@]}"; do
    url="https://raw.githubusercontent.com/cgoldberg/git-scripts/refs/heads/main/${script}"
    echo -e "  downloading: ./${BIN_DIR##*/}/${script}"
    curl -fsS --output "${BIN_DIR}/${script}" "${url}"
    chmod +x "${BIN_DIR}/${script}"
    if [[ "${OSTYPE}" == "msys" ]]; then
        unix2dos "${BIN_DIR}/${script}" >/dev/null 2>&1
    fi
done
echo

# -----------------------------------------------------------------------------

git checkout "${current_branch}" >/dev/null 2>&1

if \
    [ -n "${check_deps_failed}" ] || \
    [ -n "${check_linux_deps_failed}" ] || \
    [ -n "${check_win_deps_failed}" ]; then
    err "missing dependency"
else
    ok "all dependencies installed"
fi

echo
ok "done updating configs and scripts"
