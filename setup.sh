#!/usr/bin/env bash
stow .

# Link the .zshenv_root to ~/.zshenv so that zsh can find the config
# files in ~/.config/zsh/
ln -sf ~/.config/zsh/.zshenv_root ~/.zshenv

