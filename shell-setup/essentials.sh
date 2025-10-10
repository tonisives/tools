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

echo "Cloning scripts and configs"
git clone https://github.com/tonisives/tools.git .

echo "Sourcing new .bash_profile..."
source ~/.bash_profile

echo "Installation complete!"
