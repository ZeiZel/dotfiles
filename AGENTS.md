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
| Optional workspace UI | `herdr/` | Retained manual Herdr/reviewr configuration |
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
- Tmux and Workmux are Homebrew-managed and deployed through Stow. The Zsh
  handoff enters Tmux only for normal local interactive terminals and guards
  SSH, IDE, nested-Tmux, Herdr, dumb and non-TTY shells. TPM is provisioned at
  its pinned commit after Stow and installs declared Tmux plugins. Herdr is
  retained as an optional Homebrew-managed manual UI: the `dotfiles` role pins
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
- `tmux-auto.zsh` runs last and enters Tmux by default only for normal local
  terminal windows. It must skip `HERDR_ENV=1`, Tmux, SSH, IDE, dumb and
  non-interactive shells. `ZSH_TMUX_AUTOSTART=0` is the local escape hatch.
- Put personal or machine-local values in an untracked local override, never
  in tracked files.
- Startup must remain silent, non-interactive and safe when optional commands
  are missing.

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
- `Ctrl+A`, then `g` owns the full-terminal Lazygit popup. Move any default
  action that would consume `prefix+g` before changing this mapping.
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
