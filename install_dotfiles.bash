#!/usr/bin/env bash


for FILE in .bashrc .bash_aliases .gitconfig
do
    cp ~/$FILE ~/$FILE.old
    cp ~/code/dotfiles/$FILE ~/$FILE
done
