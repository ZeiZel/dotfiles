# Eza (modern ls replacement)
alias l="eza -l --icons --git -a --color=always --group-directories-first"
alias lt="eza --tree --level=2 --long --icons --git --color=always"
alias ls="eza -a --tree --level=1 --icons=always --color=always --group-directories-first"
alias ll='eza -al --icons --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'

# TUI Tools
alias lg='lazygit'
alias bt='btop --theme gruvbox-dark'
alias ld='lazydocker'
alias div='dive'
alias post='posting'
alias hq='harlequin'
alias tr='trip'
alias ya='yazi'

# Git aliases
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(#fabd2f)%h%C(bold)%C(#3c3836)%d %C(#8ec07c)%ar %C(#b8bb26)%an%n%C(bold)%C(#ebdbb2)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker aliases
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias dka="docker kill \$(docker ps -a -q)"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"

# Kubernetes aliases
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs -f"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'
alias kwatch="watch -n 1 kubectl get pods"

# Tmux aliases
alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# System utilities
alias cat='bat --theme gruvbox-dark'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
