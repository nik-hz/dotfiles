#!/usr/bin/env sh

set -e

echo "🚀 tmux configuration"

ln -sf "${PWD}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
