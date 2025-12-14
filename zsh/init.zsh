# NVM bash completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Local bin
[ -s "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Atuin
[ -s "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin >/dev/null 2 >&1 && eval "$(atuin init zsh)"

# Zoxide
command -v zoxide >/dev/null 2 >&1 && eval "$(zoxide init zsh)"

# Auto-start tmux
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
	tmux attach -t default || tmux new -s default
fi
