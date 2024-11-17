#!/bin/bash

#Install dotfiles

# WezTerm
ln -sf ~/dotfiles/wezterm.lua ~/.wezterm.lua

# Tmux
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

# Nevim LazyVim
ln -sf ~/dotfiles/nvim ~/.config/nvim

echo "Dotfiles have been installed"
