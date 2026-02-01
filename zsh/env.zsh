export ZSH="$HOME/.oh-my-zsh"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:${PATH}

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/zeizel/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NVM (lazy loading)
export NVM_DIR="$HOME/.nvm"
nvm() {
	unset -f nvm
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	nvm "$@"
}

# Kubernetes
export KUBECONFIG=~/.kube/config

# History configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

# Performance
DISABLE_MAGIC_FUNCTIONS=true
COMPLETION_WAITING_DOTS=true
