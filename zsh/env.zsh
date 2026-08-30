# ============================================
# ENVIRONMENT VARIABLES
# ============================================

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Resolve the repository from this file, so helpers never depend on a
# hard-coded clone location.
typeset -g ZSH_CONFIG_DIR="${${(%):-%N}:A:h}"
export DOTFILES_DIR="${DOTFILES_DIR:-${ZSH_CONFIG_DIR:h}}"

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

# Keep command lookup fast and stable after re-sourcing the configuration.
# `path` is Zsh's array view of PATH; `-U` removes duplicate entries.
typeset -gU path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/bin"}
  ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/sbin"}
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)

# Optional local tool homes. Keep these in the shared environment owner so
# both interactive and non-interactive shells see them without spawning
# external commands. The later ~/.zshrc.local source may reorder or override
# them for a particular machine.
[[ -d "$HOME/.kimi-code/bin" ]] && path=("$HOME/.kimi-code/bin" $path)
[[ -d "$HOME/.mimocode/bin" ]] && path=("$HOME/.mimocode/bin" $path)
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH:+:$MANPATH}"
  export INFOPATH="$HOMEBREW_PREFIX/share/info${INFOPATH:+:$INFOPATH}"
fi

# Java
[[ -d "/usr/local/opt/openjdk/bin" ]] && export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# NVM
# Expose the installed default Node version without sourcing nvm.sh on every
# prompt. The full NVM implementation and its completion are loaded only when
# the `nvm` command is used.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  _nvm_default_version=""
  [[ -r "$NVM_DIR/alias/default" ]] &&
    _nvm_default_version="$(<"$NVM_DIR/alias/default")"

  # Resolve NVM aliases without sourcing nvm.sh. `lts/*` is a two-step alias:
  # alias/lts/* -> lts/<codename> -> the concrete installed version.
  for _nvm_alias_depth in 1 2 3; do
    if [[ "$_nvm_default_version" == lts/* ]]; then
      _nvm_alias_file="$NVM_DIR/alias/lts/${_nvm_default_version#lts/}"
    else
      _nvm_alias_file="$NVM_DIR/alias/$_nvm_default_version"
    fi
    [[ -r "$_nvm_alias_file" ]] || break
    _nvm_default_version="$(<"$_nvm_alias_file")"
  done

  if [[ "$_nvm_default_version" == "node" || "$_nvm_default_version" == "stable" ]]; then
    _nvm_node_versions=("$NVM_DIR"/versions/node/v*(NOn))
    _nvm_default_version="${_nvm_node_versions[1]:t}"
  fi

  if [[ -n "$_nvm_default_version" && -d "$NVM_DIR/versions/node/$_nvm_default_version/bin" ]]; then
    export NVM_BIN="$NVM_DIR/versions/node/$_nvm_default_version/bin"
    path=("$NVM_BIN" $path)
  fi

  _load_nvm() {
    unfunction nvm _load_nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    [[ -r "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  }

  nvm() {
    _load_nvm
    nvm "$@"
  }

  unset _nvm_alias_depth _nvm_alias_file _nvm_default_version _nvm_node_versions
fi

# Go
export GOPATH="$HOME/go"
[[ -d "$GOPATH" ]] && export PATH="$GOPATH/bin:$PATH"

# Rust
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/rustup/bin" ]]; then
  path=("$HOMEBREW_PREFIX/opt/rustup/bin" $path)
fi

# .NET SDK
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/dotnet/libexec" ]]; then
  export DOTNET_ROOT="$HOMEBREW_PREFIX/opt/dotnet/libexec"
fi

# Versioned PostgreSQL formulae are keg-only; expose the client without
# starting a database service in every environment.
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/postgresql@16/bin" ]]; then
  path=("$HOMEBREW_PREFIX/opt/postgresql@16/bin" $path)
fi

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"

# Starship config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# History configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# Less pager
export LESS='-R --use-color -Dd+r$Du+b'
export LESSHISTFILE=-

# GPG. `$TTY` is a native Zsh parameter, so this does not spawn `tty` during
# every shell startup and stays silent in non-terminal contexts.
[[ -n "$TTY" ]] && export GPG_TTY="$TTY"
