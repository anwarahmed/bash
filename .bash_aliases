#!/bin/bash

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Git
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gr='git remote'
alias gs='git status'
alias gco='git checkout'
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

# Alias command 'mx' to run unimatrix
alias mx="unimatrix -a -b -f -s 95"
