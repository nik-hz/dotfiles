#!/usr/bin/env sh

set -e

echo "🚀 zsh installation"
ln -sf "${PWD}/shell/.zshrc" "${HOME}/.zshrc"

echo "🚀 p10k installation"
ln -sf "${PWD}/shell/.p10k.zsh" "${HOME}/.p10k.zsh"
