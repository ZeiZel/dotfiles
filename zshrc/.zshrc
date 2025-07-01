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

# UPDATE SOURCES

source $(brew --prefix)/opt/spaceship/spaceship.zsh
source $ZSH/oh-my-zsh.sh

# PLUGINS

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

alias ls="eza -a --tree --level=1 --icons=always"
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'

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
alias nvc="NVIM_APPNAME=nvchad nvim"
alias nv="NVIM_APPNAME=nv nvim"
alias lvim="NVIM_APPNAME=nviml nvim"

function nvims() {
	items=("default" "nv" "nvc" "nviml")
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

source <(fzf --zsh)
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
