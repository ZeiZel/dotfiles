# AI agent guide

<!-- markdownlint-disable MD013 -->

This file is the operational specification for AI agents working in this
repository. Read it before making changes. Human-facing setup and usage remain
in `README.md`; component details live in their local README files.

## Repository purpose

This repository is the source of truth for a personal macOS/Linux development
environment. It combines:

- Ansible for host provisioning and repeatable installation.
- Homebrew Bundle for cross-platform CLI tools and macOS applications.
- GNU Stow plus explicit Ansible links for configuration deployment.
- LazyVim, Zsh, Herdr, Git, terminal and desktop application configuration.

Changes may affect the host machine when applied. Editing repository files is
not the same as applying them; keep those two actions explicit.

## Start-of-work protocol

1. Run `BEADS_DOLT_SHARED_SERVER=1 bd --global prime --memories-only`.
2. Run `bd prime` and follow the injected project workflow.
3. Inspect `git status --short`. Preserve every pre-existing change.
4. Read the files that own the requested behavior before editing them.
5. Create and claim a Beads issue for implementation work. Use Beads for task
   state and durable verified facts, not markdown TODO lists.
6. Do not commit, push, rewrite history, or publish releases unless the user
   explicitly asks.

Never copy values from private global Beads memory into repository files,
logs, command arguments or user-facing output. Never read credential-file
contents. Local identity is cached outside the repository under
`~/.dotfiles-cache/`.

## Architecture and ownership

| Area | Source of truth | Responsibility |
| --- | --- | --- |
| Orchestration | `all.yml` | Platform variable loading and ordered role execution |
| Shared variables | `group_vars/all.yml` | Home/config/repository paths |
| macOS variables | `group_vars/darwin.yml` | Homebrew prefix and macOS preferences |
| Linux variables | `group_vars/linux.yml` | Homebrew prefix and distro bootstrap packages |
| Packages | `Brewfile` | Homebrew taps, formulae, casks and fonts |
| Provisioning | `roles/*/tasks/main.yml` | Idempotent host mutations |
| Role contracts | `roles/*/defaults/main.yml` | Defaults and variable ownership |
| Dotfile deployment | `roles/dotfiles/tasks/main.yml`, `.stowrc` | Stow and explicit home-directory links |
| Neovim | `nvim/` | LazyVim specification, plugins and editor tooling |
| IDE roadmap | `docs/NEOVIM_IDE_PLAN.md` | Performance contract, provider matrix and staged JetBrains-parity plan |
| Daily key reference | `docs/CHEATSHEET.md` | Verified Neovim, shell, Herdr, Lazygit and Git workflows |
| Shell | `zsh/` | Environment, aliases, plugins, widgets and startup behavior |
| Git | `git/` | Global Git config, ignore rules and helpers |
| Terminal/UI | `tmux/`, `workmux/`, `herdr/`, `ghostty/`, `wezterm/`, `starship/`, `aerospace/` | Active terminal/workspace configuration |
| Workspace UI | `herdr/` | Optional Herdr/reviewr configuration; Tmux/Workmux are the default |
| CLI applications | `atuin/`, `lazygit/`, `posting/`, `yazi/` | Application-native configuration |
| Windows/WSL | `wsl/` | WSL-only helpers; do not assume macOS behavior |

`all.yml` executes roles in this order: platform (`macos` or `linux`),
`homebrew`, `dotfiles`, `git`, `node`, then `docker`. Preserve this dependency
order unless there is an explicit architectural reason to change it.

## Change rules by subsystem

### Ansible and Homebrew

- Prefer idempotent Ansible modules over shell commands.
- Every command/shell task must have accurate `changed_when`; probe tasks
  should normally use `changed_when: false`.
- Registered role variables must use the role prefix, for example
  `homebrew_*` inside the `homebrew` role.
- Keep OS-specific values in the appropriate `group_vars` file rather than
  branching throughout unrelated configuration.
- Add durable host packages to `Brewfile`. Mason-owned editor binaries belong
  in Neovim configuration, not in `Brewfile`.
- Homebrew casks own direct-download macOS applications. `mas` owns only
  App Store applications; because `mas list` can block on Spotlight, the
  Homebrew role checks their `.app` bundles before calling `mas get`.
- On an existing Mac, the Homebrew role also treats a pre-existing `.app`
  bundle as satisfied and passes its cask through
  `HOMEBREW_BUNDLE_CASK_SKIP`. Clean hosts still install those applications
  from their Brewfile casks; routine runs never overwrite or stop a running
  manually installed copy.
- Homebrew cask upgrades can stop applications and request interactive sudo.
  Do not run a full `brew bundle install` merely to validate a small edit.
