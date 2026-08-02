# Dotfiles

<!-- markdownlint-disable MD013 -->

Personal dotfiles for macOS/Linux with Zsh, Herdr, Neovim, and modern CLI
tools. Fully automated setup via Ansible.

AI agents must read [AGENTS.md](AGENTS.md) before changing the repository. It
defines architecture, ownership boundaries, host-mutation safety and the
required validation matrix.

The complete terminal-IDE design is in
[docs/NEOVIM_IDE_PLAN.md](docs/NEOVIM_IDE_PLAN.md). The short daily reference
for Neovim, Zsh, Herdr, Lazygit and Git is
[docs/CHEATSHEET.md](docs/CHEATSHEET.md).

## Quick Install

```bash
sh -c "$(curl -fsSL https://github.com/ZeiZel/dotfiles/raw/main/install.sh)"
```

### AI-only install

To install only the AI tooling (Qdrant, MCP servers, Claude Code config)
without the full dotfiles setup:

```bash
sh -c "$(curl -fsSL https://github.com/ZeiZel/dotfiles/raw/main/setup-ai.sh)"
```

Requires Ansible and Docker to be installed first (run `install.sh` if not).

### Post-install

```bash
# Neovim: Lazy and Mason reconcile declared plugins and editor tools
nvim

# Herdr, reviewr, agent integrations and Broot are provisioned automatically.
```

---

## Stack

