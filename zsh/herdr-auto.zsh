# ============================================
# HERDR AUTO-START
# ============================================
# A normal terminal opens directly into the persistent Herdr session. Herdr
# marks its managed panes with HERDR_ENV=1, preventing recursive attachment.

_should_start_herdr() {
  [[ "${ZSH_HERDR_AUTOSTART:-1}" == "1" ]] || return 1
  [[ "$HERDR_ENV" == "1" ]] && return 1
  [[ -n "$TMUX" ]] && return 1
  [[ -n "$SSH_CONNECTION" ]] && return 1
  [[ "$TERM" == "dumb" ]] && return 1
  [[ ! -o interactive || ! -t 0 || ! -t 1 ]] && return 1

  # IDE terminals work best without an additional full-screen workspace layer.
  [[ "$TERM_PROGRAM" == "vscode" ]] && return 1
  [[ -n "$IDEA_INITIAL_DIRECTORY" ]] && return 1
  [[ "$TERMINAL_EMULATOR" == *"JetBrains"* ]] && return 1

  (( $+commands[herdr] )) || return 1
  return 0
}

if _should_start_herdr; then
  exec herdr
fi

unfunction _should_start_herdr 2>/dev/null