- The Docker role differs materially by platform: Docker Desktop on macOS,
  vendor Docker Engine plus system services and group membership on
  Ubuntu/Debian. It must never reboot the host automatically.
- `roles/dotfiles/tasks/main.yml` uses `stow --restow --no-folding`. Never add
  `--adopt`: host files must not overwrite repository sources.
- Tmux and Workmux are Homebrew-managed and deployed through Stow. Tmux is
  the default Zsh multiplexer; `ZSH_MULTIPLEXER=herdr` selects Herdr and
  `ZSH_MULTIPLEXER=none` selects a plain shell. All backends guard SSH, IDE,
  nested, dumb and non-TTY shells. TPM is provisioned at its pinned commit
  after Stow and installs declared Tmux plugins. Herdr is
  Homebrew-managed: the `dotfiles` role pins
  reviewr, starts its user service on macOS and installs current integrations
  only for locally available Codex, Claude and Hermes commands.

### Neovim

Read `nvim/README.md` before editing.

- `nvim/lazyvim.json` selects supported language ecosystems.
- LazyVim language extras own language-specific LSP, DAP and test setup.
- `lua/plugins/mason.lua` declares editor-managed external binaries.
- `lua/plugins/conform.lua` owns formatting; LSP formatting is fallback only.
- `lua/plugins/code.lua` owns additional CLI lint mappings.
- `lua/plugins/lspconfig.lua` contains only shared diagnostics and servers not
  already owned by a language extra.
- `lua/plugins/ide.lua` owns the cross-language IDE lifecycle: Overseer tasks,
  JavaScript test-adapter selection, persistent DAP breakpoints, refactoring,
  REST requests and coverage display.
- Overseer is the sole task/run-configuration owner; Neotest is the sole test
  UI; nvim-dap is the sole debugger; Kulala owns `.http` and `.rest` files.
- `lua/util/js_test_runner.lua` must allow at most one Jest/Vitest adapter to
  claim a test file. Update its fixtures whenever project-marker logic changes.
- Coverage plugins only display reports. Generation belongs to project tasks
  and must not run automatically on buffer events.
- Do not introduce a second TypeScript, Go, Rust or C# client.
- Do not import language extras again from `lua/plugins/`; `lazyvim.json` is
  their only selection point.
- Git workflow is intentionally split between Neogit, Diffview and Gitsigns in
  `lua/plugins/git.lua`.
- `persistence.nvim` is the sole session owner; restoration is deliberately
  manual. Remote, Posting and Lazydocker integrations load only on their
  commands or mappings.
- `lua/plugins/session.lua` also owns the workspace snapshot in
  `stdpath("state")/workspace/`: explorer expansion and the "panel was open"
  flag, keyed by the same cwd+branch name persistence uses. It is written from
  `PersistenceSavePost` only, so a declined session never erases it, and panel
  windows are closed from `PersistenceSavePre` so session files hold editor
  windows only. Do not add a second session or project-state restorer.
- `lua/plugins/ui.lua` owns the IDE chrome: bufferline offsets and project
  header, the single lualine statusline, dropbar breadcrumbs and the
  nvim-lightbulb code action indicator. `winbar` belongs to dropbar alone;
  `vim.g.trouble_lualine` stays false so the symbol trail is not duplicated in
  the statusline. Statusline components must stay allocation-light and must
  never start a process.
- `multicursor.nvim` in `lua/plugins/movements.lua` is the sole multiple-cursor
  owner and must load from its mappings, never from `VeryLazy`.
- `edgy.nvim` (selected in `lazyvim.json`, configured in `lua/plugins/ui.lua`)
  owns where a tool window is docked and how large it is. The Snacks explorer
  is docked through its `snacks_layout_box` split, with the edgy winbar and
  edge animation disabled: the picker's input and list are floats anchored to
  that split, and an animated resize cannot move them. Only the `<leader>gs`
  Neogit window is docked, matched on the `dotfiles_git_panel` window variable
  so the full-tab `<leader>gg` status keeps the whole width. Overseer's list
  and its output window must be docked together; docking only one leaves the
  other floating in the editor area.
- `catppuccin` in `lua/plugins/init.lua` is the only colour scheme owner and
  must stay aligned with the Ghostty theme; the editor background is
  transparent, so a mismatch is visible in every uncovered cell. Override
  highlights through `custom_highlights`, never with a stray `nvim_set_hl`.
  Panels must resolve to `Normal`, not `NormalFloat`: link them, because a
  group whose only attribute is `bg = "NONE"` counts as undefined and edgy's
  `default` link back to `NormalFloat` then wins. Floating pickers and the
  completion menu keep their opaque background and must stay readable over
  code. When checking a highlight, resolve the link chain with `:hi <group>`;
  `nvim_get_hl(0, { link = false })` returns the group's own definition, which
  is empty for a pure link and reads as a false "NONE".
