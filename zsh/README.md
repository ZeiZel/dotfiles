# Zsh configuration

`zsh/.zshrc` is linked to `~/.zshrc`. It uses an explicit source manifest so
widget and keymap ownership cannot change with filename order. Terminal-backed
interactive shells load:

1. environment and options;
2. theme and one cached `compinit`;
3. FZF, Atuin, Zoxide, Broot and Navi integrations;
4. aliases, functions and Starship;
5. Homebrew-managed plugins;
6. final Emacs key bindings;
7. optional `~/.zshrc.local` and the guarded terminal multiplexer dispatcher.

Interactive commands without a TTY load only environment, options, aliases and
functions and remain silent.

## File ownership

- `env.zsh`: XDG variables, editor selection, PATH and language runtimes.
- `aliases.zsh`: aliases only; keep destructive aliases explicit.
- `functions.zsh`: reusable shell functions.
- `priority.zsh`: macOS scheduling policy. Protects the foreground by
  clamping build-shaped commands to the efficiency cores.
- `plugins.zsh`: versioned Homebrew plugin loading.
- `init.zsh`: initialization and cached generated integrations.
- `fzf.zsh`: FZF defaults, previews and widgets.
- `kbd.zsh`: key bindings.
- `options.zsh`: shell options.
- `theme.zsh`, `prompt.zsh`: presentation.
- `multiplexer-auto.zsh`: final selector dispatcher, sourced after the local
  override. `ZSH_MULTIPLEXER` accepts `tmux` (default), `herdr`, or `none`.
- `tmux-auto.zsh`: guarded Tmux attachment selected by the dispatcher.
- `herdr-auto.zsh`: guarded Herdr attachment selected by the dispatcher.
- `completitions.zsh`: existing completion setup (filename is intentionally
  retained for compatibility).

Adding a file does not activate it. Add it to the manifest in `.zshrc` at the
point where its widgets and bindings belong. Keep top-level code silent and
guard optional commands/files.

Machine-specific paths, tokens and credentials do not belong here. Copy
`.zshrc.local.example` to the untracked `~/.zshrc.local` and keep local values
there.

Up/Down always use native Zsh history. Atuin owns only `Ctrl+R`. `bindkey -e`
is explicit because `EDITOR=nvim` would otherwise make Zsh choose vi mode.
NVM is lazy-loaded; the default Node binary is placed on PATH without sourcing
`nvm.sh`.

Optional local tool homes (`$HOME/.kimi-code/bin` and
`$HOME/.mimocode/bin`) are added only when present. `$HOME/.local/bin/env` is
sourced only when readable; all three are handled by `env.zsh`, and the later
untracked `~/.zshrc.local` can change their priority.

Starship is initialized from a binary-invalidated cache, but its prompt data is
always live. The prompt shows the current time, command duration (including
milliseconds), repository state, Docker/Kubernetes indicators and the installed
Helm version, plus detected language/tool versions only when project markers
match. Git is shown only inside a repository; Docker is shown when a Docker
file/compose marker is present and reflects a non-default or overridden context.
Starship bounds each external module command to 250 ms (not the total prompt
latency); it does not make
network requests on startup or fetch Git remotes. Starship does not provide a
supported asynchronous or transient-prompt implementation for Zsh, so this
configuration deliberately avoids a custom background job that could race ZLE.
The generated Starship, FZF, Atuin, Zoxide, Broot and Navi integration shims
are refreshed in a detached, lock-protected process when a binary changes.
Existing shims are sourced immediately; on a clean cache the first shell keeps
its native bindings and the integrations become available on the next shell
after generation completes.
Because the tracked `right_format` is empty, `prompt.zsh` also clears the empty
`RPROMPT` command substitution installed by Starship. This avoids a second
Starship process on every prompt; a later local override may still set its own
`RPROMPT`.

History preserves prior occurrences of commands. `HIST_IGNORE_ALL_DUPS` and
`HIST_SAVE_NO_DUPS` are intentionally not enabled because they remove older
duplicate entries and can look like history loss. Consecutive duplicates are
still suppressed with `HIST_IGNORE_DUPS`.

