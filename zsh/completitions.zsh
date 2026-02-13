# ============================================
# ZSH COMPLETION STYLING
# Note: compinit is handled by zinit in plugins.zsh
# ============================================

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

# Use tmux popup if in tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# FZF-tab bindings
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
zstyle ':fzf-tab:*' accept-line enter

# ============================================
# LAZY-LOADED COMPLETIONS
# Load completions only when needed
# ============================================

# Kubectl - lazy load
kubectl() {
  unfunction kubectl
  source <(command kubectl completion zsh)
  command kubectl "$@"
}

# Helm - lazy load
helm() {
  unfunction helm
  source <(command helm completion zsh)
  command helm "$@"
}

# gh CLI - lazy load
gh() {
  unfunction gh
  eval "$(command gh completion -s zsh)"
  command gh "$@"
}
