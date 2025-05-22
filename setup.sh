#!/bin/bash


# Local config
if [ -d ~/.config/ ]; then
    mkdir ~/.config/
fi

# If on mac, make sure brew exists
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    if command -v brew &> /dev/null; then
        echo "Found brew!"
    else
        echo "Brew not found! Please install brew before running."
        exit 1
    fi
fi

# Update apt
sudo apt update

# Prereqs for neovim plugins
sudo apt install gcc make ripgrep graphviz -y

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
echo 'alias vim="nvim"' >> ~/.bashrc

# Dumb shortcuts I like
echo 'alias ll="ls -la"' >> ~/.bashrc
echo 'alias l="ls -l"' >> ~/.bashrc
echo 'alias u="cd .."' >> ~/.bashrc
echo 'alias uu="cd ../../"' >> ~/.bashrc
echo 'alias uuu="cd ../../../"' >> ~/.bashrc

# Install gh NOTE: Theoretically this should be sufficient but it ran into deps issues?
# conda install gh --channel conda-forge -y
# Using this linux install instead

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y


# Install tmux
sudo apt install tmux -y
# There's an issue with ghostty's terminfo not proping since it's new
# This actually is not a sufficient fix since you still need to source .bashrc
echo 'export TERM="xterm-256color"' >> ~/.bashrc
echo 'alias update_term="export TERM=xterm-256color"' >> ~/.bashrc

# init.lua
git clone https://github.com/nithinvc/init.lua
mv init.lua ~/.config/nvim
~/.config/configure_tmux.sh


source ~/.bashrc
