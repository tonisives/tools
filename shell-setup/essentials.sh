#!/bin/bash

# install-env.sh

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

# Create .bash_profile
echo "Creating .bash_profile..."
cat > ~/.bash_profile << 'EOL'
# Vi mode in bash
set -o vi

# Source fzf key bindings if they exist
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Some useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Enhanced command prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# FZF settings
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='find . -type f'
EOL

# Source the new .bash_profile
echo "Sourcing .bash_profile..."
source ~/.bash_profile

# Create basic .vimrc
echo "Creating .vimrc..."
cat > ~/.vimrc << 'EOL'
syntax on
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set incsearch
set hlsearch
EOL

echo "Installation complete!"