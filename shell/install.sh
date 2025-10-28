#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Zsh / shell setup"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"

# symlink zsh configs
ln -sf "${REPO_DIR}/shell/.zshrc"    "${HOME_DIR}/.zshrc"
[[ -f "${REPO_DIR}/shell/.p10k.zsh" ]] && ln -sf "${REPO_DIR}/shell/.p10k.zsh" "${HOME_DIR}/.p10k.zsh"

# git configs
[[ -f "${REPO_DIR}/.gitconfig"  ]] && cp -f "${REPO_DIR}/.gitconfig"  "${HOME_DIR}/.gitconfig"
[[ -f "${REPO_DIR}/.gitmessage" ]] && cp -f "${REPO_DIR}/.gitmessage" "${HOME_DIR}/.gitmessage"

# Oh My Zsh (unattended)
if [[ ! -d "${HOME_DIR}/.oh-my-zsh" ]]; then
  export RUNZSH=no CHSH=no
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended
fi

# p10k theme + plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME_DIR}/.oh-my-zsh/custom}"
[[ -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k "${ZSH_CUSTOM}/themes/powerlevel10k"
[[ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]] || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
[[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# patch ~/.zshrc
grep -qE '^\s*export\s+ZSH=' "${HOME_DIR}/.zshrc" || echo 'export ZSH="$HOME/.oh-my-zsh"' >> "${HOME_DIR}/.zshrc"
if grep -qE '^\s*ZSH_THEME=' "${HOME_DIR}/.zshrc"; then
  sed -i 's|^\s*ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "${HOME_DIR}/.zshrc"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "${HOME_DIR}/.zshrc"
fi
grep -q 'oh-my-zsh\.sh' "${HOME_DIR}/.zshrc" || echo 'source "$ZSH/oh-my-zsh.sh"' >> "${HOME_DIR}/.zshrc"
grep -q '\.p10k\.zsh'   "${HOME_DIR}/.zshrc" || echo '[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"' >> "${HOME_DIR}/.zshrc"

echo "✅ Shell setup complete."
