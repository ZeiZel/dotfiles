# ============================================
# SCHEDULING PRIORITY
# ============================================
# A process started from an interactive shell inherits that shell's scheduling
# class, so a build saturating the performance cores competes with the editor
# that launched it on equal terms. A GUI application never loses that race
# because its main thread is registered user-interactive; a terminal UI has no
# equivalent path, which is why Neovim stutters under load while Zed does not.
#
# Only demotion is available to an unprivileged shell. Verified on Darwin 25,
# Apple silicon:
#
#   taskpolicy -c <clamp> CMD  QoS clamp, inherited by every descendant.
#   taskpolicy -b CMD          PRIO_DARWIN_BG, inherited, and throttles disk IO.
#   taskpolicy -b -p PID       affects that PID alone. Descendants forked
#                              afterwards do not inherit it, so a running
#                              process tree has to be walked explicitly.
#   taskpolicy -B -p PID       clears PRIO_DARWIN_BG. No -p form clears a QoS
#                              clamp; a clamp lives until the process exits.
#
# Raising priority is not possible here: a negative renice needs root and an
# interactive shell already runs in the highest class it can reach. Every tool
# below therefore protects the foreground by pushing load down, never by
# pulling the foreground up.
#
# ps exposes the resulting band in its PRI column. A clamped process holds a
# fixed value -- 20 under utility, 4 under background, maintenance or darwin-bg
# -- while an unclamped one floats upward as it runs, from 31 idle to the
# mid-40s under sustained load. Three equal `yes` loops measured on a busy
# machine took 76%, 16% and 13% of a core respectively, so the clamp is worth
# roughly a five-fold reduction in scheduler share.
#
# Note that PRI 4 is also where macOS parks much of its own daemon population,
# so a background band in the reports below does not by itself mean that
# anything here demoted the process.

typeset -g PRIORITY_TASKPOLICY=""
[[ "$OSTYPE" == darwin* && -x /usr/sbin/taskpolicy ]] &&
  PRIORITY_TASKPOLICY=/usr/sbin/taskpolicy

# Set to 0 in ~/.zshrc.local to keep every command in the foreground class.
# The wrappers stay defined so heavy/idle/calm remain available by hand.
typeset -g PRIORITY_AUTO=${PRIORITY_AUTO:-1}

# utility keeps normal disk IO and prefers efficiency cores. background adds IO
# throttling, which slows IO-bound builds far more than it protects the editor.
typeset -g PRIORITY_HEAVY_CLAMP=${PRIORITY_HEAVY_CLAMP:-utility}

# Sustained CPU share, in percent, above which hogs and calm consider a process.
typeset -g PRIORITY_HOG_THRESHOLD=${PRIORITY_HOG_THRESHOLD:-25}

# ---------------------------------------------
# Protected foreground tools
# ---------------------------------------------
# calm and demote never touch these, and boost with no argument lifts exactly
# this set. Matched against the basename of the process, so bundle executables
# such as Ghostty.app/Contents/MacOS/ghostty match as `ghostty`.
typeset -ga PRIORITY_INTERACTIVE=(
  ghostty Ghostty wezterm
  tmux workmux herdr
  nvim vim
  zsh bash starship atuin fzf zoxide navi
  lazygit lazydocker k9s yazi broot
  btop btm bottom procs viddy
  jless lnav glow posting resterm harlequin
  stern dive
  bat eza delta difft rg fd
)

