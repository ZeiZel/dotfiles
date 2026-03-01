# ============================================
# TMUX AUTO-START
# ============================================
# Automatically attach to or create tmux session on shell start
# Skip if already in tmux, SSH without tmux, or in VSCode/IDE terminal

_should_start_tmux() {
  # Already in tmux
  [[ -n "$TMUX" ]] && return 1

  # Disabled via env var
  [[ "$DISABLE_TMUX_AUTOSTART" == "1" ]] && return 1

  # SSH session without tmux (let user decide)
  [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]] && return 1

  # IDE terminals (VSCode, JetBrains, etc.)
  [[ "$TERM_PROGRAM" == "vscode" ]] && return 1
  [[ -n "$IDEA_INITIAL_DIRECTORY" ]] && return 1
  [[ -n "$TERMINAL_EMULATOR" && "$TERMINAL_EMULATOR" == *"JetBrains"* ]] && return 1

  # Embedded terminals
  [[ "$TERM" == "dumb" ]] && return 1

  # Non-interactive shell
  [[ ! -o interactive ]] && return 1

  # tmux not installed
  ! command -v tmux &>/dev/null && return 1

  return 0
}

if _should_start_tmux; then
  # Try to attach to existing session or create new one
  if tmux has-session 2>/dev/null; then
    # Attach to last session
    exec tmux attach-session
  else
    # Create new session named 'main'
    exec tmux new-session -s main
  fi
fi

unfunction _should_start_tmux 2>/dev/null
