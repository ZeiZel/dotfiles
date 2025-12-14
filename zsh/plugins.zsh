# ============================================
# ZINIT - Fast plugin manager
# ============================================

# Install zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit ice lucid wait='0'
zinit light zsh-users/zsh-syntax-highlighting

zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait='0'
zinit light agkozak/zsh-z

# OMZ plugins без Oh-My-Zsh
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::kubectl
zinit snippet OMZP::terraform
zinit snippet OMZP::extract
zinit snippet OMZP::colored-man-pages

zinit ice lucid wait='0'
zinit light unixorn/fzf-zsh-plugin
