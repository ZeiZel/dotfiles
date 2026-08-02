# Yazi with cd integration
function yy() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  command rm -f -- "$tmp"
}

# HTTPyac wrapper with pretty JSON output
function htt() {
  if (( $# == 0 )); then
    print -u2 "usage: htt <request-file>"
    return 2
  fi
  httpyac "$1" --json -a |
    jq -r ".requests[0].response.body" |
    jq |
    bat --language=json --theme="Catppuccin Mocha"
}

# Stop all running containers without invoking Docker when the list is empty.
function dka() {
  local -a container_ids
  container_ids=("${(@f)$(docker ps -q)}")
  (( ${#container_ids} > 0 )) && docker kill "${container_ids[@]}"
}

# Neovim config switcher
function nvims() {
  local config
  local -a items=("default" "nv")
  config=$(printf "%s\n" "${items[@]}" |
    fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  [[ -z "$config" ]] && return 0
  [[ "$config" == "default" ]] && config=""
  NVIM_APPNAME="$config" nvim "$@"
}

# Unified development environment entrypoint.
# Keep dispatch in a function so subcommands and argument boundaries are
# preserved (aliases cannot reliably implement this interface).
function dev() {
  local area=${1:-}
  local target

  if (( $# > 0 )); then
    shift
  fi

  case "$area" in
    ide)
      target=nvim
      ;;
    rest)
      target=resterm
      ;;
    db)
      target=harlequin
      ;;
    docker)
      target=lazydocker
      ;;
    git)
      target=lazygit
      ;;
    agent)
      if (( $# == 0 )); then
        print -u2 "usage: dev agent <codex|claude> [args...]"
        return 2
      fi
      target=$1
      shift
      case "$target" in
        codex|claude)
          ;;
        *)
          print -u2 "dev: unknown agent '$target' (expected codex or claude)"
          return 2
          ;;
      esac
      ;;
    help|-h|--help)
      print "usage: dev <ide|rest|db|docker|git|agent> [args...]"
      print "  dev ide [args...]             Open Neovim"
      print "  dev rest [args...]            Open Resterm"
      print "  dev db [args...]              Open Harlequin"
      print "  dev docker [args...]          Open Lazydocker"
      print "  dev git [args...]             Open Lazygit"
      print "  dev agent <codex|claude> ...   Open an AI coding agent"
      return 0
      ;;
    *)
      print -u2 "usage: dev <ide|rest|db|docker|git|agent> [args...]"
      return 2
      ;;
  esac

  if (( ! $+commands[$target] )); then
    print -u2 "dev: command '$target' is not available"
    return 127
  fi

  command "$target" "$@"
}

# Fast file search and open in neovim
function fv() {
  local file
  file=$(fzf --prompt="📄 " --preview 'bat --color=always --theme="Catppuccin Mocha" {}')
  [[ -n "$file" ]] && nvim "$file"
}

# Herdr named-session launcher with FZF. Workspaces remain the preferred way
# to organize projects inside the default session.
function hsm() {
  local session

  if [[ -n "${HERDR_ENV:-}" ]]; then
    print -u2 "hsm: already inside Herdr; use Ctrl+A, then f"
    return 0
  fi

  if (( $# > 0 )); then
    herdr session attach "$1"
    return
  fi

  session=$(herdr session list --json 2>/dev/null |
    jq -r '.sessions[].name' |
    fzf --exit-0 --prompt=" Herdr session  ")
  [[ -n "$session" ]] && herdr session attach "$session"
}

# Create and enter directory
function mkcd() {
  if (( $# == 0 )); then
    print -u2 "usage: mkcd <directory>"
    return 2
  fi
  command mkdir -p -- "$1" && builtin cd -- "$1"
}

# Extract any archive
function extract() {
  if (( $# == 0 )) || [[ ! -f "$1" ]]; then
    print -u2 "usage: extract <archive>"
    return 2
  fi

  if (( $+commands[atool] )); then
    command atool --extract -- "$1"
  else
    print -u2 "extract: install atool to extract archives"
    return 127
  fi
}
