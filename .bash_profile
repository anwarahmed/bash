#!/bin/bash

if [ -f ~/.config/bash/.bashrc ] then
  . ~/.config/bash/.bashrc
elif [ -f ~/.bashrc ] then
  . ~/.bashrc
fi
