# Initialize completion system
autoload -Uz compinit
compinit

# Kubectl completion
command -v kubectl >/dev/null 2 >&1 && source <(kubectl completion zsh)

# Angular CLI completion
command -v ng >/dev/null 2 >&1 && source <(ng completion script)

# Docker completion
fpath=(~/.docker/completions $fpath 2 > /dev/null)

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
