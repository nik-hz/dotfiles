# --- Basics ---
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add common paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# --- Oh My Zsh setup ---
if [ -d "$ZSH" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"         # Clean theme w/ git info
    plugins=(git python pip)

    source $ZSH/oh-my-zsh.sh
fi

# --- Prompt tweaks ---
# Shorten path, show git branch
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Aliases ---
alias ll='ls -lh'
alias gs='git status'
alias gd='git diff'
alias gp='git pull'
alias v='vim'
alias py='python3'

# --- Python / Conda awareness ---
# If conda is installed, init it
if command -v conda >/dev/null 2>&1; then
    eval "$(conda shell.zsh hook)"
fi

# Virtualenv indicator in prompt
if [ -n "$VIRTUAL_ENV" ]; then
    PROMPT="(venv) $PROMPT"
fi

# --- Extras: autosuggestions + syntax highlighting ---
# (you can install these as plugins via oh-my-zsh or git clone them yourself)
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

