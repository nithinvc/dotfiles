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

# Install gh
conda install gh --channel conda-forge -y

# Install tmux
sudo apt install tmux -y
# There's an issue with ghostty's terminfo not proping since it's new
# This actually is not a sufficient fix since you still need to source .bashrc
echo 'export TERM="xterm-256color"' >> ~/.bashrc
echo 'alias update_term="export TERM=xterm-256color"' >> ~/.bashrc

# init.lua
cd ~/.config/
git clone https://github.com/nithinvc/init.lua
mv init.lua nvim
cd nvim
./configure_tmux.sh


source ~/.bashrc

# Python environment setup (eventually to abstract out)
pip install ipython ipdb gpustat ruff graphviz
pip install torch torchvision torchaudio
pip install fire ruff open_clip_torch 
