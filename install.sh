#!/bin/bash

ln -sf $PWD/.alias ~/.alias
ln -sf $PWD/.hgrc ~/.hgrc
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.toprc ~/.toprc
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.screenrc ~/.screenrc
ln -sf $PWD/.gitconfig ~/.gitconfig
ln -sf $PWD/.valgrindrc ~/.valgrindrc
ln -sf $PWD/.lcovrc ~/.lcovrc

awk -F= '/^ID=/{print $2}' /etc/os-release | /bin/grep -iE "rhel|centos" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    ln -sf $PWD/.tmux.conf.rhel ~/.tmux.conf
else
    ln -sf $PWD/.tmux.conf ~/.tmux.conf
fi

mkdir -p ~/.i3
ln -sf $PWD/.i3-config ~/.i3/config

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Created links. Now you can change the configuration files as required or use the defaults."
echo "Notable files to be changed: .gitconfig .hgrc .vimrc .alias .bashrc"
echo -n "Do you want to edit .gitconfig? (y/n) "
read -n 1 ans
if [ "$ans" = "y" -o "$ans" = "Y" ]; then
    vim .gitconfig
fi

mkdir -p ~/.bin
pushd ~/.bin > /dev/null
echo "Downloading k9s... "
curl -# -OL https://github.com/derailed/k9s/releases/download/v0.24.7/k9s_Linux_x86_64.tar.gz
echo "Downloading kubectx... "
curl -# -OL https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubectx_v0.9.3_linux_x86_64.tar.gz
echo "Downloading kubens... "
curl -# -OL https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubens_v0.9.3_linux_x86_64.tar.gz

tar xf k9s_Linux_x86_64.tar.gz
tar xf kubectx_v0.9.3_linux_x86_64.tar.gz
tar xf kubens_v0.9.3_linux_x86_64.tar.gz

rm -f k9s_Linux_x86_64.tar.gz kubectx_v0.9.3_linux_x86_64.tar.gz kubens_v0.9.3_linux_x86_64.tar.gz
popd > /dev/null

echo "Done"
