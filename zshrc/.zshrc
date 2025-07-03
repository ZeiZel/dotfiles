# ENV VARIABLES

export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:${PATH}
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# pnpm
export PNPM_HOME="/home/zeizel/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) 
	;; 
*) export PATH="$PNPM_HOME:$PATH" ;; 
esac
# pnpm end
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

ZSH_THEME="spaceship"

# run scripts

source <(fzf --zsh)
source <(kubectl completion zsh)
source $(brew --prefix)/opt/spaceship/spaceship.zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.config/antigen.zsh

# PLUGINS

antigen use oh-my-zsh

antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle unixorn/fzf-zsh-plugin
antigen bundle atuinsh/atuin@main

antigen bundle git
antigen bundle vscode
antigen bundle vi-mode
antigen bundle nvim
antigen bundle nvm
antigen bundle oc
antigen bundle ansible
antigen bundle vagrant
antigen bundle vagrant-prompt
antigen bundle docker
antigen bundle docker-compose
antigen bundle virtualenv
antigen bundle web-search
antigen bundle extract
antigen bundle z
antigen bundle npm
antigen bundle kubectl
antigen bundle kubectx
antigen bundle minikube
antigen bundle terraform
antigen bundle colored-man-pages
antigen bundle junegunn/fzf
antigen bundle unixorn/fzf-zsh-plugin
antigen bundle ohmyzsh/ohmyzsh path:plugins/thefuck

antigen theme spaceship-prompt/spaceship-prompt spaceship

antigen apply

plugins=(
	git
	z
	dnf
	docker
	fzf
	fzf-zsh-plugin
	zsh-autosuggestions
	zsh-syntax-highlighting
	history
)

# ALIASES

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ls="eza -a --tree --level=1 --icons=always"
alias ll='eza -al --icons'

alias lg='lazygit'
alias bt='btop'
alias ld='lazydocker'
alias div='dive'
alias post='posting'
alias hq='harlequin'
alias tr='trip' # https://github.com/fujiapple852/trippy
alias ya='yazi'

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias dka="docker kill $(docker ps -a -q)"

# K8S
export KUBECONFIG=~/.kube/config
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias kl="kubectl logs -f"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'
alias podname=''

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

bindkey jj vi-cmd-mode

# SETTINGS

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# FUNCTIONS

# start yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# wrapper on the httpyac
function htt() {
	httpyac $1 --json -a | jq -r ".requests[0].response.body" | jq | bat --language=json
}

# Neovim config aliases for multilaunching
alias nv="NVIM_APPNAME=nv nvim"

function nvims() {
	items=("default" "nv" )
	config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi
	NVIM_APPNAME=$config nvim $@
}

# START SCRIPTS

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
[ -s "/home/zeizel/.bun/_bun" ] && source "/home/zeizel/.bun/_bun"
if [ "$TMUX" = "" ]; then tmux; fi 

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

. "$HOME/.local/bin/env"
