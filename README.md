# Dotfiles

Personal configuration files for zsh, vim, and tmux.

## Installation

```bash
git clone https://github.com/nik-hz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Structure

```
dotfiles/
├── install.sh          # Main installer (runs all component installers)
├── shell/
│   ├── install.sh      # Installs oh-my-zsh, plugins, and symlinks
│   ├── .zshrc          # Zsh configuration
│   ├── .p10k.zsh       # Powerlevel10k theme config
│   └── .zsh_history_config  # History settings for devcontainers
├── vim/
│   ├── install.sh      # Symlinks vimrc and installs plugins
│   └── .vimrc          # Vim configuration
└── tmux/
    ├── install.sh      # Symlinks tmux config
    └── .tmux.conf      # Tmux configuration
```

## Components

### Shell (Zsh)

- **Oh My Zsh** with Powerlevel10k theme
- **Plugins**: git, python, pip, zsh-autosuggestions, zsh-syntax-highlighting
- **Aliases**: `ll`, `gs`, `gd`, `gp`, `v`, `py`
- **Features**: Conda integration, virtualenv indicator

#### Devcontainer History

For persistent shell history in devcontainers, mount a volume at `/history`:

```json
"mounts": [
  "source=projectname-history,target=/history,type=volume"
]
```

History config (100k lines, shared/appended) is automatically loaded when `/history` exists.

### Vim

- Line numbers, syntax highlighting
- Smart indentation (4 spaces)
- Incremental search with smart case
- Auto-closing brackets `{}`, `()`, `[]`
- Wildmenu with bash-like completion
- Scroll offset of 10 lines

### Tmux

- Mouse support enabled
- Default shell set to zsh
- Quick reload with `prefix + r`

## Requirements

- zsh
- git
- wget
- vim (with plugin manager for `:PlugInstall`)
- tmux