| Category        | Tool                                                      |
| --------------- | --------------------------------------------------------- |
| Terminal        | [Ghostty](https://ghostty.org/)                           |
| Shell           | Zsh + versioned Homebrew plugins                          |
| Prompt          | [Starship](https://starship.rs/)                          |
| Workspace       | [Herdr](https://herdr.dev/) + reviewr                     |
| Editor          | [Neovim](https://neovim.io/)                              |
| File Manager    | [Yazi](https://yazi-rs.github.io/)                        |
| History         | [Atuin](https://atuin.sh/)                                |
| Tiling (macOS)  | [Aerospace](https://github.com/nikitabobko/AeroSpace)     |
| Package Manager | [Homebrew](https://brew.sh/)                              |
| Theme           | Catppuccin Mocha                                          |

---

## Directory Structure

```text
dotfiles/
├── zsh/                  # Zsh configuration
│   ├── .zshrc           # Entry point
│   ├── aliases.zsh      # 370+ aliases
│   ├── functions.zsh    # Helper functions
│   ├── plugins.zsh      # Homebrew-managed Zsh plugins
│   ├── env.zsh          # Environment variables
│   ├── fzf.zsh          # FZF configuration
│   ├── init.zsh         # Tool initialization
│   ├── kbd.zsh          # Key bindings
│   ├── options.zsh      # Shell options
│   ├── theme.zsh        # Catppuccin colors
│   └── herdr-auto.zsh   # Default terminal-to-Herdr handoff
├── herdr/                # Primary terminal workspace configuration
│   ├── config.toml      # Prefix, panes, UI and Lazygit popup
│   └── plugins/         # Declarative reviewr configuration
├── tmux/                 # Legacy fallback; retained but not provisioned
│   ├── tmux.conf        # Main config
│   ├── tmux.binds.conf  # Key bindings
│   ├── tmux.options.conf
│   ├── tmux.plugins.conf
│   └── tmux.theme.conf  # Catppuccin theme
├── nvim/                 # Neovim configuration
├── starship/             # Starship prompt
├── yazi/                 # Yazi file manager
├── lazygit/              # Lazygit config
├── ghostty/              # Ghostty terminal
├── aerospace/            # AeroSpace tiling window manager
├── git/                  # Git configuration
├── Brewfile              # Homebrew packages
├── all.yml               # Ansible playbook
└── roles/                # Ansible provisioning roles
```

---

## Modern CLI Replacements

These modern tools replace classic Unix utilities with better UX:

| Classic | Modern    | Description                                        |
| ------- | --------- | -------------------------------------------------- |
| `ls`    | `eza`     | File listing with icons, git status, tree view     |
| `cat`   | `bat`     | Syntax highlighting, line numbers, git integration |
| `find`  | `fd`      | Faster, respects .gitignore, simpler syntax        |
| `grep`  | `ripgrep` | Ultra-fast search, respects .gitignore             |
| `cd`    | `zoxide`  | Smart cd that learns your habits (`z project`)     |
| `diff`  | `delta`   | Beautiful diffs with syntax highlighting           |
| `du`    | `dust`    | Intuitive disk usage analyzer                      |
| `df`    | `duf`     | Better disk free output                            |
| `ps`    | `procs`   | Modern process viewer                              |
| `top`   | `btop`    | Beautiful resource monitor                         |
| `dig`   | `doggo`   | Modern DNS client                                  |
| `watch` | `viddy`   | Modern watch with diff highlighting                |
| `sed`   | `sd`      | Simpler, faster sed alternative                    |
| `cut`   | `choose`  | Easier column selection                            |

### New Tools

| Tool         | Alias           | Description                    |
| ------------ | --------------- | ------------------------------ |
| `xh`         | `xget`, `xpost` | Fast HTTPie alternative (Rust) |
| `jless`      | `jl`            | Interactive JSON viewer        |
| `difftastic` | `dft`           | Structural diff (AST-aware)    |
| `ast-grep`   | `sg`            | Structural search and rewrite  |
| `broot`      | `br`            | Interactive tree navigator     |
| `navi`       | `nav`, `Ctrl+G` | Interactive cheatsheets        |
| `bandwhich`  | `bw`            | Network bandwidth monitor      |
| `lnav`       | `logs`          | Log file navigator             |
| `hyperfine`  | `bench`         | CLI benchmarking               |
| `tokei`      | `loc`           | Code statistics                |
| `glow`       | `mdp`           | Markdown preview               |
| `gping`      | `gpingg`        | Ping with graph                |

---

## TUI Applications

| App | Alias | Description |
| --- | --- | --- |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg` | Git TUI |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | `ld` | Docker TUI |
| [btop](https://github.com/aristocratos/btop) | `bt` | Resource monitor |
| [k9s](https://k9scli.io/) | `k9` | Kubernetes TUI |
| [yazi](https://yazi-rs.github.io/) | `ya`, `yy` | File manager |
| [dive](https://github.com/wagoodman/dive) | `div` | Docker image analyzer |
| [posting](https://github.com/darrenburns/posting) | `post` | HTTP client TUI |
| [resterm](https://github.com/unkn0wn-root/resterm) | `dev rest` | Vim-oriented REST client TUI |
| [harlequin](https://harlequin.sh/) | `hq` | SQL TUI |
| [trippy](https://github.com/fujiapple852/trippy) | `trp` | Network diagnostic (`--unprivileged` on macOS) |

Resterm key overrides live in [`resterm/bindings.toml`](resterm/bindings.toml)
and are linked into Resterm's native macOS config directory at
`~/Library/Application Support/resterm/bindings.toml` by the dotfiles role.
On Linux, Stow places the file at `~/.config/resterm/bindings.toml`. Both direct
`resterm` and `dev rest` therefore load the same tracked bindings while
preserving Resterm's native macOS history database. `Tab` / `Shift+Tab` keep
their native focus cycling and also expose `Ctrl+J` / `Ctrl+L` for next and
`Ctrl+H` / `Ctrl+K` for previous focus. Request sending remains on
`Ctrl+Enter`, `Cmd+Enter`, `Alt+Enter` and `Ctrl+M`; the default `Ctrl+J`
send binding is removed so it is not ambiguous with focus movement.

These focus bindings are a previous/next approximation for the current
horizontal pane order, not true directional left/right/up/down actions. In the
request editor they are intentionally swallowed by insert mode; press `Esc`
first to return to normal mode, then use the focus binding.

---

## Development lifecycle CLI

The `dev` shell function is the single entrypoint for interactive development
tools: `dev ide`, `dev rest`, `dev db`, `dev docker`, `dev git`, and
`dev agent codex|claude`. Each subcommand forwards additional arguments to the
selected program and returns its exit status.

`Brewfile` also provisions commands used outside Neovim and available to
asynchronous editor tasks:

| Command | Responsibility |
| --- | --- |
| `httpyac`, `posting` | Scriptable `.http` requests and an interactive API client |
| `harlequin` | DuckDB, SQLite, PostgreSQL, MySQL and ODBC database client |
| `uv` | Reproducible Python environments, tools and dependency resolution |
| `cargo-nextest` | Fast Rust test execution |
| `kubeconform` | Kubernetes and rendered Helm manifest validation |
| `gitleaks` | Secret detection in Git history and the working tree |
| `trivy` | Repository, dependency, IaC and container vulnerability scanning |

## Git conflict workflow

`git mergetool` opens Neovim with `LOCAL`, writable `MERGED`, and `REMOTE`
columns. Save and quit all panes with `:wqa` after resolving the center buffer;
use `:cq`
to abort. `git difftool` uses Git's portable `nvimdiff` driver, while
`git mergetool --gui` and `git difftool --gui` remain explicit Visual Studio
Code fallbacks. Git uses `zdiff3` conflict markers so the common ancestor is
available even before the merge tool opens.

---

## Aliases Reference

### File Navigation (Eza)

| Alias | Command                          |
| ----- | -------------------------------- |
| `l`   | Detailed list with icons and git |
| `ls`  | Fast list with icons             |
| `ll`  | Long list all files              |
| `la`  | All files                        |
| `lt`  | Tree level 2                     |
| `lta` | Tree level 3 with all files      |

### Git

| Alias   | Command                | Description             |
| ------- | ---------------------- | ----------------------- |
| `gst`   | `git status`           | Status                  |
| `gc`    | `git commit -m`        | Commit with message     |
| `gca`   | `git commit -a -m`     | Commit all with message |
| `gp`    | `git push origin HEAD` | Push current branch     |
| `gpu`   | `git pull origin`      | Pull from origin        |
| `gco`   | `git checkout`         | Checkout                |
| `gb`    | `git branch`           | List branches           |
| `gba`   | `git branch -a`        | All branches            |
| `gadd`  | `git add`              | Stage files             |
| `gap`   | `git add -p`           | Interactive staging     |
| `gdiff` | `git diff`             | Show diff               |
| `glog`  | Pretty log graph       | Visual commit history   |
| `grb`   | `git rebase`           | Rebase                  |
| `grbi`  | `git rebase -i`        | Interactive rebase      |
| `gsh`   | `git stash`            | Stash changes           |
| `gshp`  | `git stash pop`        | Pop stash               |
| `gshl`  | `git stash list`       | List stashes            |
| `grs`   | `git restore --staged` | Unstage files           |
| `gcp`   | `git cherry-pick`      | Cherry-pick             |

### Docker

| Alias     | Command                   |
| --------- | ------------------------- |
| `dco`     | `docker compose`          |
| `dcup`    | `docker compose up -d`    |
| `dcdown`  | `docker compose down`     |
| `dclogs`  | `docker compose logs -f`  |
| `dps`     | `docker ps`               |
| `dpa`     | `docker ps -a`            |
| `dx`      | `docker exec -it`         |
| `di`      | `docker images`           |
| `drm`     | `docker rm`               |
| `drmi`    | `docker rmi`              |
| `dprune`  | `docker system prune -af` |
| `dvprune` | `docker volume prune -f`  |
| `dka`     | Kill all containers       |

### Kubernetes

| Alias      | Command                      |
| ---------- | ---------------------------- |
| `k`        | `kubectl`                    |
| `ka`       | `kubectl apply -f`           |
| `kg`       | `kubectl get`                |
| `kga`      | `kubectl get all`            |
| `kgp`      | `kubectl get pods`           |
| `kgpw`     | `kubectl get pods -w`        |
| `kgs`      | `kubectl get svc`            |
| `kgd`      | `kubectl get deployments`    |
| `kgn`      | `kubectl get nodes`          |
| `kd`       | `kubectl describe`           |
| `kdp`      | `kubectl describe pod`       |
| `kl`       | `kubectl logs -f`            |
| `klp`      | `kubectl logs -f --previous` |
| `ke`       | `kubectl exec -it`           |
| `kpf`      | `kubectl port-forward`       |
| `kc`       | `kubectx`                    |
| `kns`      | `kubens`                     |
| `kwatch`   | Watch pods                   |
| `krestart` | `kubectl rollout restart`    |
| `ktop`     | `kubectl top pods`           |
| `ktopn`    | `kubectl top nodes`          |

### Helm

| Alias | Command                  |
| ----- | ------------------------ |
| `h`   | `helm`                   |
| `hl`  | `helm list`              |
| `hla` | `helm list -A`           |
| `hi`  | `helm install`           |
| `hu`  | `helm upgrade`           |
| `hui` | `helm upgrade --install` |
| `hd`  | `helm delete`            |
| `hs`  | `helm search repo`       |
| `hru` | `helm repo update`       |

### Terraform

| Alias  | Command                         |
| ------ | ------------------------------- |
| `tf`   | `terraform`                     |
| `tfi`  | `terraform init`                |
| `tfp`  | `terraform plan`                |
| `tfa`  | `terraform apply`               |
| `tfaa` | `terraform apply -auto-approve` |
| `tfd`  | `terraform destroy`             |
| `tfs`  | `terraform state`               |
| `tfsl` | `terraform state list`          |
| `tfo`  | `terraform output`              |
| `tfv`  | `terraform validate`            |
| `tff`  | `terraform fmt -recursive`      |
| `tfw`  | `terraform workspace`           |

### Ansible

| Alias | Command            |
| ----- | ------------------ |
| `ap`  | `ansible-playbook` |
| `ag`  | `ansible-galaxy`   |
| `av`  | `ansible-vault`    |
| `al`  | `ansible-lint`     |

### Node.js / npm / pnpm

| Alias | Command          |
| ----- | ---------------- |
| `ni`  | `npm install`    |
| `nid` | `npm install -D` |
| `nig` | `npm install -g` |
| `nr`  | `npm run`        |
| `nrs` | `npm run start`  |
| `nrb` | `npm run build`  |
| `nrt` | `npm run test`   |
| `nrd` | `npm run dev`    |
| `pi`  | `pnpm install`   |
| `pa`  | `pnpm add`       |
| `pad` | `pnpm add -D`    |
| `pr`  | `pnpm run`       |
| `prd` | `pnpm run dev`   |
| `px`  | `pnpm dlx`       |

### Nx / Angular

| Alias | Command       |
| ----- | ------------- |
| `nxg` | `nx generate` |
| `nxb` | `nx build`    |
| `nxs` | `nx serve`    |
| `nxt` | `nx test`     |
| `nxl` | `nx lint`     |
| `nxa` | `nx affected` |
| `ngg` | `ng generate` |
| `ngb` | `ng build`    |
| `ngs` | `ng serve`    |

### Herdr

| Alias     | Command                                                       |
| --------- | ------------------------------------------------------------- |
| `herd`    | `herdr`                                                       |
| `herdrs`  | `herdr status`                                                |
| `herdrl`  | `herdr session list`                                          |
| `herdrr`  | `herdr server reload-config`                                  |
| `reviewr` | `herdr plugin action invoke open --plugin persiyanov.reviewr` |

### System Utilities

| Alias     | Command             | Description              |
| --------- | ------------------- | ------------------------ |
| `bcat`    | `bat`               | With syntax highlighting |
| `dufree`  | `duf`               | Disk free                |
| `dusage`  | `dust`              | Disk usage               |
| `duh`     | `dust -d 1`         | Current dir usage        |
| `pss`     | `procs`             | Process list             |
| `pst`     | `procs --tree`      | Process tree             |
| `psa`     | `procs --sortd cpu` | Sort by CPU              |
| `gpingg`  | `gping`             | With graph               |
| `ddiff`   | `delta`             | Better diff              |
| `ports`   | -                   | Show listening ports     |
| `myip`    | -                   | External IP              |
| `localip` | -                   | Local IP                 |
| `path`    | -                   | Show PATH entries        |
| `now`     | -                   | Current datetime         |
| `weather` | -                   | Quick weather            |
| `wttr`    | -                   | Full weather             |

### HTTP / API

| Alias   | Command           |
| ------- | ----------------- |
| `xget`  | `xh GET`          |
| `xpost` | `xh POST`         |
| `xput`  | `xh PUT`          |
| `xdel`  | `xh DELETE`       |
| `http`  | HTTPie with style |
| `https` | HTTPie HTTPS      |

### DNS (doggo)

| Alias     | Query Type  |
| --------- | ----------- |
| `dns`     | Default     |
| `dnsa`    | A record    |
| `dnsaaaa` | AAAA record |
| `dnsmx`   | MX record   |
| `dnstxt`  | TXT record  |
| `dnsns`   | NS record   |

### Directory Navigation

| Alias   | Action             |
| ------- | ------------------ |
| `..`    | Up 1 level         |
| `...`   | Up 2 levels        |
| `....`  | Up 3 levels        |
| `.....` | Up 4 levels        |
| `~`     | Go home            |
| `-`     | Previous directory |

### Quick Edits

| Alias      | Opens              |
| ---------- | ------------------ |
| `zshrc`    | ~/.zshrc           |
| `nvimrc`   | Neovim config      |
| `herdrc`   | Herdr config       |
| `dotfiles` | Dotfiles directory |

### Claude Code

| Alias | Command             |
| ----- | ------------------- |
| `cc`  | `claude`            |
| `ccc` | `claude --continue` |
| `ccr` | `claude --resume`   |

### Safety

| Alias   | Effect                   |
| ------- | ------------------------ |
| `rm`    | Prompts before delete    |
| `cp`    | Prompts before overwrite |
| `mv`    | Prompts before overwrite |
| `mkdir` | Creates parents, verbose |

---

## Functions

| Function  | Description                          | Usage                              |
| --------- | ------------------------------------ | ---------------------------------- |
| `yy`      | Yazi with cd integration             | `yy` (exit yazi into selected dir) |
| `fcd`     | FZF directory navigator              | `fcd`                              |
| `fv`      | FZF file opener (nvim)               | `fv`                               |
| `hsm`     | Herdr session launcher (plain shell) | `hsm` or `hsm session-name`        |
| `mkcd`    | Create and enter directory           | `mkcd new-project`                 |
| `extract` | Universal archive extractor          | `extract file.tar.gz`              |
| `nvims`   | Neovim config switcher               | `nvims`                            |
| `htt`     | HTTPyac with pretty output           | `htt request.http`                 |

---

## Herdr Configuration

Herdr is the default terminal workspace layer and uses the former Tmux prefix:
press `Ctrl+A`, release it, then press the action key. Press `Ctrl+A` twice to
send a literal `Ctrl+A` to Zsh, FZF, Neovim or another pane application.

| Key after prefix | Action                                      |
| ---------------- | ------------------------------------------- |
| `g`              | Full-terminal Lazygit popup in the pane cwd |
| `Shift+R`        | Toggle reviewr over the active tab          |
| `f`              | Session navigator                           |
| `w`              | Workspace picker                            |
| `c`              | New tab                                     |
| `n` / `p`        | Next / previous tab                         |
| `1..9`           | Switch tab                                  |
| `v` / `-`        | Split right / down                          |
| `h/j/k/l`        | Focus the neighboring pane                  |
| `z`              | Zoom the focused pane                       |
| `x`              | Close the focused pane                      |
| `b`              | Toggle the agent/sidebar rail               |
| `[`              | Enter copy mode                             |
| `q`              | Detach; keep panes and agents running       |

On macOS, the Herdr user service starts at login. Linux starts the server on
demand when Zsh hands the terminal to Herdr. It restores workspace layout and
keeps live processes running while clients detach. Pane-history persistence
stays disabled because terminal history may contain credentials or private
output. Official Codex, Claude and Hermes hooks are installed only when those
commands exist, so Herdr can identify and resume their sessions.

Reviewr is pinned by Ansible and opens manually to avoid changing new-worktree
layouts. It reviews uncommitted, branch and last-agent-turn diffs, can send
line comments back to the active agent, and reads PR/MR data through an
already-authenticated `gh`, `glab` or `az`. It is a community plugin and runs
with the current user's permissions; update its pinned version only after
reviewing its manifest and installer.

### Legacy Tmux

`tmux/` remains in Git as a fallback and preserves the same `Ctrl+A` prefix,
but Tmux and TPM are no longer provisioned or deployed. Existing host
installations, sessions and resurrect data are deliberately left untouched
during migration.

---

## AeroSpace Configuration

Config path: `~/.config/aerospace/aerospace.toml`

### Core Bindings

| Key                  | Action                                  |
| -------------------- | --------------------------------------- |
| `Alt+h/j/k/l`        | Focus left/down/up/right                |
| `Alt+Shift+h/j/k/l`  | Move window left/down/up/right          |
| `Alt+1..9`           | Switch workspace                        |
| `Alt+Shift+1..9`     | Move window to workspace                |
| `Alt+Tab`            | Switch back to previous workspace       |
| `Alt+Shift+Tab`      | Move workspace to next monitor          |
| `Alt+/`              | Toggle tiled horizontal/vertical layout |
| `Alt+,`              | Toggle accordion layout                 |
| `Alt+f`              | Toggle fullscreen                       |
| `Alt+-` / `Alt+=`    | Resize focused window smaller/larger    |
| `Alt+Shift+;`        | Enter service mode                      |

### Service Mode

Press `Alt+Shift+;`, then one of:

| Key                 | Action                         |
| ------------------- | ------------------------------ |
| `Esc`               | Reload config and exit mode    |
| `r`                 | Flatten/reset workspace layout |
| `f`                 | Toggle floating/tiling layout  |
| `Backspace`         | Close all windows but current  |
| `Alt+Shift+h/j/k/l` | Join window with neighbor      |

### macOS Notes

AeroSpace is installed via Homebrew only on macOS. The Ansible macOS role also disables display-specific native Spaces and app-triggered Space switching, which keeps AeroSpace workspace movement predictable. After the first launch, grant AeroSpace Accessibility permissions in System Settings if macOS asks for them.

---

## Zsh Plugins

Installed as versioned Homebrew formulae and loaded synchronously in a fixed
order. Shell startup never clones repositories or changes key bindings later:

| Plugin | Description |
| --- | --- |
| `zsh-syntax-highlighting` | Syntax highlighting |
| `zsh-autosuggestions` | History-based suggestions |
| `zsh-completions` | Additional completions |
| `fzf-tab` | FZF-powered tab completion |

---

## Key Bindings (Zsh)

| Key | Action |
| --- | --- |
| `Up` / `Down` | Previous / next Zsh history entry |
| `Ctrl+R` | History search (Atuin) |
| `Ctrl+G` | Navi cheatsheets |
| `Ctrl+T` | FZF file search |
| `Alt+C` | FZF cd |
| `Ctrl+A` | Beginning of line outside Herdr; use `Ctrl+A Ctrl+A` inside |
| `Ctrl+E` | End of line |
| `Ctrl+K` | Kill to end of line |
| `Ctrl+U` | Kill whole line |
| `Ctrl+W` | Kill word backward |
| `Ctrl+Left/Right` | Word navigation |

---

## Features

### Herdr terminal handoff

Normal terminal windows enter the persistent Herdr session automatically.
Herdr-managed panes set `HERDR_ENV=1`, so their inner shell never attaches
recursively. To open a plain shell, add this to `~/.zshrc.local`:

```bash
export ZSH_HERDR_AUTOSTART=0
```

Automatic handoff is skipped for:

- SSH sessions
- Existing Tmux and Herdr panes
- VSCode integrated terminal
- JetBrains IDEs
- Non-interactive shells

### Smart Directory Navigation

- `z <partial-path>` - Jump to frequently used directories (zoxide)
- `fcd` - Interactive directory search with FZF
- `br` - Broot tree navigator

### History

- 100,000 entries
- Shared across sessions
- Deduplicated
- Atuin for enhanced search (`Ctrl+R`)

### Lazy Loading

NVM and completions are lazy-loaded for fast shell startup (~100ms).

---

## Installed Packages

See [Brewfile](./Brewfile) for full list. Categories:

- **Core**: bat, eza, fd, fzf, ripgrep, zoxide, herdr, neovim
- **Modern CLI**: dust, duf, procs, bottom, delta, xh, jless, broot, navi
- **DevOps**: kubectl, helm, k9s, terraform, ansible, docker
- **Git**: lazygit, gh, glab, delta
- **Languages**: go, python, node (via nvm)
- **Network**: trippy, mtr, nmap, doggo, bandwhich

### macOS application ownership

`Brewfile` owns Docker Desktop, Maccy, Flameshot, ChatGPT, Claude, Mos,
Visual Studio Code and JetBrains Toolbox as Homebrew casks. Amphetamine is
Mac App Store-only: `Brewfile` installs `mas`, then the Homebrew role checks
`/Applications/Amphetamine.app` and runs `mas get 937984704` only when it is
missing.

The App Store GUI must already be signed in. `mas get` and several cask
post-install steps require the administrator password, so run `install.sh` or
the playbook from an interactive terminal with `-K`. The Homebrew role uses
`brew bundle --no-upgrade`: it installs missing dependencies without
unexpectedly replacing every outdated GUI application.

Homebrew currently marks Flameshot as deprecated because its package does not
pass Gatekeeper validation and plans to disable the cask on 2026-09-01. The
configuration does not bypass Gatekeeper; reassess or replace this cask before
that date.

---

## Customization

### Local overrides

Create `~/.zshrc.local` for machine-specific settings:

```bash
# Example ~/.zshrc.local
export GITHUB_TOKEN="..."
export ZSH_HERDR_AUTOSTART=0
alias myalias='...'
```

### Theme

Uses **Catppuccin Mocha** everywhere:

- Zsh syntax highlighting
- FZF
- Herdr and reviewr
- Tmux (legacy fallback)
- Bat
- Delta
- Lazygit

---

## Troubleshooting

### Herdr or reviewr not working

```bash
herdr config check
herdr status
herdr plugin list --json
herdr plugin action list --plugin persiyanov.reviewr
brew services restart herdr
```

`Ctrl+A`, then `?` shows the active Herdr keymap. A literal `Ctrl+A` must be
sent as `Ctrl+A`, then `Ctrl+A`. Reviewr actions require a running Herdr
server and an active workspace.

### Slow shell startup

`zsh -i -c exit` has no TTY and intentionally takes the reduced, non-ZLE
configuration path. Measure a real interactive shell through a pseudo-terminal:

```bash
env ZSH_HERDR_AUTOSTART=0 \
  script -q /dev/null /bin/zsh -i -c exit

hyperfine --warmup 3 --runs 10 \
  'env ZSH_HERDR_AUTOSTART=0 script -q /dev/null /bin/zsh -i -c exit'
```

This is an init-only measurement: it exercises interactive ZLE setup but exits
before the first prompt. To include `precmd` hooks and one Starship prompt
expansion, run it from a representative large dirty Git/monorepo:

```bash
env ZSH_HERDR_AUTOSTART=0 \
  script -q /dev/null /bin/zsh -i -c \
  'for hook in $precmd_functions; do "$hook"; done; print -P -- "$PROMPT" >/dev/null'

hyperfine --warmup 3 --runs 10 \
  'env ZSH_HERDR_AUTOSTART=0 script -q /dev/null /bin/zsh -i -c '\''for hook in $precmd_functions; do "$hook"; done; print -P -- "$PROMPT" >/dev/null'\'''
```

Warm init should normally remain below 200ms; prompt latency depends on the
current repository and Starship modules. A clean cache can be slower once while
`compinit` builds its dump; generated Atuin, Zoxide, Broot, Navi, FZF and
Starship shims refresh in the background and do not block later prompts. If slow,
check:

- NVM auto-loading (should be lazy)
- Broken completions

### Completion security warning

```bash
autoload -Uz compaudit
compaudit
```

Do not bypass this check with `compinit -u`. Fix ownership or write
permissions on every path reported by `compaudit`.

---

## License

MIT
