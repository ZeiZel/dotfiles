# Herdr configuration

Herdr is an optional manual terminal workspace UI. Tmux + Workmux are the
primary terminal workspace; Homebrew installs Herdr, this directory owns its
user configuration, and the `dotfiles` Ansible role installs the pinned reviewr
plugin. The Tmux configuration is deployed separately from `tmux/`.

## Daily workflow

- `Ctrl+A`, then `g`: open Lazygit in a full-terminal popup.
- `Ctrl+A`, then `Shift+R`: toggle reviewr over the active tab.
- `Ctrl+A`, then `f`: open the session navigator.
- `Ctrl+A`, then `w`: open the workspace picker.
- `Ctrl+A`, then `v` or `-`: split right or down.
- `Ctrl+A`, then `h/j/k/l`: move between panes.
- `Ctrl+A`, then `q`: detach while keeping panes running.
- `Ctrl+A`, then `Ctrl+A`: send a literal `Ctrl+A` to the focused application.

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
herdr plugin list --json
herdr plugin action list --plugin persiyanov.reviewr
```
