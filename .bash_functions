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
