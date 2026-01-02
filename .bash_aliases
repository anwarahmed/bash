#!/bin/bash

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Git
alias ga='git add'
alias ga.='git add . && git status'
alias gb='git branch'
alias gbd='git branch -D'
alias gbr='git branch --remote'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git_checkout_main_or_master > /dev/null'
alias gd='git diff'
alias gf='git fetch'
alias gfp='git fetch -p'
alias gl='git log'
alias gpl='git pull'
alias gpsh='git push'
alias gr='git remote'
alias gs='git status'
alias gwt='git worktree'

# Alias for 'la -la'
alias la='ls -la'

# Alias command 'psc' to show running processes sorted by CPU usage
alias psc="ps uc --sort=-%cpu"

# Alias command 'psm' to show running processes sorted by memory usage
alias psm="ps uc --sort=-%mem"

# Alias command 'psp' to show unique rnnning processes sorted by name
alias psp="ps co comm | sort | uniq"

# Alias command 'cm' to run cmatrix
alias cm="cmatrix -abu 3"

# Alias command 'mx' to run unimatrix, timing out after 15 minutes
alias mx="unimatrix -a -b -f -s 95 -t 900"

# Alias command 'lw' to run live-wallpaper-toggle
alias lw="live-wallpaper-toggle"

# Alias command 'crt' to run cool-retro-term in the background
alias crt="(cool-retro-term > /dev/null 2>&1 &)"
