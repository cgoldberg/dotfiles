#!/usr/bin/env bash
# dotfiles installer for cgoldberg


BIN="$HOME/bin"
DIR="$(realpath .)"

FILES=(
    ".bashrc"
    ".bash_aliases"
    ".gitconfig"
    "bin/backup_world"
    "bin/git-info"
    "bin/git-score"
    "bin/gphoto_clean_exported_library.py"
    "bin/img_metadata_strip_fix.py"
    "bin/now.sh"
    "bin/prettyping"
    "bin/squeezebox-upgrade"
)

if [ ! -d "$BIN" ]; then
    echo
    echo "creating directory: $BIN"
    mkdir "$BIN"
fi

echo
echo "fetching screenfetch-ubuntu"
wget -nv "https://raw.githubusercontent.com/cgoldberg/screenfetch-ubuntu/master/screenfetch-ubuntu" -O "$HOME/bin/screenfetch-ubuntu"
chmod +x "$HOME/bin/screenfetch-ubuntu"

echo
echo "fetching audio_tag.py"
wget -nv "https://raw.githubusercontent.com/cgoldberg/audiotools/master/audio_tag.py" -O "$HOME/bin/audio_tag.py"
chmod +x "$HOME/bin/audio_tag.py"

echo
echo "fetching git-prompt.sh"
wget -nv "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" -O "$HOME/bin/git-prompt.sh"
chmod +x "$HOME/bin/git-prompt.sh"

echo
echo "fetching git-completion.bash"
wget -nv "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" -O "$HOME/bin/git-completion.bash"
chmod +x "$HOME/bin/git-completion.bash"

for FILE in "${FILES[@]}"; do
    if [ -f "$HOME/$FILE" ]; then
        echo
        echo "backing up $HOME/$FILE to $HOME/$FILE.old"
        cp "$HOME/$FILE" "$HOME/$FILE.old"
    fi
    echo "copying $DIR/$FILE to $HOME/$FILE"
    cp "$DIR/$FILE" "$HOME/$FILE"
done

echo
echo "done"
