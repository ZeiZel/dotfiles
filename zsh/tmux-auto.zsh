# ============================================
# TMUX AUTO-START
# ============================================
# Keep the outer terminal as a normal shell in SSH/IDE/non-TTY contexts. A
# tmux client is attached exactly once; panes inherit the same guard through
# TMUX, so nested sessions are never created.

_should_start_tmux() {
  [[ "${ZSH_TMUX_AUTOSTART:-1}" == "1" ]] || return 1
  [[ -z "${TMUX:-}" ]] || return 1
  [[ -z "${HERDR_ENV:-}" ]] || return 1
  [[ -z "${SSH_CONNECTION:-}" ]] || return 1
  [[ "${TERM:-}" != "dumb" ]] || return 1
  [[ -o interactive && -t 0 && -t 1 ]] || return 1
  [[ "${TERM_PROGRAM:-}" != "vscode" ]] || return 1
  [[ -z "${IDEA_INITIAL_DIRECTORY:-}" ]] || return 1
  [[ "${TERMINAL_EMULATOR:-}" != *JetBrains* ]] || return 1
  (( $+commands[tmux] )) || return 1
  return 0
}

# A cold server has to finish restoring before anything creates the session it
# is about to restore into. Creating `main` first and letting tmux-resurrect
# restore on top of it leaves duplicate panes in the windows it rebuilds last,
# so the server is started with no sessions at all, continuum is given the
# moment it needs, and only then does this shell attach. `exit-empty off` in
# tmux.options.conf is what lets a server exist with zero sessions.
_tmux_restore_pending() {
  [[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/resurrect/last" ]] || return 1
  [[ "$(tmux show-options -gv @continuum-restore 2>/dev/null)" == 'on' ]] || return 1
  return 0
}

if _should_start_tmux; then
  if ! tmux has-session 2>/dev/null; then
    tmux start-server 2>/dev/null
    if _tmux_restore_pending; then
      # Continuum sleeps a second before it restores. Wait for the session to
      # exist rather than for the whole restore, which completes just as well
      # underneath an attached client. The bound keeps a failed or disabled
      # restore from ever holding the first prompt for long.
      typeset -i _tmux_restore_wait=0
      while (( _tmux_restore_wait < 60 )) && ! tmux has-session -t main 2>/dev/null; do
        command sleep 0.1
        (( _tmux_restore_wait++ ))
      done
      unset _tmux_restore_wait
    fi
  fi
  exec tmux new-session -A -s main
fi

unfunction _should_start_tmux _tmux_restore_pending 2>/dev/null
