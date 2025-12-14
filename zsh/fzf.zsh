export FZF_DEFAULT_OPTS="
--color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
--color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
--color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
--height 40% --layout=reverse --border
--preview-window=:hidden
--bind='?:toggle-preview'
--bind='ctrl-u:preview-page-up'
--bind='ctrl-d:preview-page-down'
--bind='ctrl-a:select-all'
--prompt='🔍 '
--pointer='▶'
--marker='✓'"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Load FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
command -v fzf >/dev/null 2 >&1 && source <(fzf --zsh)
