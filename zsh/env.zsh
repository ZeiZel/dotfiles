# ============================================
# ENVIRONMENT VARIABLES
# ============================================

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Homebrew (platform-specific, no subshell)
if [[ -d "/opt/homebrew" ]]; then
  # Apple Silicon Mac
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local/Homebrew" ]]; then
  # Intel Mac
  export HOMEBREW_PREFIX="/usr/local"
elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  # Linux
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"
fi

# Core PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Java
[[ -d "/usr/local/opt/openjdk/bin" ]] && export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# NVM
# Load the default nvm version eagerly so node/npm/npx and npm globals all
# resolve from the same prefix. This keeps Codex updates consistent and avoids
# Homebrew node/npm taking precedence in non-interactive shells.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  \. "$NVM_DIR/nvm.sh"
  nvm use --silent default >/dev/null 2>&1 || true
fi

# Go
export GOPATH="$HOME/go"
[[ -d "$GOPATH" ]] && export PATH="$GOPATH/bin:$PATH"

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"

# Starship config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# History configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# Performance flags
DISABLE_MAGIC_FUNCTIONS=true
COMPLETION_WAITING_DOTS=false
ZSH_DISABLE_COMPFIX=true

# Less pager
export LESS='-R --use-color -Dd+r$Du+b'
export LESSHISTFILE=-

# GPG
export GPG_TTY=$(tty)
