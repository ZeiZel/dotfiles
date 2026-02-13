# ============================================
# FILE NAVIGATION (Eza)
# ============================================
alias l="eza -l --icons --git -a --color=always --group-directories-first"
alias lt="eza --tree --level=2 --long --icons --git --color=always"
alias ls="eza -a --tree --level=1 --icons=always --color=always --group-directories-first"
alias ll='eza -al --icons --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias lta="eza --tree --level=3 --icons --git -a --color=always"

# ============================================
# TUI APPLICATIONS
# ============================================
alias lg='lazygit'
alias bt='btop'
alias ld='lazydocker'
alias div='dive'
alias post='posting'
alias hq='harlequin'
alias tr='trip'
alias ya='yazi'
alias k9='k9s'

# ============================================
# GIT
# ============================================
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(#7aa2f7)%h%C(bold)%C(#414868)%d %C(#9ece6a)%ar %C(#bb9af7)%an%n%C(bold)%C(#c0caf5)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'
alias grs='git restore --staged'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gsh='git stash'
alias gshp='git stash pop'
alias gshl='git stash list'

# ============================================
# DOCKER
# ============================================
alias dco="docker compose"
alias dcup="docker compose up -d"
alias dcdown="docker compose down"
alias dclogs="docker compose logs -f"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias dka="docker kill \$(docker ps -a -q)"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dprune="docker system prune -af"
alias dvprune="docker volume prune -f"

# ============================================
# KUBERNETES
# ============================================
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kga="kubectl get all"
alias kgp="kubectl get pods"
alias kgpw="kubectl get pods -w"
alias kgs="kubectl get svc"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kgi="kubectl get ingress"
alias kgcm="kubectl get configmaps"
alias kgsec="kubectl get secrets"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe svc"
alias kdd="kubectl describe deployment"
alias kdel="kubectl delete"
alias kl="kubectl logs -f"
alias klp="kubectl logs -f --previous"
alias ke="kubectl exec -it"
alias kpf="kubectl port-forward"
alias kc="kubectx"
alias kns="kubens"
alias kcns='kubectl config set-context --current --namespace'
alias kwatch="watch -n 1 kubectl get pods"
alias krollout="kubectl rollout status"
alias krestart="kubectl rollout restart"
alias ktop="kubectl top pods"
alias ktopn="kubectl top nodes"

# ============================================
# HELM
# ============================================
alias h="helm"
alias hl="helm list"
alias hla="helm list -A"
alias hi="helm install"
alias hu="helm upgrade"
alias hui="helm upgrade --install"
alias hd="helm delete"
alias hs="helm search repo"
alias hr="helm repo"
alias hru="helm repo update"

# ============================================
# TERRAFORM
# ============================================
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfaa="terraform apply -auto-approve"
alias tfd="terraform destroy"
alias tfda="terraform destroy -auto-approve"
alias tfs="terraform state"
alias tfsl="terraform state list"
alias tfo="terraform output"
alias tfv="terraform validate"
alias tff="terraform fmt -recursive"
alias tfw="terraform workspace"
alias tfwl="terraform workspace list"
alias tfws="terraform workspace select"

# ============================================
# ANSIBLE
# ============================================
alias ap="ansible-playbook"
alias ag="ansible-galaxy"
alias av="ansible-vault"
alias al="ansible-lint"

# ============================================
# AWS CLI
# ============================================
alias aws-whoami="aws sts get-caller-identity"
alias aws-regions="aws ec2 describe-regions --output table"

# ============================================
# TMUX
# ============================================
alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias tks='tmux kill-session'

# ============================================
# NODE.JS / NPM / PNPM
# ============================================
alias ni="npm install"
alias nid="npm install -D"
alias nig="npm install -g"
alias nr="npm run"
alias nrs="npm run start"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrd="npm run dev"
alias nrl="npm run lint"
alias pi="pnpm install"
alias pa="pnpm add"
alias pad="pnpm add -D"
alias pr="pnpm run"
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias prt="pnpm run test"
alias px="pnpm dlx"

# ============================================
# FRONTEND CLI
# ============================================
alias nxg="nx generate"
alias nxb="nx build"
alias nxs="nx serve"
alias nxt="nx test"
alias nxl="nx lint"
alias nxa="nx affected"
alias ngg="ng generate"
alias ngb="ng build"
alias ngs="ng serve"
alias ngt="ng test"

# ============================================
# DIRECTORY NAVIGATION
# ============================================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ~="cd ~"
alias -- -="cd -"

# ============================================
# SYSTEM UTILITIES - MODERN REPLACEMENTS
# ============================================

# bat - better cat with syntax highlighting
alias cat='bat --theme="Catppuccin Mocha"'
alias catn='bat --plain'  # No line numbers, no git

# Better grep with colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# diff with delta (git-delta)
alias diff='delta'

# ip with colors (Linux only)
[[ "$OSTYPE" == "linux-gnu"* ]] && alias ip='ip --color=auto'

# Modern disk utilities
alias df='duf'                          # Better df
alias du='dust'                         # Better du
alias duh='dust -d 1'                   # Disk usage here (1 level)

# Free memory (Linux only)
[[ "$OSTYPE" == "linux-gnu"* ]] && alias free='free -h'

# Process viewing
alias ps='procs'                        # Better ps
alias pst='procs --tree'                # Process tree
alias psa='procs --sortd cpu'           # Sort by CPU

# Network
alias ports='netstat -tulanp 2>/dev/null || lsof -i -P -n | grep LISTEN'
alias myip='curl -s ifconfig.me'
alias localip="ipconfig getifaddr en0 2>/dev/null || ip route get 1 | awk '{print \$7}'"
alias ping='gping'                      # Ping with graph

# System info
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias weather='curl -s "wttr.in?format=3"'
alias wttr='curl -s wttr.in'

# File operations with preview
alias preview='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# Quick file find
alias ff='fd --type f'
alias fdir='fd --type d'

# JSON/YAML pretty print
alias json='jq .'
alias yaml='yq .'

# Benchmarking
alias bench='hyperfine'

# Code stats
alias loc='tokei'

# Markdown preview
alias mdp='glow'

# ============================================
# SAFETY NETS
# ============================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ============================================
# QUICK EDITS
# ============================================
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias nvimrc='${EDITOR:-nvim} ~/.config/nvim/init.lua'
alias tmuxrc='${EDITOR:-nvim} ~/.config/tmux/tmux.conf'
alias dotfiles='cd ~/dotfiles && ${EDITOR:-nvim} .'

# ============================================
# HTTPIE / API TESTING
# ============================================
alias http='http --style=monokai'
alias https='https --style=monokai'

# ============================================
# CLAUDE CODE
# ============================================
alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'