# ---------------------------------------------
# Commands clamped to the efficiency cores
# ---------------------------------------------
# Matched as extended regular expressions against the whole command line. Only
# work that is genuinely sustained and non-interactive belongs here: a clamp on
# a command that finishes in milliseconds costs more than it saves.
#
# Deliberately absent:
#   docker/minikube  the work runs inside the Linux VM, so clamping the client
#                    changes nothing. Cap those in Docker Desktop, or let calm
#                    catch the VM process on the host.
#   hyperfine        clamping a benchmark harness invalidates its measurements.
#   git              overwhelmingly short and interactive; demote a long clone
#                    or gc by hand instead.
typeset -ga PRIORITY_HEAVY_PATTERNS=(
  '^(pnpm|npm|yarn|bun|npx)( run| exec| dlx)? (build|test|lint|typecheck|type-check|check|e2e|coverage|prepare|rebuild)'
  '^(pnpm|npm|yarn|bun) (install|i|ci|update|up|dedupe|audit)( |$)'
  '^(nx|turbo) (run-many|affected|build|test|lint|e2e|run)'
  '^(tsc|webpack|rollup|esbuild|jest|vitest|playwright)( |$)'
  '^vite build'
  '^cargo (build|test|check|clippy|bench|nextest|doc|install|fetch)'
  '^go (build|test|vet|generate|install)'
  '^dotnet (build|test|publish|restore|pack)'
  '^(make|cmake|ninja|gradle|mvn)( |$)'
  '^(terraform|tofu) (plan|apply|init|destroy)'
  '^ansible-playbook( |$)'
  '^(pytest|pip install|uv (sync|pip|run|build))'
  '^(trivy|gitleaks|ffmpeg|magick)( |$)'
  '^brew (install|upgrade|bundle|reinstall|update)'
)

# Binaries that get a dispatch wrapper. A wrapper only costs one regex sweep;
# when nothing matches the command runs untouched, so listing an entry here is
# not the same as always clamping it.
typeset -ga PRIORITY_WRAP=(
  pnpm npm yarn bun npx nx turbo
  tsc jest vitest playwright webpack rollup esbuild vite
  cargo go dotnet
  make cmake ninja gradle mvn
  terraform tofu ansible-playbook
  pytest uv pip
  brew ffmpeg magick
  trivy gitleaks
)

# ---------------------------------------------
# Explicit entry points
# ---------------------------------------------

