#!/usr/bin/env bash
#
# Corey Goldberg (https://github.com/cgoldberg)
#
# update.sh - install or update local configs and scripts from github
#
# install dependencies for full functionality:
#
#  - all platforms:
#    - bat (https://github.com/sharkdp/bat)
#    - eza (cargo install)
#    - fd (https://github.com/sharkdp/fd)
#    - gh (https://github.com/cli/cli)
#    - jq (apt install)
#    - pandoc (https://github.com/jgm/pandoc)
#    - pipx (pip install)
#    - pyupgrade (pipx install)
#    - refurb (pipx install)
#    - rg (https://github.com/BurntSushi/ripgrep)
#    - ruby (apt install)
#    - shellcheck (apt install)
#    - sublime-text (https://sublimetext.com/docs/linux_repositories.html)
#
#  - linux only:
#    - cargo-cache (cargo install)
#    - exiv2 (apt install)
#    - githubtakeout (pipx install)
#    - google_drive_export (pipx install)
#    - java (apt install)
#    - pyenv (https://github.com/pyenv/pyenv)
#    - rustup (https://rustup.rs)
#    - rsync (apt install)
#
#  - windows only:
#    - alacritty (scoop install)


set -e

DOTFILES_HOME="${HOME}/code/dotfiles"
BIN_DIR="${HOME}/bin"
PANDOC_TEMPLATE_DIR="${HOME}/.pandoc"
ALACRITTY_CONFIG_DIR="${APPDATA}/alacritty"
REQUIREMENTS=(
    "git"
    "curl"
)
DEPENDENCIES=(
    "bat"
    "eza"
    "fd"
    "gh"
    "jq"
    "pandoc"
    "pipx"
    "pyupgrade"
    "refurb"
    "rg"
    "ruby"
    "shellcheck"
    "subl"
)
DEPENDENCIES_LINUX=(
    "cargo-cache"
    "exiv2"
    "githubtakeout"
    "google_drive_export"
    "java"
    "pyenv"
    "rsync"
    "rustup"
)
DEPENDENCIES_WINDOWS=(
    "alacritty"
)
CONFIGS=(
    ".bashrc"
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
ALACRITTY_CONFIGS=(
    "./alacritty/alacritty.toml"
)
PANDOC_TEMPLATES=(
    "./pandoc/template.html"
    "./pandoc/template.css"
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
    "./bin/now"
    "./bin/sysinfo"
    "./bin/test-nas-data-xfer"
)
GIT_SCRIPTS=(
    "git-clean-untracked"
    "git-info"
    "git-obliterate-repo"
    "git-prs"
    "git-score"
    "git-stat"
    "git-sync"
    "git-syncrepo"
    "git-track-branches"
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
        if [ ! -x "$(type -pP ${prog})" ]; then
            err "${prog} is not installed"
            check_failed="true"
        else
            ok "${prog} is installed"
        fi
    done
}


check-requirements () {
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
    if [[ "${OSTYPE}" == "msys"* ]]; then
        check-programs "${DEPENDENCIES_WINDOWS[@]}"
        if [ -n "${check_failed}" ]; then
            check_win_deps_failed="true"
        fi
    fi
}


if [ ! -d "${DOTFILES_HOME}" ]; then
    die "fatal: can't find local dotfiles repo"
fi

check-requirements
check-dependencies
echo

mkdir --parents "${BIN_DIR}"
mkdir --parents "${PANDOC_TEMPLATE_DIR}"
mkdir --parents "${ALACRITTY_CONFIG_DIR}"

cd "${DOTFILES_HOME}"

current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's/.*\///')

echo "syncing local branches in ${DOTFILES_HOME} ..."
git sync
echo
git checkout "${default_branch}" >/dev/null 2>&1

echo "updating local configs and scripts from github ..."
echo

if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux configs from dotfiles repo ${default_branch} branch to ${HOME}"
    for config in "${LINUX_CONFIGS[@]}"; do
        echo -e "  copying: ${config}"
        cp "${config}" "${HOME}"
    done
    echo "copying linux scripts from dotfiles repo ${default_branch} branch to ${BIN_DIR}"
    for script in "${LINUX_SCRIPTS[@]}"; do
        echo -e "  copying: ${script}"
        cp "${script}" "${BIN_DIR}"
    done
elif [[ "${OSTYPE}" == "msys" ]]; then
    echo "copying windows configs from dotfiles repo ${default_branch} branch to ${HOME}"
    for config in "${WIN_CONFIGS[@]}"; do
        echo -e "  copying: ${config}"
        cp "${config}" "${HOME}"
    done
    echo "copying alacritty configs from dotfiles repo ${default_branch} branch to ${ALACRITTY_CONFIG_DIR}"
    for config in "${ALACRITTY_CONFIGS[@]}"; do
        echo -e "  copying: ${template}"
        cp "${config}" "${ALACRITTY_CONFIG_DIR}"
    done
fi

echo "copying configs from dotfiles repo ${default_branch} branch to ${HOME}"
for config in "${CONFIGS[@]}"; do
    echo -e "  copying: ${config}"
    cp "${config}" "${HOME}"
done

echo "copying pandoc templates from dotfiles repo ${default_branch} branch to ${PANDOC_TEMPLATE_DIR}"
for template in "${PANDOC_TEMPLATES[@]}"; do
    echo -e "  copying: ${template}"
    cp "${template}" "${PANDOC_TEMPLATE_DIR}"
done

echo "copying scripts from dotfiles repo ${default_branch} branch to ${BIN_DIR}"
for script in "${SCRIPTS[@]}"; do
    echo -e "  copying: ${script}"
    cp "${script}" "${BIN_DIR}"
done

git checkout "${current_branch}" >/dev/null 2>&1

echo "downloading git scripts from github to ${BIN_DIR}"
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
if [ -n "${check_deps_failed}" ] || [ -n "${check_linux_deps_failed}" ] || [ -n "${check_win_deps_failed}" ]; then
    err "missing dependency"
fi
ok "done updating configs and scripts"
