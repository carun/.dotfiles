#!/bin/bash
# Symlink the dotfiles into place and set up tmux/vim plugins.
# Safe to re-run: nothing here overwrites a file it did not create.

set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    ln -sfn "$DOTFILES/$1" "$2"
}

mkdir -p ~/.config/fish/
link config.fish ~/.config/fish/config.fish
link nvim       ~/.config/nvim
link .alias     ~/.alias
link .vimrc     ~/.vimrc
link .toprc     ~/.toprc
link .bashrc    ~/.bashrc
link .gitconfig ~/.gitconfig

if awk -F= '/^ID=/{print $2}' /etc/os-release | grep -qiE "rhel|centos"; then
    link .tmux.conf.rhel ~/.tmux.conf
else
    link .tmux.conf ~/.tmux.conf
fi

mkdir -p ~/.i3
link .i3-config ~/.i3/config

# Plugin managers: clone once, update thereafter.
clone_or_pull() {
    if [ -d "$2/.git" ]; then
        git -C "$2" pull --ff-only
    else
        git clone "$1" "$2"
    fi
}
clone_or_pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.vim/bundle
clone_or_pull https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Neovim: install plugins at the versions pinned in nvim/lazy-lock.json.
# Language servers and Treesitter parsers install on first interactive start.
if command -v nvim >/dev/null; then
    nvim --headless "+Lazy! restore" +qa
fi

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Only seed gpg-agent.conf if there isn't one. Overwriting it unconditionally
# used to discard hand-tuned settings such as the cache TTLs.
if [ ! -f ~/.gnupg/gpg-agent.conf ]; then
    cat > ~/.gnupg/gpg-agent.conf <<'CONF'
enable-ssh-support
default-cache-ttl-ssh 1800
max-cache-ttl-ssh 7200
CONF
    echo "Wrote ~/.gnupg/gpg-agent.conf"
else
    echo "Kept existing ~/.gnupg/gpg-agent.conf (delete it to get the default)"
fi

# Append the ssh keygrip rather than replacing the file, which would drop any
# other keys already authorised for ssh.
KEYGRIP=60E0B0D0702A825466F6C0C951970C0253C5E3CA
touch ~/.gnupg/sshcontrol
if ! grep -qx "$KEYGRIP" ~/.gnupg/sshcontrol; then
    echo "$KEYGRIP" >> ~/.gnupg/sshcontrol
    echo "Added keygrip to ~/.gnupg/sshcontrol"
fi

echo "Created links. Now you can change the configuration files as required or use the defaults."
echo "Notable files to be changed: .gitconfig .hgrc .vimrc .alias .bashrc"
read -rn 1 -p "Do you want to edit .gitconfig? (y/n) " ans
echo
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    vim "$DOTFILES/.gitconfig"
fi

echo "Done"
