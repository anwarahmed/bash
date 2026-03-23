#!/bin/bash

# Add custom functions here

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Function to print date, time, and current working directory
function info() {
  # Print the current date and time
  echo -e "\e[35m➜  \e[32m\uf455 \e[2;34m$(date "+%-d %B %Y")\e[0m"
  echo -e "\e[35m➜  \e[32m\uf017 \e[2;34m$(date "+%-I:%M:%S %p")\e[0m"

  # Print the current working directory
  echo -e "\e[35m➜  \e[32m\uf120 \e[2;34m$PWD\e[0m"
}

# Function to clear the terminal and print info
function cli() {
  clear
  info
}

# Function to checkout the main or master branch
function git_checkout_main_or_master() {
  if git show-ref -q --heads main; then
    git checkout main
  else
    git checkout master
  fi
}

# clear-system-cache
# Frees up disk space by purging package caches and orphaned packages,
# clearing the user cache directory, then listing Snapper snapshots.
#
# Steps performed:
#   1. pacman -Scc  — removes all cached package tarballs (official repos)
#   2. pacman -Rns  — uninstalls orphaned packages and their config files
#   3. yay -Scc     — removes all cached AUR package tarballs
#   4. yay -Rns     — uninstalls orphaned AUR packages and their config files
#   5. rm ~/.cache  — deletes all user-level cached application data
#   6. snapper list — shows existing Btrfs snapshots so you can prune them
#                     manually with: sudo snapper delete <#>
#
# Requirements: pacman, yay (AUR helper), snapper, sudo privileges
function clear-system-cache() {
  # Clear official repo package cache (all versions, not just uninstalled)
  sudo pacman -Scc --noconfirm --needed

  # Remove orphaned packages (no longer required by any installed package)
  sudo pacman -Rns $(pacman -Qdtq) --noconfirm --needed

  # Clear AUR package cache
  yay -Scc --noconfirm --needed

  # Remove orphaned AUR packages
  yay -Rns $(yay -Qdtq) --noconfirm --needed

  # Wipe user application cache (~/.cache)
  rm -rf ~/.cache/*

  echo
  echo "Snapshots:"
  sudo snapper list
  echo
  echo "To delete single:  sudo snapper delete <#>"
  echo "To delete range:   sudo snapper delete <#>-<#>"
}
