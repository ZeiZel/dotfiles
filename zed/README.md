# Zed navigation

Zed keeps the JetBrains base keymap and enables `vim_mode` in `settings.json`.
This gives normal/insert/visual modes without replacing Zed's non-modal
shortcuts. `keymap.json` adds the small set of project-specific muscle-memory
bindings used in Neovim.

## Core navigation

- In Vim normal mode, `Ctrl+H/J/K/L` moves between editor panes.
- The same keys move between Zed docks (project panel, terminal and other
  docked panels). Terminal intentionally receives these keys too, so they
  override shell line editing while the terminal has focus.
- `Space W H/J/K/L` is the explicit pane-navigation form; `|` and `\\` split
  vertically/horizontally and `Space W Q` closes the active item.
- `Ctrl+PageUp/PageDown` changes tabs; `Ctrl+Shift+PageUp/PageDown` swaps tabs.
- `Space E`, `Space Space`, `Space /`, `Space S B`, `Space T`, `Ctrl-/` focus the
  project panel, file finder, project search, buffer search, terminal and
  terminal panel respectively. `Space G G` focuses Git.

## Code actions

`G D`, `G I`, `G R`, `Shift-K`, `Space C R`, `Space C A`, `Space C F`, `[ D` and
`] D` map to definition, implementation, references, hover, rename, code
actions, formatting and previous/next diagnostic. `Space G D/B/L/H/S/U` provide
diff, blame, line blame, Git Graph, stage and unstage.

Zed waits briefly after a standalone `Space` to determine whether a leader
chord follows (about one second); the configured chords work as expected.

## Deliberate limits

Zed cannot make `Ctrl+H/J/K/L` universal in every text-entry widget without
stealing characters from typing. The bindings apply in Vim normal mode and
panels; terminal navigation is deliberately universal to match Neovim's pane
muscle memory, so shell users should use arrow keys or readline alternatives
when the terminal is focused. Tab/Shift-Tab are scoped to Vim normal mode.
Zed's Vim mode is not a complete Neovim runtime: plugins, Treesitter motions,
custom operators and Neovim-only panels do not carry over.
