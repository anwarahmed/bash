#!/bin/bash

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Custom aliases
source ~/.config/bash/.bash_aliases

# Custom functions
source ~/.config/bash/.bash_functions

# NVM
source /usr/share/nvm/init-nvm.sh

# Bash history
export HISTTIMEFORMAT='%F %T - '             # History format
export HISTFILE=~/.config/bash/.bash_history # History file
