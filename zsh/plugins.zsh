# ============================================
# ZSH PLUGINS
# ============================================
# Plugins are installed as versioned Homebrew formulae. This avoids network
# access, self-installation, and deferred keymap changes during shell startup.

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  _fzf_tab="$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
  [[ -r "$_fzf_tab" ]] && source "$_fzf_tab"

  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  _autosuggestions="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$_autosuggestions" ]] && source "$_autosuggestions"

  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]="fg=#cdd6f4"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#f38ba8"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=#cba6f7"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=#94e2d5"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=#a6e3a1"
  ZSH_HIGHLIGHT_STYLES[function]="fg=#89b4fa"
  ZSH_HIGHLIGHT_STYLES[command]="fg=#a6e3a1"
  ZSH_HIGHLIGHT_STYLES[precommand]="fg=#a6e3a1,italic"
  ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#f38ba8"
  ZSH_HIGHLIGHT_STYLES[path]="fg=#f9e2af,underline"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#a6e3a1"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#a6e3a1"
  ZSH_HIGHLIGHT_STYLES[comment]="fg=#6c7086"
  _syntax_highlighting="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$_syntax_highlighting" ]] && source "$_syntax_highlighting"

  unset _autosuggestions _fzf_tab _syntax_highlighting
fi
