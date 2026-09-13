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

## YAML dialects

`file_types` in `settings.json` decides which language a YAML file opens as.
Two dialects are pulled out of plain YAML:

| Pattern | Language | Why |
| --- | --- | --- |
| `*.tpl.yaml`, `*.tpl.yml`, `*.yaml.j2`, `*.yml.j2` | Ansible | Jinja2 plus envsubst inputs; invalid YAML until rendered, and the language server stays off |
| `**/templates/**/*.{yaml,yml,tpl}` | Helm | Chart templates; `helm_ls` attaches |
| `**/*values.yaml`, `**/*values.yml`, `values.yaml`, `values.yml` | Helm | Chart values; `helm_ls` resolves them against the chart |

The Helm extension claims only `.helmignore` by itself, so without these entries
a chart opens as YAML and every `{{ ... }}` reads as a syntax error.

Two properties of `file_types` are worth knowing, because both were measured
rather than assumed:

- **A glob is matched against the path relative to the worktree root.** With the
  project folder open, `deploy/helm/analytics/templates/secret.yaml` matches
  `**/templates/**/*.yaml`. Open that same file on its own (`zed path/to/
  secret.yaml`) and its worktree root is its own directory, the relative path is
  just `secret.yaml`, and the `templates/` rule cannot match. The
  `*values.yaml` rules have no directory component and work either way.
- **A glob cannot test for a sibling `Chart.yaml`.** "Inside a `templates/`
  directory" is the closest expressible approximation, so a `templates/`
  directory of plain YAML that is not a chart opens as Helm too. Override it in
  that project's own `.zed/settings.json`:

  ```json
  { "file_types": { "YAML": ["**/docs/**/templates/**/*.yaml"] } }
  ```

`*values.yaml` matches the literal substring on purpose rather than
`values*.yaml`, which keeps rentverse's `values.tpl.yaml` on the Ansible entry.

## Language support

Zed ships Rust, Go, TypeScript/TSX, Bash, JSON, YAML, TOML, CSS and Tailwind in
the box. `auto_install_extensions` declares the rest of the stack that Zed
cannot handle on its own, so a fresh host converges without clicking through the
extensions panel.

Two settings are easy to miss because Zed ships them off:

- **`diagnostics.inline.enabled`.** Off by default, which leaves a message
  reachable only through the gutter or hover.
- **`inlay_hints.enabled`.** Also off, and turning it on is only half the
  switch. rust-analyzer emits hints unprompted, but **gopls and vtsls send
  nothing unless their own server settings ask for them** — that is why both
  appear under `lsp` with explicit hint options. Holding `Ctrl` hides the hints
  again on a crowded line.

`lsp.gopls` also enables `staticcheck`, which adds the analyzer set `go vet`
does not cover.

## YAML schemas

`yaml-language-server` resolves most schemas from SchemaStore by filename, which
already covers `docker-compose.yml`, GitHub workflows and similar well-known
names. Plain Kubernetes manifests are the gap: nothing inside `deployment.yaml`
identifies its schema, so `lsp.yaml-language-server` maps the usual manifest
directories (`k8s/`, `kubernetes/`, `manifests/`, `deploy/`, `.infra/`) to the
strict Kubernetes schema by path.

Chart templates are deliberately not in that mapping — `file_types` routes them
to Helm and `helm_ls`, and a Go-templated manifest does not validate as YAML.

## Deliberate limits

Zed cannot make `Ctrl+H/J/K/L` universal in every text-entry widget without
stealing characters from typing. The bindings apply in Vim normal mode and
panels; terminal navigation is deliberately universal to match Neovim's pane
muscle memory, so shell users should use arrow keys or readline alternatives
when the terminal is focused. Tab/Shift-Tab are scoped to Vim normal mode.
Zed's Vim mode is not a complete Neovim runtime: plugins, Treesitter motions,
custom operators and Neovim-only panels do not carry over.
