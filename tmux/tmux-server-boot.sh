#!/bin/sh
# Start the Tmux server at login without opening a terminal window.
#
# tmux-continuum ships its own macOS boot support, but it works by launching a
# GUI terminal (Terminal.app, iTerm, kitty or Alacritty) and has no Ghostty
# strategy, so this replaces it. The server is started headless and detaches on
# its own; `exit-empty off` in tmux.options.conf is what lets it stay alive
# before any session exists.
#
# Restore is not left to continuum alone. Its auto-restore gives up whenever it
# counts more than one tmux process on the machine, which at login is a race
# against the first terminal window. Continuum gets its chance first, and only
# if nothing appeared does this script restore explicitly, so the result does
# not depend on who won.

set -u

tmux_bin="${TMUX_SERVER_BOOT_TMUX:-tmux}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
resurrect_last="$config_home/tmux/resurrect/last"
restore_script="$config_home/tmux/plugins/tmux-resurrect/scripts/restore.sh"

command -v "$tmux_bin" >/dev/null 2>&1 || exit 0

# A server with sessions is already doing this job.
if "$tmux_bin" has-session 2>/dev/null; then
  exit 0
fi

"$tmux_bin" start-server 2>/dev/null || exit 0

# Continuum sleeps a second before restoring; give it five.
attempt=0
while [ "$attempt" -lt 50 ]; do
  if "$tmux_bin" has-session 2>/dev/null; then
    exit 0
  fi
  sleep 0.1
  attempt=$((attempt + 1))
done

[ -r "$resurrect_last" ] || exit 0
[ -x "$restore_script" ] || exit 0
"$restore_script" >/dev/null 2>&1
