# ============================================
# INIT - Tool Initialization (Optimized)
# ============================================

# NVM bash completion (lazy - only if NVM_DIR exists)
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Local bin
[[ -s "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Atuin - better shell history (cached init)
if [[ -s "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  # Use cached init for speed
  _atuin_cache="${XDG_CACHE_HOME:-$HOME/.cache}/atuin/init.zsh"
  if [[ ! -f "$_atuin_cache" ]] || [[ "$HOME/.atuin/bin/atuin" -nt "$_atuin_cache" ]]; then
    mkdir -p "${_atuin_cache:h}"
    atuin init zsh > "$_atuin_cache"
  fi
  source "$_atuin_cache"
  unset _atuin_cache
fi

# Zoxide - smart cd (cached init)
if (( $+commands[zoxide] )); then
  _zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide/init.zsh"
  if [[ ! -f "$_zoxide_cache" ]] || [[ "$(whence -p zoxide)" -nt "$_zoxide_cache" ]]; then
    mkdir -p "${_zoxide_cache:h}"
    zoxide init zsh > "$_zoxide_cache"
  fi
  source "$_zoxide_cache"
  unset _zoxide_cache
fi
