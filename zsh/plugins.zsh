# ============================================
# ZINIT - Fast Plugin Manager (Turbo Mode)
# ============================================

# Install zinit if not present (silent)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" &>/dev/null
fi

# Load zinit (silent)
source "${ZINIT_HOME}/zinit.zsh"

# Disable zinit messages
ZINIT[MUTE_WARNINGS]=1

# ============================================
# ANNEXES (load first, silent)
# ============================================
zinit light-mode for \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl

# ============================================
# CORE PLUGINS - Turbo Mode (deferred loading)
# ============================================

# Completions - load early but async
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
  blockf \
  zsh-users/zsh-completions

# FZF-tab - must load after compinit
zinit wait lucid light-mode for \
  Aloxaf/fzf-tab

# Syntax highlighting - load async
zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]}=-C; zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting

# Autosuggestions - load async with config
zinit wait lucid light-mode for \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

# History substring search
zinit wait lucid light-mode for \
  zsh-users/zsh-history-substring-search

# ============================================
# PRODUCTIVITY PLUGINS - Deferred
# ============================================

zinit wait"1" lucid light-mode for \
  hlissner/zsh-autopair \
  hcgraf/zsh-sudo \
  MichaelAquilina/zsh-you-should-use

# ============================================
# OMZ SNIPPETS - Deferred
# ============================================

zinit wait"1" lucid for \
  OMZP::git \
  OMZP::extract \
  OMZP::colored-man-pages \
  OMZP::safe-paste

zinit wait"2" lucid for \
  OMZP::docker \
  OMZP::docker-compose \
  OMZP::kubectl \
  OMZP::terraform

# ============================================
# PLUGIN CONFIGURATIONS
# ============================================

# Autosuggestions config
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# You Should Use config
export YSU_MESSAGE_POSITION="after"

# Syntax highlighting - Catppuccin (applied when plugin loads)
zinit wait lucid atload'
  typeset -gA FAST_HIGHLIGHT_STYLES
  FAST_HIGHLIGHT_STYLES[default]="fg=#cdd6f4"
  FAST_HIGHLIGHT_STYLES[unknown-token]="fg=#f38ba8"
  FAST_HIGHLIGHT_STYLES[reserved-word]="fg=#cba6f7"
  FAST_HIGHLIGHT_STYLES[alias]="fg=#94e2d5"
  FAST_HIGHLIGHT_STYLES[builtin]="fg=#a6e3a1"
  FAST_HIGHLIGHT_STYLES[function]="fg=#89b4fa"
  FAST_HIGHLIGHT_STYLES[command]="fg=#a6e3a1"
  FAST_HIGHLIGHT_STYLES[precommand]="fg=#a6e3a1,italic"
  FAST_HIGHLIGHT_STYLES[commandseparator]="fg=#f38ba8"
  FAST_HIGHLIGHT_STYLES[path]="fg=#f9e2af,underline"
  FAST_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#a6e3a1"
  FAST_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#a6e3a1"
  FAST_HIGHLIGHT_STYLES[comment]="fg=#6c7086"
' for zdharma-continuum/null
