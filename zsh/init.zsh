# ============================================
# TOOL INITIALIZATION
# ============================================

# Generate shell integration only after its binary changes, then source the
# cached file on normal startups. Cache generation is detached so a missing or
# stale cache never blocks the first prompt.
_source_generated_zsh_init() {
  local cache_file="$1"
  local generator="$2"
  shift 2

  local cache_dir="${cache_file:h}"
  [[ -r "$cache_file" ]] && source "$cache_file"

  if [[ ! -r "$cache_file" || "$generator" -nt "$cache_file" ]]; then
    [[ -d "$cache_dir" ]] || command mkdir -p "$cache_dir" 2>/dev/null
    if [[ -d "$cache_dir" && -w "$cache_dir" ]]; then
      local lock_dir="$cache_file.lock"
      local -i lock_owned=0
      if ! command mkdir "$lock_dir" 2>/dev/null; then
        # A killed generator can leave its lock directory behind. Reclaim only
        # an old empty lock or one owner marker whose PID is no longer alive.
        local -a lock_stat
        local -a lock_owners
        zmodload -F zsh/datetime p:EPOCHSECONDS 2>/dev/null
        local -i lock_now=${EPOCHSECONDS:-0}
        if (( lock_now > 0 )) &&
          zmodload -F zsh/stat b:zstat 2>/dev/null &&
          zstat -A lock_stat +mtime -- "$lock_dir" 2>/dev/null &&
          (( ${lock_stat[1]:-0} > 0 && lock_now - lock_stat[1] > 300 )); then
          lock_owners=("$lock_dir"/owner.*(N))
          if (( ${#lock_owners} == 0 )); then
            command rmdir "$lock_dir" 2>/dev/null &&
              command mkdir "$lock_dir" 2>/dev/null && lock_owned=1
          elif (( ${#lock_owners} == 1 )); then
            local owner_pid
            owner_pid="$(<"${lock_owners[1]}")"
            if [[ "$owner_pid" == <-> ]] && ! kill -0 "$owner_pid" 2>/dev/null; then
              command rm -f -- "${lock_owners[1]}" 2>/dev/null &&
                command rmdir "$lock_dir" 2>/dev/null &&
                command mkdir "$lock_dir" 2>/dev/null && lock_owned=1
            fi
          fi
        fi
      else
        lock_owned=1
      fi
      if (( lock_owned )); then
        (
          local tmp_file="$cache_file.tmp.$$"
          zmodload -F zsh/system p:sysparams 2>/dev/null || exit 0
          local owner_pid="${sysparams[pid]}"
          local owner_file="$lock_dir/owner.${owner_pid}.${RANDOM}"
          print -r -- "$owner_pid" >| "$owner_file" || exit 0
          trap 'command rm -f "$tmp_file" "$owner_file"; command rmdir "$lock_dir" 2>/dev/null' EXIT HUP INT TERM
          "$generator" "$@" >| "$tmp_file" 2>/dev/null &&
            command mv -f "$tmp_file" "$cache_file"
        ) >/dev/null 2>&1 &!
      fi
    fi
  fi
}

# Atuin owns Ctrl-R only. Arrow keys remain standard Zsh history navigation,
# which is faster and cannot unexpectedly open a full-screen interface.
if (( $+commands[atuin] )); then
  _source_generated_zsh_init \
    "${XDG_CACHE_HOME:-$HOME/.cache}/atuin/init.zsh" \
    "$commands[atuin]" init zsh --disable-up-arrow --disable-ai
fi

if (( $+commands[zoxide] )); then
  _source_generated_zsh_init \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zoxide/init.zsh" \
    "$commands[zoxide]" init zsh
fi

if (( $+commands[broot] )); then
  _source_generated_zsh_init \
    "${XDG_CACHE_HOME:-$HOME/.cache}/broot/init.zsh" \
    "$commands[broot]" --print-shell-function zsh
fi

if (( $+commands[navi] )); then
  _source_generated_zsh_init \
    "${XDG_CACHE_HOME:-$HOME/.cache}/navi/init.zsh" \
    "$commands[navi]" widget zsh
fi

# Kept until the manifest finishes: fzf.zsh and prompt.zsh load after this
# entry, then .zshrc removes the helper from the interactive namespace.
