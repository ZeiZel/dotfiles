# ============================================
# ZSH COMPLETION
# ============================================

# Homebrew and Bun ship native completion definitions. Adding their directories
# to fpath lets one cached compinit own all completion setup.
typeset -gU fpath FPATH
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] &&
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] &&
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
[[ -d "$BUN_INSTALL" ]] && fpath=("$BUN_INSTALL" $fpath)

autoload -Uz compinit
autoload -Uz _completion_loader
_zcompdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
_zcompdump_file="$_zcompdump_dir/zcompdump-$ZSH_VERSION"
[[ -d "$_zcompdump_dir" ]] || command mkdir -p "$_zcompdump_dir" 2>/dev/null

if [[ -s "$_zcompdump_file" ]]; then
  compinit -C -d "$_zcompdump_file"
else
  compinit -d "$_zcompdump_file"
fi

if [[ -s "$_zcompdump_file" &&
      ( ! -s "$_zcompdump_file.zwc" || "$_zcompdump_file" -nt "$_zcompdump_file.zwc" ) ]]; then
  zcompile "$_zcompdump_file"
fi

unset _zcompdump_dir _zcompdump_file

# Completion for the unified development entrypoint.  Route names are kept
# explicit so completion remains useful even when an optional target binary is
# not installed.  Once a route is selected, hand the remaining words to that
# command's native completer when one is available.
function _dev() {
  local route target completer
  local -a routes=(ide rest db docker git agent)
  local -a agents=(codex claude)

  if (( CURRENT == 2 )); then
    compadd -a routes
    return
  fi

  route=${words[2]}
  if [[ "$route" == agent && $CURRENT == 3 ]]; then
    compadd -a agents
    return
  fi

  case "$route" in
    ide) target=nvim ;;
    rest) target=resterm ;;
    db) target=harlequin ;;
    docker) target=lazydocker ;;
    git) target=lazygit ;;
    agent)
      target=${words[3]}
      [[ "$target" == codex || "$target" == claude ]] || return
      ;;
    *) return ;;
  esac

  # Load a completion definition lazily when the command provides one.
  _completion_loader "$target" 2>/dev/null
  completer="_${target}"
  if (( $+functions[$completer] )); then
    local -a saved_words=("${words[@]}")
    local saved_current=$CURRENT
    if [[ "$route" == agent ]]; then
      words=("$target" "${words[@]:3}")
      CURRENT=$((saved_current - 2))
    else
      words=("$target" "${words[@]:2}")
      CURRENT=$((saved_current - 1))
    fi
    "$completer"
    words=("${saved_words[@]}")
    CURRENT=$saved_current
  else
    _message "arguments for $target"
  fi
}

compdef _dev dev

# ============================================
# COMPLETION STYLING - CATPPUCCIN MOCHA
# ============================================

# Use menu selection
zstyle ':completion:*' menu select

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

# Group matches
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#cba6f7}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{#f9e2af}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format '%F{#a6e3a1}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#f38ba8}-- no matches found --%f'

# Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Directory completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Process completion
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select

# ============================================
# FZF-TAB CONFIGURATION
# ============================================

# Disable sort for git checkout
zstyle ':completion:*:git-checkout:*' sort false

# Preview for directories
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null || ls -la $realpath'

# Preview for files
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null || cat $realpath 2>/dev/null || echo $realpath'

# Switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Use a Tmux popup only when a Tmux client exists.
if [[ -n "$TMUX" ]]; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:*' popup-min-width 100
  zstyle ':fzf-tab:*' popup-pad 30 0
fi

# FZF-tab bindings
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
zstyle ':fzf-tab:*' accept-line enter
