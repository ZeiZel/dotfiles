# Dotfiles

<!-- markdownlint-disable MD013 -->

Personal dotfiles for macOS/Linux with Zsh, Tmux, Workmux, Herdr, Neovim, and modern CLI
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

# Tmux, Workmux, Herdr, reviewr, agent integrations and Broot are provisioned automatically.
```

Keyboard repeat is configured by Ansible on both platforms: the shared policy
is a 20 ms repeat interval with a 150 ms initial delay. macOS writes native
defaults and reapplies exact HID values through a per-user login LaunchAgent.
Linux installs `xkbset` and applies the values from an XDG-autostart helper for
X11, GNOME, and Plasma; unsupported generic Wayland sessions are reported
without changing settings.

---

## Stack

| Category        | Tool                                                      |
| --------------- | --------------------------------------------------------- |
| Terminal        | [Ghostty](https://ghostty.org/)                           |
| Shell           | Zsh + versioned Homebrew plugins                          |
| Prompt          | [Starship](https://starship.rs/)                          |
| Workspace       | Tmux + Workmux (default), or [Herdr](https://herdr.dev/) |
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
│   ├── multiplexer-auto.zsh # ZSH_MULTIPLEXER dispatcher
│   ├── herdr-auto.zsh    # Guarded Herdr handoff
│   └── tmux-auto.zsh     # Guarded Tmux handoff
├── herdr/                # Optional workspace configuration
│   ├── config.toml      # Prefix, panes, UI and Lazygit popup
│   └── plugins/         # Declarative reviewr configuration
├── tmux/                 # Tmux configuration and bindings
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

Herdr is the optional workspace for normal local interactive shells, selected
with `ZSH_MULTIPLEXER=herdr`. It shares the `Ctrl+A` prefix with Tmux and
mirrors the Tmux key map, so one set of muscle memory drives both backends.
Press `Ctrl+A`, release it, then press the action key.

| Key after prefix | Action                                      | Tmux |
| ---------------- | ------------------------------------------- | ---- |
| `\|` / `-`       | Split right / down                          | same |
| `h/j/k/l`        | Focus the neighboring pane                  | same |
| `Shift+H/J/K/L`  | Resize the focused pane by 5 %              | same |
| `z` / `x`        | Zoom / close the focused pane               | same |
| `c` / `,` / `&`  | New / rename / close tab                    | same |
| `Ctrl+H` / `Ctrl+L` | Previous / next tab                      | same |
| `1..9`           | Switch tab                                  | same |
| `Shift+C` / `$` / `Shift+X` | New / rename / close space       | `C` / `$` / `X` |
| `s`              | Space navigator                             | `s` (choose-tree) |
| `[`              | Open the scrollback in `$EDITOR`            | `[` (copy-mode) |
| `d`              | Detach; keep panes and agents running       | `d` |
| `r` / `t`        | Reload config / toggle the sidebar          | `r` / `t` |
| `g`              | Full-terminal Lazygit popup in the pane cwd | `g` |
| `Shift+R`        | Toggle reviewr over the active tab          | —    |

The complete map, including the Tmux bindings Herdr cannot express, is in
[`herdr/README.md`](herdr/README.md).

Background agent notifications go to the macOS notification centre
(`[ui.toast] delivery = "system"`, backed by `terminal-notifier`) instead of
staying inside the terminal; `Prefix Alt+O` jumps to the pane that raised one.

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

### Tmux and Workmux

Normal local interactive shells attach to the persistent Tmux `main` session.
Set `ZSH_MULTIPLEXER=herdr` in `~/.zshrc.local` to enter Herdr instead, or
`ZSH_MULTIPLEXER=none` for a plain shell. Invalid values fail safe to a plain
shell. SSH, IDE, nested multiplexer, non-TTY and `TERM=dumb` shells stay plain.
The inherited prefix remains `Ctrl+A`.

Workmux is configured globally at `~/.config/workmux/config.yaml` with
session-per-worktree mode and Codex as the agent. It deliberately has no
automatic `.env` copies, dependency symlinks, install hooks or merge cleanup.
Use `wm add feature-name`, `wm list`, `wm open feature-name`, and `wm merge`
when you explicitly want those operations. `Prefix W` opens the Workmux
worktrees dashboard from Tmux. `Prefix+w` opens a command menu: `w` opens the
worktrees dashboard (where worktrees can be created and opened), `a` opens the
agents dashboard, `d` opens the current diff dashboard, `s` toggles the
session-scoped sidebar, `r` resurrects worktrees, `b` rebases the current
worktree, `m` merges it, `c` closes it, and `?` opens Workmux documentation.
Rebase, merge and close ask for confirmation and run in a popup rooted at the
current pane. The optional Agents tab requires an explicit `workmux setup`
(not run by provisioning because it changes Codex config).
Tmux and Workmux are the default and start automatically. Herdr remains
installed and is started automatically when `ZSH_MULTIPLEXER=herdr` selects it.

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

### Terminal multiplexer handoff

Normal local terminal windows enter Tmux automatically. Choose the backend in
`~/.zshrc.local`:

```bash
export ZSH_MULTIPLEXER=tmux # default
# export ZSH_MULTIPLEXER=herdr
# export ZSH_MULTIPLEXER=none
```

The selector is evaluated after the local override. Unsupported values are
fail-safe and leave a plain shell without a warning. Automatic handoff is
skipped for:

- SSH sessions
- Existing Tmux and Herdr panes
- VSCode integrated terminal
- JetBrains IDEs
- Non-interactive shells

For a one-shot choice in a new outer/plain shell, use
`ZSH_MULTIPLEXER=herdr zsh` or `ZSH_MULTIPLEXER=none zsh`; nested multiplexer
guards intentionally take precedence. Put the persistent value in the
untracked `~/.zshrc.local`.

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

- **Core**: bat, eza, fd, fzf, ripgrep, zoxide, tmux, workmux, neovim
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
export ZSH_MULTIPLEXER=herdr
# export ZSH_MULTIPLEXER=none
# Legacy per-backend kill switches are optional secondary controls:
# export ZSH_HERDR_AUTOSTART=0
# export ZSH_TMUX_AUTOSTART=0
alias myalias='...'
```

### Theme

Uses **Catppuccin Mocha** everywhere:

- Zsh syntax highlighting
- FZF
- Herdr and reviewr
- Tmux, Workmux and TPM
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
env ZSH_MULTIPLEXER=none \
  script -q /dev/null /bin/zsh -i -c exit

hyperfine --warmup 3 --runs 10 \
  'env ZSH_MULTIPLEXER=none script -q /dev/null /bin/zsh -i -c exit'
```

This is an init-only measurement: it exercises interactive ZLE setup but exits
before the first prompt. To include `precmd` hooks and one Starship prompt
expansion, run it from a representative large dirty Git/monorepo:

```bash
env ZSH_MULTIPLEXER=none \
  script -q /dev/null /bin/zsh -i -c \
  'for hook in $precmd_functions; do "$hook"; done; print -P -- "$PROMPT" >/dev/null'

hyperfine --warmup 3 --runs 10 \
  'env ZSH_MULTIPLEXER=none script -q /dev/null /bin/zsh -i -c '\''for hook in $precmd_functions; do "$hook"; done; print -P -- "$PROMPT" >/dev/null'\'''
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
