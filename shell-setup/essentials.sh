#!/bin/bash

# curl -O https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/essentials.sh && bash ./essentials.sh && source ~/.bash_profile

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
    ncdu \
    locales

echo "Configuring locales..."
echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo "Cloning scripts and configs"
git clone --depth 1 --filter=blob:none --sparse https://github.com/tonisives/tools.git
cd tools
git sparse-checkout set shell-setup
cp -r shell-setup/* ~
cp -r shell-setup/.* ~
cd ~
rm -rf tools

echo "Sourcing new .bash_profile..."
source ~/.bash_profile

echo "Installation complete!"
