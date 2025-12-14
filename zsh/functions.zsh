# Yazi with cd integration
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# HTTPyac wrapper with pretty JSON output
function htt() {
	httpyac $1 --json -a | jq -r ".requests[0].response.body" | jq | bat --language=json --theme gruvbox-dark
}

# Neovim config switcher
function nvims() {
	items=("default" "nv")
	config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi
	NVIM_APPNAME=$config nvim $@
}

# Fast directory search and navigation
function fcd() {
	local dir
	dir=$(fd --type d --hidden --follow --exclude .git | fzf --prompt="📁 " --preview 'eza --tree --level=2 --icons --color=always {}')
	if [[ -n "$dir" ]]; then
		cd "$dir"
	fi
}

# Fast file search and open in neovim
function fv() {
	local file
	file=$(fzf --prompt="📄 " --preview 'bat --color=always --theme=gruvbox-dark {}')
	if [[ -n "$file" ]]; then
		nvim "$file"
	fi
}

# Tmux session launcher with FZF
function tm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	if [ $1 ]; then
		tmux $change -t "$1" 2 >/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2 >/dev/null | fzf --exit-0 --prompt="🖥️  ") && tmux $change -t "$session" || echo "No sessions found."
}

# Create and enter directory
function mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Extract any archive
function extract() {
	if [ -f $1 ] ; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;; 
		*.tar.gz) tar xzf $1 ;; 
		*.bz2) bunzip2 $1 ;; 
		*.rar) unrar e $1 ;; 
		*.gz) gunzip $1 ;; 
		*.tar) tar xf $1 ;; 
		*.tbz2) tar xjf $1 ;; 
		*.tgz) tar xzf $1 ;; 
		*.zip) unzip $1 ;; 
		*.Z) uncompress $1 ;; 
		*.7z) 7z x $1 ;; 
		*) echo "'$1' cannot be extracted" ;; 
		esac
	else
		echo "'$1' is not a valid file"
	fi
}
