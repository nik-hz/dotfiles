#!/usr/bin/env sh

set -e

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'


mkdir -p "$HOME/.oh-my-zsh/custom/themes"
git clone --depth=1 https://github.com/romkatv/powerlevel10k \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"


echo "🚀 zsh installation"
ln -sf "${PWD}/shell/.zshrc" "${HOME}/.zshrc"

echo "🚀 p10k installation"
ln -sf "${PWD}/shell/.p10k.zsh" "${HOME}/.p10k.zsh"

echo "🚀 history config installation"
ln -sf "${PWD}/shell/.zsh_history_config" "${HOME}/.zsh_history_config"