The multiplexer dispatcher runs last, after the local override. Normal local
interactive shells attach to the persistent Tmux `main` session by default. Set
`ZSH_MULTIPLEXER=herdr` to enter Herdr, or `ZSH_MULTIPLEXER=none` for a plain shell.
Invalid values fail safe to a plain shell without startup noise. SSH, IDE,
nested multiplexer, non-TTY, and `TERM=dumb` shells remain plain. The legacy
`ZSH_HERDR_AUTOSTART=0` and `ZSH_TMUX_AUTOSTART=0` variables are secondary
kill switches; the selector is the canonical interface.

For a one-shot choice in a new outer/plain shell, prefix the shell command,
for example `ZSH_MULTIPLEXER=herdr zsh`; nested multiplexer guards intentionally
take precedence. The persistent choice belongs in the untracked
`~/.zshrc.local`; `.zshrc.local.example` contains the available values.

Herdr remains installed and available regardless of the selector, and its
bindings mirror Tmux key for key, so the `Ctrl+A` prefix and the Lazygit/reviewr
actions behave the same in either backend.

## Scheduling priority

A process started from an interactive shell inherits that shell's scheduling
class, so a build competes with the editor that launched it on equal terms. A
GUI application wins that race automatically because its main thread is
registered user-interactive; a terminal UI has no equivalent path. `priority.zsh`
closes the gap from the other side, by pushing load down.

Only demotion is available. A negative `renice` requires root, and an
interactive shell already runs in the highest class it can reach, so nothing
here raises priority; `boost` only undoes a demotion.

| Command | Effect |
| --- | --- |
| `heavy <cmd>` | Runs under a `utility` QoS clamp: efficiency cores, normal disk IO. |
| `idle <cmd>` | Adds IO throttling, for work with no deadline. Named `idle` because `bg` is the job-control builtin that `Ctrl+Z` depends on. |
| `hogs [pct]` | Sustained CPU consumers, with the band each already sits in. |
| `calm [pct]` | Demotes every unprotected hog and its subtree. Recovery path for load that never went through a wrapper. |
| `demote <pid\|name>` | Holds a named process tree down regardless of its load. |
| `boost [pid\|name]` | Lifts a tree back. With no argument, lifts every running tool in `PRIORITY_INTERACTIVE`. |
| `prio [pid\|name]` | The band a process tree currently occupies. |

`PRIORITY_WRAP` binaries get a dispatch wrapper that sweeps
`PRIORITY_HEAVY_PATTERNS` against the whole command line. A wrapper is not the
same as an unconditional clamp: `pnpm build` matches and is clamped, `pnpm dev`
does not and runs untouched. `command <name>` bypasses a wrapper entirely.

`PRIORITY_INTERACTIVE` is the protected set. `calm` and `demote` never touch a
process whose basename appears there, nor anything in this shell's own
ancestry, which is what keeps the terminal and the multiplexer safe.

Deliberately excluded: Docker and Minikube, because the work runs inside a
Linux VM and clamping the client changes nothing; `hyperfine`, because clamping
a benchmark harness invalidates its measurements; and `git`, which is
overwhelmingly short and interactive.

Set `PRIORITY_AUTO=0` in `~/.zshrc.local` to disable automatic dispatch while
keeping the commands available by hand. `PRIORITY_HEAVY_CLAMP` (default
`utility`) and `PRIORITY_HOG_THRESHOLD` (default `25`) tune the rest. After
extending `PRIORITY_WRAP` from the local override, call `priority-rewrap`,
because the wrappers are generated when the module is sourced.

Measured on Apple silicon with four performance and six efficiency cores:
three equal CPU loops running together took 76%, 16% and 13% of a core when
started plain, under `heavy` and under `idle` respectively. The module costs
roughly 3 ms of CPU at startup plus one `taskpolicy` call in interactive
shells. On a host without `taskpolicy` it degrades to `nice`, and the
inspection commands report that they are unavailable.

Validate changes with:

```bash
zsh -n zsh/.zshrc zsh/*.zsh
zsh -c 'source ./zsh/env.zsh; command -v <affected-tool>'
autoload -Uz compaudit
compaudit
```
