#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Zsh / shell setup"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"

# --- 0) Helpers --------------------------------------------------------------
append_once_block() {
  # append a block demarcated by markers to a file exactly once
  local file="$1"; local start_mark="$2"; local end_mark="$3"; local content_file="$4"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if ! grep -qF "$start_mark" "$file"; then
    {
      echo ""
      echo "$start_mark"
      cat "$content_file"
      echo "$end_mark"
    } >> "$file"
  fi
}

copy_with_backup () {
  local src="$1"; local dst="$2"
  if [[ -f "$src" ]]; then
    if [[ -f "$dst" && ! -L "$dst" ]]; then
      cp -f "$dst" "${dst}.bak.$(date +%s)"
      echo "  Backed up $dst → ${dst}.bak.*"
    fi
    cp -f "$src" "$dst"
    echo "  Copied $(basename "$src") → $(basename "$dst")"
  fi
}

# --- 1) Link zsh config files ------------------------------------------------
echo "→ Linking zsh configs"
ln -sf "${REPO_DIR}/shell/.zshrc"    "${HOME_DIR}/.zshrc"
if [[ -f "${REPO_DIR}/shell/.p10k.zsh" ]]; then
  ln -sf "${REPO_DIR}/shell/.p10k.zsh" "${HOME_DIR}/.p10k.zsh"
fi

# --- 2) Append bashrc additions (idempotent) --------------------------------
if [[ -f "${REPO_DIR}/bashrc.additions" ]]; then
  echo "→ Appending bashrc additions to ~/.bashrc (idempotent)"
  append_once_block \
    "${HOME_DIR}/.bashrc" \
    "# >>> dotfiles additions >>>" \
    "# <<< dotfiles additions <<<" \
    "${REPO_DIR}/bashrc.additions"
fi

# --- 3) Git config & commit template ----------------------------------------
echo "→ Installing git config (with backups if needed)"
copy_with_backup "${REPO_DIR}/.gitconfig"  "${HOME_DIR}/.gitconfig"
copy_with_backup "${REPO_DIR}/.gitmessage" "${HOME_DIR}/.gitmessage"

# --- 4) Install Oh My Zsh (unattended) --------------------------------------
if [[ ! -d "${HOME_DIR}/.oh-my-zsh" ]]; then
  echo "→ Installing Oh My Zsh (unattended)"
  export RUNZSH="no"
  export CHSH="no"
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended
else
  echo "  (Oh My Zsh already present)"
fi

# --- 5) Install plugins ------------------------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME_DIR}/.oh-my-zsh/custom}"
echo "→ Ensuring zsh plugins"
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# --- 6) Install theme: powerlevel10k ----------------------------------------
echo "→ Ensuring powerlevel10k theme"
if [[ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
fi

# --- 7) Ensure ~/.zshrc loads OMZ, p10k, and plugins ------------------------
echo "→ Patching ~/.zshrc (theme, OMZ, plugins)"
# Ensure export ZSH
grep -qE '^\s*export\s+ZSH=' "${HOME_DIR}/.zshrc" || \
  printf 'export ZSH="$HOME/.oh-my-zsh"\n' >> "${HOME_DIR}/.zshrc"

# Ensure ZSH_THEME is p10k
if grep -qE '^\s*ZSH_THEME=' "${HOME_DIR}/.zshrc"; then
  sed -i 's|^\s*ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "${HOME_DIR}/.zshrc"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "${HOME_DIR}/.zshrc"
fi

# Ensure OMZ sourced
grep -q 'oh-my-zsh\.sh' "${HOME_DIR}/.zshrc" || \
  echo 'source "$ZSH/oh-my-zsh.sh"' >> "${HOME_DIR}/.zshrc"

# Ensure p10k config is sourced (if present)
grep -q '\.p10k\.zsh' "${HOME_DIR}/.zshrc" || \
  echo '[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"' >> "${HOME_DIR}/.zshrc"

# Ensure plugins include our two (replace or add a line)
if grep -q '^plugins=(' "${HOME_DIR}/.zshrc"; then
  sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "${HOME_DIR}/.zshrc" || true
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "${HOME_DIR}/.zshrc"
fi

# --- 8) Optional: set login shell to zsh (safe in devcontainers) ------------
if command -v chsh >/dev/null 2>&1 && [[ -x /usr/bin/zsh ]]; then
  if [[ "${SHELL:-}" != "/usr/bin/zsh" ]]; then
    echo "→ Setting login shell to zsh (optional)"
    chsh -s /usr/bin/zsh || true
  fi
fi

echo "✅ Shell setup complete. Open a new terminal (or exec zsh -l)."
echo "ℹ️ For pretty glyphs, set a Nerd/Powerline font in VS Code: 'MesloLGS NF' in terminal.integrated.fontFamily."
