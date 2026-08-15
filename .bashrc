#!/bin/bash

# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "${OMARCHY_PATH:-/usr/share/omarchy}/default/bash/rc"

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Custom aliases
source ~/.config/bash/.bash_aliases

# Custom functions
source ~/.config/bash/.bash_functions

# NVM
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# Bash history
export HISTTIMEFORMAT='%F %T - '             # History format
export HISTFILE=~/.config/bash/.bash_history # History file

# Goodbye message
trap '[ -f ~/.config/bash/.bash_goodbye_message ] && source ~/.config/bash/.bash_goodbye_message' EXIT

# Welcome message (clear the screen and print date, time, and cwd)
cli