# heavy: run a build-shaped command on the efficiency cores.
function heavy() {
  if (( $# == 0 )); then
    print -u2 "usage: heavy <command> [args...]"
    return 2
  fi
  if [[ -n "$PRIORITY_TASKPOLICY" ]]; then
    "$PRIORITY_TASKPOLICY" -c "$PRIORITY_HEAVY_CLAMP" "$@"
  else
    command nice -n 10 "$@"
  fi
}

# idle: the same, plus disk IO throttling, for work with no deadline at all.
# Named idle rather than bg because bg is the job-control builtin that Ctrl-Z
# depends on, and shadowing it would break resuming a suspended job.
function idle() {
  if (( $# == 0 )); then
    print -u2 "usage: idle <command> [args...]"
    return 2
  fi
  if [[ -n "$PRIORITY_TASKPOLICY" ]]; then
    "$PRIORITY_TASKPOLICY" -b "$@"
  else
    command nice -n 19 "$@"
  fi
}

# ---------------------------------------------
# Process inspection
# ---------------------------------------------

# One ps snapshot feeds every lookup below, so a single invocation of hogs,
# calm, demote, boost or prio sees one consistent view of the process table.
function _priority_scan() {
  typeset -gA _priority_ppid=() _priority_cpu=() _priority_pri=()
  typeset -gA _priority_comm=() _priority_kids=()
  local uid pid ppid cpu pri comm
  # Filter on uid rather than the user column: ps truncates long user names.
  while read -r uid pid ppid cpu pri comm; do
    [[ "$uid" == "$UID" && "$pid" == <-> ]] || continue
    _priority_ppid[$pid]="$ppid"
    _priority_cpu[$pid]="$cpu"
    _priority_pri[$pid]="$pri"
    _priority_comm[$pid]="${comm:t}"
    _priority_kids[$ppid]="${_priority_kids[$ppid]} $pid"
  done < <(command ps -axo uid=,pid=,ppid=,pcpu=,pri=,comm= 2>/dev/null)
}

# Every descendant of the given pids, including the pids themselves. The seen
# map keeps a recycled pid from turning the walk into a loop.
function _priority_descendants() {
  local -a queue=("$@") out=()
  local -A seen=()
  local pid kid
  while (( ${#queue} )); do
    pid="${queue[1]}"
    shift queue
    [[ -n "${seen[$pid]}" ]] && continue
    seen[$pid]=1
    out+=("$pid")
    for kid in ${=_priority_kids[$pid]}; do
      queue+=("$kid")
    done
  done
  print -r -- "${out[@]}"
}

# The chain from a pid up to init. Used to keep this shell, its multiplexer and
# its terminal out of reach of any demotion.
function _priority_ancestors() {
  local pid="$1"
  local -a chain=()
  local -i guard=0
  while [[ -n "${_priority_ppid[$pid]}" ]] && (( pid > 1 && guard++ < 64 )); do
    chain+=("$pid")
    pid="${_priority_ppid[$pid]}"
  done
  print -r -- "${chain[@]}"
}

function _priority_is_protected() {
  (( ${PRIORITY_INTERACTIVE[(Ie)$1]} ))
}

function _priority_band() {
  local -i pri="${1:-0}"
  if (( pri >= 30 )); then
    print -r -- foreground
  elif (( pri >= 15 )); then
    print -r -- utility
  else
    print -r -- background
  fi
}

# Resolve arguments that are either numeric pids or process basenames against
# the current snapshot. Names resolve only within this user's processes.
function _priority_pids() {
  local token pid
  local -a found=()
  for token in "$@"; do
    if [[ "$token" == <-> ]]; then
      found+=("$token")
      continue
    fi
    for pid in ${(k)_priority_comm}; do
      [[ "${_priority_comm[$pid]}" == "$token" ]] && found+=("$pid")
    done
  done
  print -r -- "${(u)found[@]}"
}

# ---------------------------------------------
# Load detection
# ---------------------------------------------

# hogs: what is actually holding the cores, and which band it already sits in.
function hogs() {
  local threshold="${1:-$PRIORITY_HOG_THRESHOLD}"
  _priority_scan
  local -a rows=()
  local pid state
  for pid in ${(k)_priority_cpu}; do
    (( ${_priority_cpu[$pid]} >= threshold )) || continue
    if _priority_is_protected "${_priority_comm[$pid]}"; then
      state=protected
    else
      state=open
    fi
    rows+=("${_priority_cpu[$pid]} $pid $(_priority_band ${_priority_pri[$pid]}) $state ${_priority_comm[$pid]}")
  done
  if (( ${#rows} == 0 )); then
    print -r -- "nothing sustained above ${threshold}% cpu"
    return 0
  fi
  printf '%-7s %-8s %-12s %-10s %s\n' 'CPU%' PID BAND STATE COMMAND
  local row cpu band comm
  for row in ${(On)rows}; do
    read -r cpu pid band state comm <<<"$row"
    printf '%-7s %-8s %-12s %-10s %s\n' "$cpu" "$pid" "$band" "$state" "$comm"
  done
}

# calm: push every unprotected hog and its whole subtree onto the efficiency
# cores. This is the recovery path for load that never went through a wrapper:
# language servers, agent runtimes, a container VM, anything already running.
function calm() {
  if [[ -z "$PRIORITY_TASKPOLICY" ]]; then
    print -u2 "calm: taskpolicy is unavailable on this platform"
    return 1
  fi
  local threshold="${1:-$PRIORITY_HOG_THRESHOLD}"
  _priority_scan
  local -A keep=()
  local pid kid
  # This shell's own ancestry holds the terminal and the multiplexer.
  for pid in $(_priority_ancestors $$); do
    keep[$pid]=1
  done
  local -i touched=0
  for pid in ${(k)_priority_cpu}; do
    (( pid > 100 )) || continue
    [[ -n "${keep[$pid]}" ]] && continue
    (( ${_priority_cpu[$pid]} >= threshold )) || continue
    _priority_is_protected "${_priority_comm[$pid]}" && continue
    local -i subtree=0
    for kid in $(_priority_descendants $pid); do
      [[ -n "${keep[$kid]}" ]] && continue
      _priority_is_protected "${_priority_comm[$kid]}" && continue
      "$PRIORITY_TASKPOLICY" -b -p "$kid" 2>/dev/null && (( subtree++, touched++ ))
    done
    (( subtree )) &&
      print -r -- "demoted ${_priority_comm[$pid]} (pid $pid, ${_priority_cpu[$pid]}% cpu, $subtree process(es))"
  done
  (( touched )) ||
    print -r -- "nothing above ${threshold}% cpu outside the protected set"
}

# demote: hold a named process or pid down regardless of its current load.
function demote() {
  if [[ -z "$PRIORITY_TASKPOLICY" ]]; then
    print -u2 "demote: taskpolicy is unavailable on this platform"
    return 1
  fi
  if (( $# == 0 )); then
    print -u2 "usage: demote <pid|name> [...]"
    return 2
  fi
  _priority_scan
  local -A keep=()
  local pid kid
  for pid in $(_priority_ancestors $$); do
    keep[$pid]=1
  done
  local -i touched=0
  for pid in $(_priority_pids "$@"); do
    (( pid > 100 )) || continue
    for kid in $(_priority_descendants $pid); do
      [[ -n "${keep[$kid]}" ]] && continue
      "$PRIORITY_TASKPOLICY" -b -p "$kid" 2>/dev/null && (( touched++ ))
    done
  done
  print -r -- "demoted $touched process(es)"
}

# boost: lift a held-down process back into the foreground band. With no
# argument it lifts every protected tool that is currently running, which is
# the recovery path after calm caught something it should not have.
#
# This only clears PRIO_DARWIN_BG and restores the best IO tiers. A QoS clamp
# applied at exec cannot be removed, and a negative nice value needs root, so a
# process started through heavy stays on the efficiency cores until it exits.
function boost() {
  if [[ -z "$PRIORITY_TASKPOLICY" ]]; then
    print -u2 "boost: taskpolicy is unavailable on this platform"
    return 1
  fi
  _priority_scan
  local -a targets
  if (( $# )); then
    targets=("$@")
  else
    targets=("${PRIORITY_INTERACTIVE[@]}")
  fi
  local pid kid
  local -i touched=0
  for pid in $(_priority_pids "${targets[@]}"); do
    (( pid > 100 )) || continue
    for kid in $(_priority_descendants $pid); do
      "$PRIORITY_TASKPOLICY" -B -p "$kid" 2>/dev/null || continue
      "$PRIORITY_TASKPOLICY" -t 0 -l 0 -p "$kid" 2>/dev/null
      (( touched++ ))
    done
  done
  print -r -- "restored $touched process(es) to the foreground band"
}

# prio: which band a process tree is in right now.
function prio() {
  _priority_scan
  local -a targets=("${@:-$$}")
  local pid kid
  printf '%-8s %-12s %-7s %s\n' PID BAND 'CPU%' COMMAND
  for pid in $(_priority_pids "${targets[@]}"); do
    for kid in $(_priority_descendants $pid); do
      printf '%-8s %-12s %-7s %s\n' "$kid" \
        "$(_priority_band ${_priority_pri[$kid]})" \
        "${_priority_cpu[$kid]}" "${_priority_comm[$kid]}"
    done
  done
}

# ---------------------------------------------
# Automatic dispatch
# ---------------------------------------------

function _priority_is_heavy() {
  (( PRIORITY_AUTO )) || return 1
  local line="$*"
  local pattern
  for pattern in "${PRIORITY_HEAVY_PATTERNS[@]}"; do
    [[ "$line" =~ $pattern ]] && return 0
  done
  return 1
}

# taskpolicy resolves its program argument through PATH and never sees shell
# functions, so the wrapper cannot recurse into itself.
function _priority_run() {
  if _priority_is_heavy "$@"; then
    "$PRIORITY_TASKPOLICY" -c "$PRIORITY_HEAVY_CLAMP" "$@"
  else
    command "$@"
  fi
}

# Regenerate the wrappers. Call this after extending PRIORITY_WRAP from
# ~/.zshrc.local, which is sourced after this module.
function priority-rewrap() {
  [[ -n "$PRIORITY_TASKPOLICY" ]] || return 0
  local bin
  for bin in "${PRIORITY_WRAP[@]}"; do
    (( $+commands[$bin] )) || continue
    functions[$bin]="_priority_run ${(q)bin} \"\$@\""
  done
}

priority-rewrap

# A shell forked from a process that calm held down inherits PRIO_DARWIN_BG,
# which would then leak into every tool launched from it. Clearing it once here
# is what keeps the protected set genuinely foreground at launch time.
# An `if` block rather than a `&&` chain: this is the last statement in the
# file, and a false `&&` would hand `source` a nonzero status that automation
# running `zsh -ic` would read as a startup failure.
if [[ -o interactive && -n "$PRIORITY_TASKPOLICY" ]]; then
  "$PRIORITY_TASKPOLICY" -B -p $$ 2>/dev/null
fi

return 0
