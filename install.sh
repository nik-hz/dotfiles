#!/usr/bin/env sh 

set -e

###
# Installation
###
# 1) Install Oh My Zsh (unattended)
if [ ! -d "$ZSH_DIR" ]; then
  # prevent the script from switching shells or starting zsh
  RUNZSH=no CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 2) Install Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
fi

sh ./shell/install.sh
sh ./vim/install.sh
sh ./tmux/install.sh