- `sidekick.nvim` in `lua/plugins/ide.lua` is the only in-editor AI surface. It
  must stay mapping-lazy, must never store a key or send a buffer on its own,
  and Copilot NES stays gated on `copilot-language-server` being executable.
  Herdr keeps the workspace-level Codex/Claude/Hermes integrations.
- noice owns the message, cmdline and LSP progress UI, and the Snacks notifier
  renders the toasts it routes to `vim.notify`. Nothing else may replace
  `vim.notify`. Route new message noise to the `mini` view or skip it
  explicitly; never silence a whole event class.
- Keep `lazy-lock.json` synchronized when plugin resolution changes.
- Heavy IDE plugins must have an explicit command, mapping, narrow filetype or
  language-extra trigger. Do not use broad `BufReadPre`/`BufEnter` hooks for
  tasks, tests, DAP, REST, coverage, refactoring or external TUIs.
- Empty startup must leave Telescope, Overseer, Neotest, nvim-dap, Kulala,
  refactoring, coverage and persistent-breakpoints unloaded. Treat a change
  that eagerly loads one of them as a performance regression unless a measured
  user-facing benefit justifies it.
- Global application of this repository is a separate host mutation. Verify
  `realpath ~/.config/nvim` before claiming that repository edits are active.

### Zsh

Read `zsh/README.md` before editing.

- `zsh/.zshrc` owns an explicit source manifest. A new `*.zsh` file is inert
  until placed in that manifest at the correct widget/keymap phase.
- `env.zsh` owns environment variables and `PATH`; `plugins.zsh` owns plugin
  loading; `init.zsh` owns runtime initialization and generated caches.
- Zsh plugins are versioned Homebrew formulae. Shell startup must not clone,
  update, or defer-load plugin repositories.
- Emacs is the sole ZLE keymap. Up/Down own native history, while Atuin owns
  `Ctrl+R`.
- `multiplexer-auto.zsh` runs last, after `~/.zshrc.local`, and dispatches
  `ZSH_MULTIPLEXER` (`tmux` default, `herdr`, or `none`). Invalid values fail
  safe to a plain shell. Backend scripts must skip any nonempty `HERDR_ENV`,
  Tmux, SSH, IDE, dumb and non-interactive shells. Legacy
  `ZSH_HERDR_AUTOSTART=0` and `ZSH_TMUX_AUTOSTART=0` remain secondary kill
  switches.
- `priority.zsh` owns macOS scheduling policy and is the only place that calls
  `taskpolicy`. It may only demote: a negative `renice` needs root and an
  interactive shell already holds the highest class it can reach, so `boost`
  undoes a demotion rather than granting one. Never add Docker, Minikube,
  `hyperfine` or `git` to `PRIORITY_WRAP`; the first two do their work outside
  the clamped process, clamping the third invalidates benchmarks, and the
  fourth is short and interactive.
- Put personal or machine-local values in an untracked local override, never
  in tracked files.
- Startup must remain silent, non-interactive and safe when optional commands
  are missing. A sourced module must end with a statement that succeeds, or
  `zsh -ic` automation reads the nonzero status as a startup failure.

### Application configuration

- Follow the application's native syntax and keep changes inside its directory.
- Avoid duplicating a setting in shell aliases, Ansible and application config
  unless the layers have distinct responsibilities.
- Generated state, caches, logs, sessions and credential material must not be
  committed.

### Herdr

Read `herdr/README.md` before editing.

- `herdr/config.toml` owns prefix, workspace, pane, UI and custom-command
  behavior. Keep the inherited Tmux prefix `Ctrl+A`.
- `tmux/tmux.plugins.conf` owns session persistence. tmux-resurrect saves and
  tmux-continuum schedules; `exit-empty off` in `tmux.options.conf` keeps the
  server alive with no sessions so the autostart can hand a cold server to
  continuum before creating anything. Never let `zsh/tmux-auto.zsh` create
  session `main` on a cold server ahead of the restore: restoring on top of an
  existing target session leaves duplicate panes in the windows rebuilt last.
  Keep `@continuum-boot` off, because its macOS implementation launches
  Terminal.app, iTerm, kitty or Alacritty and has no Ghostty strategy; the
  `com.dotfiles.tmux-server` LaunchAgent in `roles/macos` starts the server
  headless at login instead and runs `tmux/tmux-server-boot.sh`. That plist
  must keep the Homebrew prefix in `EnvironmentVariables.PATH`: continuum and
  resurrect call `tmux` unqualified, and under launchd's minimal PATH the
  restore fails silently. It must stay free of `KeepAlive`, because
  `tmux start-server` daemonizes and returns.
