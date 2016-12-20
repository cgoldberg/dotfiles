#!/usr/bin/env bash

BIN="$HOME/bin"
DIR="$(realpath .)"

FILES=(
    ".bashrc"
    ".bash_aliases"
    ".gitconfig"
    "bin/audio_meta_tag.py"
    "bin/backup_world"
    "bin/git-score"
    "bin/gphoto_remove_jsons.py"
    "bin/img_metadata_strip_fix.py"
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
    echo
    echo "copying $DIR/$FILE to $HOME/$FILE"
    cp "$DIR/$FILE" "$HOME/$FILE"
    chmod +x "$HOME/$FILE"
done

echo
echo "sourcing ~/.bashrc"
source "$HOME/.bashrc"

echo
echo "done"
