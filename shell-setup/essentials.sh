#!/bin/bash

# curl -O https://raw.githubusercontent.com/tonisives/tools/refs/heads/master/shell-setup/essentials.sh && bash ./essentials.sh && source ~/.bash_profile

# Detect package manager
if command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="apt-get"
    INSTALL_CMD="apt-get install -y"
    UPDATE_CMD="apt-get update"
elif command -v apk >/dev/null 2>&1; then
    PKG_MANAGER="apk"
    INSTALL_CMD="apk add"
    UPDATE_CMD="apk update"
elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="yum"
    INSTALL_CMD="yum install -y"
    UPDATE_CMD="yum update"
else
    echo "No supported package manager found (apt-get, apk, yum)"
    PKG_MANAGER="none"
fi

# Check if sudo is available
if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

# Update package list
if [ "$PKG_MANAGER" != "none" ]; then
    echo "Updating package list..."
    $SUDO $UPDATE_CMD

    # Install essential tools
    echo "Installing essential tools..."
    if [ "$PKG_MANAGER" = "apk" ]; then
        $SUDO $INSTALL_CMD fzf vim tmux git curl htop tree ncdu
    else
        $SUDO $INSTALL_CMD fzf vim tmux git curl htop tree ncdu locales
    fi
fi

# Configure locales (skip for Alpine as it doesn't use glibc)
if [ "$PKG_MANAGER" = "apt-get" ]; then
    echo "Configuring locales..."
    echo "en_US.UTF-8 UTF-8" | $SUDO tee -a /etc/locale.gen
    $SUDO locale-gen
    $SUDO update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
fi

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