- `roles/dotfiles` also registers the sidebar with the agents that report to
  it: `claude plugin marketplace add` plus `claude plugin install`, and
  `files/configure-codex-sidebar.py` for Codex. Both are guarded by a `which`
  probe so a host without that CLI is skipped. The Codex helper edits files the
  user owns, so it must stay a merge that preserves unknown hooks, matches
  entries by command, and writes a `.bak` first. `tmux-agent-sidebar setup
  codex` only prints its hooks; it never writes them.
- `tmux/tmux.binds.conf` owns the canonical key map, and Herdr mirrors it key
  for key. Both workspaces share `Ctrl+A`, so a binding change in one requires
  the matching change in the other, in the same commit, with the Tmux binding
  named in the Herdr comment.
  Record any binding Herdr cannot express under "Deliberate gaps" in
  `herdr/README.md`.
- `Ctrl+A`, then `g` owns the full-terminal Lazygit popup. Move any default
  action that would consume `prefix+g` before changing this mapping.
- `herdr config check` only detects conflicts between explicitly configured
  keys. Every action therefore stays listed in `config.toml`, including values
  that match the Herdr default.
- Background agent notifications use `[ui.toast] delivery = "system"`, backed
  by the macOS-only `terminal-notifier` in the Brewfile with an `osascript`
  fallback. Delivery still depends on host notification permission, which is
  user state and must not be changed silently.
- Reviewr user settings live only in
  `herdr/plugins/config/persiyanov.reviewr/config.toml`; its executable
  checkout and plugin registry are runtime state under `~/.config/herdr`.
- Reviewr is a community plugin without marketplace sandboxing. Inspect its
  manifest and build command before changing the pinned ref in role defaults.
- Pane-history persistence stays disabled because scrollback can contain
  credentials or private output. Do not stop a running Herdr server or delete
  a session as a validation step.

## Validation matrix

Run the smallest relevant set, then a clean final check.

### Always

```bash
git diff --check
git status --short
```

### Validate Ansible

```bash
ANSIBLE_LOCAL_TEMP=/private/tmp/ansible-dotfiles-tmp \
  ansible-playbook -i inventory/hosts.ini all.yml --syntax-check

ANSIBLE_LOCAL_TEMP=/private/tmp/ansible-dotfiles-tmp \
  ansible-lint <changed-yaml-files>
```

Use `--check --diff` and role tags for an application dry run when the target
host and required privileges are available. A syntax check does not authorize
applying the playbook.

### Validate Brewfile

```bash
brew bundle check --file Brewfile --verbose
```

This may need network/cache access and reports outdated packages as unsatisfied.
Do not upgrade packages unless the task asks to apply or update the host.

### Validate Neovim

```bash
jq empty nvim/lazyvim.json nvim/lazy-lock.json
stylua --check <changed-lua-files>
nvim --headless '+qa'
```

If `stylua` is Mason-managed, use
`~/.local/share/nvim/mason/bin/stylua`. For plugin changes, also load the
changed plugin explicitly or invoke its command headlessly. For language
changes, verify that the intended LSP attaches to a representative file.

For performance-sensitive changes, capture both the empty-start loaded-plugin
set and a timed sample before and after:

```bash
hyperfine --warmup 3 --runs 10 'nvim -i NONE --headless +qa'
```

Timing on a busy host may contain outliers; the deterministic lazy graph is the
hard gate. Do not report a timing regression from a noisy sample without
repeating it under comparable conditions.

### Validate Zsh

```bash
zsh -n zsh/.zshrc zsh/*.zsh
```

For environment changes, source `zsh/env.zsh` in a child `zsh -c` process and
verify the affected command. Do not source the full interactive shell in the
agent process.

### Validate Herdr

```bash
herdr config check
herdr status
herdr plugin list --json
herdr plugin action list --plugin persiyanov.reviewr
herdr integration status --outdated-only
```

The plugin list takes a write lock in `~/.config/herdr`; a restricted sandbox
may therefore require host permission even though the validation is otherwise
read-only.

## Definition of done

- The repository source of truth and any explicitly requested host state agree.
- No unrelated user edits were overwritten.
- Ownership boundaries above are preserved; no duplicate tool/provider was
  introduced.
- Relevant validation commands pass, or the exact external blocker is
  reported.
- Documentation is updated when mappings, entry points, role order or
  operational behavior changes.
- Verified durable architecture facts are updated in project Beads memory.
- The Beads issue for the work is closed before reporting completion.
