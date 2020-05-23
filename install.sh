#!/bin/bash

ln -sf $PWD/.alias ~/.alias
ln -sf $PWD/.hgrc ~/.hgrc
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.toprc ~/.toprc
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.screenrc ~/.screenrc
ln -sf $PWD/.tmux.conf ~/.tmux.conf
ln -sf $PWD/.gitconfig ~/.gitconfig
ln -sf $PWD/.valgrindrc ~/.valgrindrc

mkdir -p ~/.i3
ln -sf $PWD/.i3-config ~/.i3/config

mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Created links. Now you can change the configuration files as required or use the defaults."
echo "Notable files to be changed: .gitconfig .hgrc .vimrc .alias .bashrc"
echo -n "Modify the configuration files? (y/n) "
read -n 1 ans
if [ "$ans" = "y" -o "$ans" = "Y" ]; then
    vim .hgrc
    vim .vimrc
    vim .bashrc
    vim .gitconfig
fi
