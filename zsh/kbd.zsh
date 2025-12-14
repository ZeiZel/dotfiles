# Vi mode bindings
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# History navigation
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Word navigation
bindkey '^[[1;5C' forward-word # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left

# Line editing
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
