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
git clone --depth 1 --filter=blob:none --sparse https://github.com/tonisives/tools.git
cd tools
git sparse-checkout set shell-setup/scripts

cp shell-setup/scripts/.* ~/ 2>/dev/null || true
cp shell-setup/scripts/* ~/ 2>/dev/null || true
cd ~
rm -rf tools

echo "Sourcing new .bash_profile..."
source ~/.bash_profile

echo "Installation complete!"
