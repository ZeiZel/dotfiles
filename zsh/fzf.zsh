# ============================================
# FZF - CATPPUCCIN MOCHA THEME
# ============================================

# Catppuccin Mocha colors for FZF
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--color=border:#6c7086,label:#cdd6f4,query:#cdd6f4
--height=60%
--layout=reverse
--border=rounded
--border-label-pos=2
--preview-window=border-rounded
--padding=1
--margin=1
--prompt='  '
--pointer=''
--marker=''
--separator='─'
--scrollbar='│'
--info=right
--bind='ctrl-u:preview-half-page-up'
--bind='ctrl-d:preview-half-page-down'
--bind='ctrl-a:select-all'
--bind='ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind='?:toggle-preview'"

# Default commands
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .venv'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .venv'

# Preview options
export FZF_CTRL_T_OPTS="
--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'
--preview-window=right:50%:wrap
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
--preview 'eza --tree --color=always --icons --level=2 {}'
--preview-window=right:50%"

export FZF_CTRL_R_OPTS="
--preview 'echo {}'
--preview-window=down:3:wrap
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"

# ============================================
# FZF INTEGRATION (optimized)
# ============================================
# Use pre-generated completion file if available, otherwise generate
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif [[ -x "$(whence -p fzf)" ]]; then
  eval "$(fzf --zsh)"
fi

# ============================================
# CUSTOM FZF FUNCTIONS
# ============================================

# fd - cd to selected directory
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules | fzf --preview 'eza --tree --color=always --icons --level=2 {}') &&
  cd "$dir"
}

# fh - search command history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fe - edit file with fzf and open in editor
fe() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

# fgb - checkout git branch
fgb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m --preview 'git log --oneline --graph --color=always {}') &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fgl - git log browser
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' \
      --bind "enter:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
