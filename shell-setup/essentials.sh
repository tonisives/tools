#!/bin/bash

# curl -O https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/essentials.sh && chmod +x essentials.sh && ./essentials.sh && source ~/.bash_profile

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install essential tools
echo "Installing essential tools..."
sudo apt-get install -y \
    fzf \
    vim \
    tmux \
    git \
    curl \
    htop \
    tree \
    ncdu

echo "Installing Docker aliases..."
curl -o ~/.docker-aliases.sh https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/docker-aliases.sh

echo "Installing .vimrc..."
curl -o ~/.vimrc https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/.vimrc

echo "Installing .bash_profile..."
curl -o ~/.bash_profile https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/.bash_profile
source ~/.bash_profile

echo "Downloading scripts"
curl -o ~/.vimrc https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/scripts

echo "Installation complete!"
