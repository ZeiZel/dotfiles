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

if _should_start_tmux; then
  exec tmux new-session -A -s main
fi

unfunction _should_start_tmux 2>/dev/null
