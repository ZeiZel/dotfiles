# Herdr configuration

Herdr is the optional terminal workspace for normal local interactive Zsh
shells; Tmux + Workmux are the default backend. Select Herdr with
`ZSH_MULTIPLEXER=herdr` in `~/.zshrc.local`. Homebrew installs Herdr, this
directory owns its user configuration, and the `dotfiles` Ansible role installs
the pinned reviewr plugin. The Tmux configuration is deployed separately from
`tmux/`.

Both workspaces share the `Ctrl+A` prefix, so `config.toml` mirrors
`tmux/tmux.binds.conf` key for key. Change one and change the other in the same
commit.

## Terminology

| Tmux    | Herdr               |
| ------- | ------------------- |
| session | workspace ("space") |
| window  | tab                 |
| pane    | pane                |

## Key map

Prefix is a sequence, not a chord: press `Ctrl+A`, release, then press the next
key. `Ctrl+A` twice sends a literal `Ctrl+A` to the focused program.

### Spaces (Tmux sessions)

| Action              | Key             | Tmux |
| ------------------- | --------------- | ---- |
| Space navigator     | `Prefix s`      | `s`  |
| Space picker        | `Prefix Shift+S`| —    |
| New space           | `Prefix Shift+C`| `C`  |
| Rename space        | `Prefix $`      | `$`  |
| Close space         | `Prefix Shift+X`| `X`  |
| Previous / next     | `Prefix (` / `)`| `(` / `)` |

### Worktrees (Tmux Workmux popups)

| Action          | Key              | Tmux |
| --------------- | ---------------- | ---- |
| Open worktree   | `Prefix w`       | `w`  |
| New worktree    | `Prefix Shift+W` | `W`  |
| Remove worktree | `Prefix Shift+D` | `w` → `c` |

### Tabs (Tmux windows)

| Action            | Key                | Tmux    |
| ----------------- | ------------------ | ------- |
| New tab           | `Prefix c`         | `c`     |
| Rename tab        | `Prefix ,`         | `,`     |
| Close tab         | `Prefix &`         | `&`     |
| Previous / next   | `Prefix Ctrl+H` / `Ctrl+L` | `C-h` / `C-l` |
| Select tab 1..9   | `Prefix 1`..`9`    | `1`..`9`|

### Panes

| Action                | Key                          | Tmux |
| --------------------- | ---------------------------- | ---- |
| Split right           | `Prefix \|`                  | `\|` |
| Split down            | `Prefix -`                   | `-`  |
| Focus pane            | `Prefix h/j/k/l`             | `h/j/k/l` |
| Cycle panes           | `Prefix o` / `Shift+O`       | `o`  |
| Last pane             | `Prefix ;`                   | `;`  |
| Resize by 5 %         | `Prefix Shift+H/J/K/L`       | `H/J/K/L` |
| Resize mode           | `Prefix Alt+R`               | —    |
| Swap with neighbor    | `Prefix {` / `}`             | `{` / `}` |
| Break into a new tab  | `Prefix !`                   | `!`  |
| Close pane            | `Prefix x`                   | `x`  |
| Zoom pane             | `Prefix z`                   | `z`  |
| Rename pane           | `Prefix Shift+P`             | —    |
| Scrollback in `$EDITOR` | `Prefix [`                 | `[` (copy-mode) |

### Session and UI

| Action                    | Key              | Tmux |
| ------------------------- | ---------------- | ---- |
| Detach                    | `Prefix d`       | `d`  |
| Help                      | `Prefix ?`       | `?`  |
| Reload config             | `Prefix r`       | `r`  |
| Toggle sidebar            | `Prefix t`       | `t` (status bar) |
| Settings                  | `Prefix Alt+S`   | —    |
| Jump to notification      | `Prefix Alt+O`   | —    |
| Toggle reviewr            | `Prefix Shift+R` | —    |

### Popups

| Popup             | Key        | Tmux |
| ----------------- | ---------- | ---- |
| Lazygit           | `Prefix g` | `g`  |
| Btop              | `Prefix b` | `b`  |
| Yazi              | `Prefix y` | `y`  |
| fzf file finder   | `Prefix f` | `f`  |
| Notes scratchpad  | `Prefix n` | `n`  |

### Deliberate gaps

Herdr accepts one key per action, so the Tmux aliases `\`, `_` and `p` have no
Herdr counterpart. Herdr also has no action for `Prefix Tab` (Tmux
`last-window`), `<` / `>` (`swap-window`) or `Prefix S` (`synchronize-panes`),
and no equivalent of the `M-1`..`M-5` preset layouts.

`Prefix Shift+H/J/K/L`, `Prefix {`, `Prefix }` and `Prefix !` are not Herdr
actions either. They are `type = "shell"` bindings that call the Herdr CLI;
because the spawned process has no `HERDR_PANE_ID`, the CLI resolves to the
UI-focused pane, which is what a keybinding needs.

`Prefix a` and `Prefix A` toggle the tmux-agent-sidebar in the current window
and in every window. They have no Herdr counterpart and are not expected to
gain one: the sidebar is a TPM plugin that discovers agent panes by walking a
tmux server, so it has nothing to attach to under Herdr.

## Notifications

`[ui.toast] delivery = "system"` sends background agent state changes (finished
work, or an agent blocked on a prompt) to the macOS notification centre instead
of keeping them inside the terminal. Herdr prefers `terminal-notifier`, which
the Brewfile installs on macOS, so clicking a banner activates the host
terminal; without it Herdr falls back to `osascript -e 'display notification'`.

macOS only shows these once the delivering binary is allowed to post
notifications in *System Settings → Notifications*. Verify delivery with:

```bash
herdr notification show "Herdr" --body "test" --sound done
```

Notifications fire for background spaces; `Prefix Alt+O` jumps to the pane that
raised the last one. Sounds stay disabled in `[ui.sound]`; set
`enabled = true` there to add an audio cue.

Reviewr starts manually rather than on every worktree. It compares the current
branch against the first available base from `dev`, `develop`, `main`, and
`master`. Its PR/MR view uses an already authenticated `gh`, `glab`, or `az`.

## State ownership

Only these files are tracked:

- `config.toml`: Herdr UI, shell, workspace, key and popup behavior.
- `plugins/config/persiyanov.reviewr/config.toml`: reviewr preferences.

Herdr logs, sockets, sessions, plugin checkouts and runtime state live under
`~/.config/herdr` but must never be adopted into this repository.

Validate changes with:

```bash
herdr config check
herdr server reload-config
herdr plugin list --json
herdr plugin action list --plugin persiyanov.reviewr
```

`herdr config check` reports invalid key syntax and conflicts between keys that
are set explicitly. It cannot see a conflict with a default binding, so keep
every action listed in `config.toml` even when the value matches the default.
