# Dotfiles

Personal dotfiles for macOS/Linux with Zsh, Tmux, Neovim, and modern CLI tools. Fully automated setup via Ansible.

## Quick Install

```bash
sh -c "$(curl -fsSL https://github.com/ZeiZel/dotfiles/raw/master/install.sh)"
```

### Post-install

```bash
# Neovim: install plugins
nvim  # Run :Lazy install and :MasonInstall

# Tmux: install plugins (inside tmux)
# Press: Ctrl+A then I

# Broot: initialize
broot --install
```

---

## Stack

| Category        | Tool                                                      |
| --------------- | --------------------------------------------------------- |
| Terminal        | [Ghostty](https://ghostty.org/)                           |
| Shell           | Zsh + [Zinit](https://github.com/zdharma-continuum/zinit) |
| Prompt          | [Starship](https://starship.rs/)                          |
| Multiplexer     | [Tmux](https://github.com/tmux/tmux) + TPM                |
| Editor          | [Neovim](https://neovim.io/)                              |
| File Manager    | [Yazi](https://yazi-rs.github.io/)                        |
| History         | [Atuin](https://atuin.sh/)                                |
| Tiling (macOS)  | [Aerospace](https://github.com/nikitabobko/AeroSpace)     |
| Package Manager | [Homebrew](https://brew.sh/)                              |
| Theme           | Catppuccin Mocha                                          |

---

## Directory Structure

```
dotfiles/
├── zsh/                  # Zsh configuration
│   ├── .zshrc           # Entry point
│   ├── aliases.zsh      # 370+ aliases
│   ├── functions.zsh    # Helper functions
│   ├── plugins.zsh      # Zinit plugin config
│   ├── env.zsh          # Environment variables
│   ├── fzf.zsh          # FZF configuration
│   ├── init.zsh         # Tool initialization
│   ├── kbd.zsh          # Key bindings
│   ├── options.zsh      # Shell options
│   ├── theme.zsh        # Catppuccin colors
│   └── tmux-auto.zsh    # Auto-start tmux
├── tmux/                 # Tmux configuration
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
├── git/                  # Git configuration
├── Brewfile              # Homebrew packages
├── all.yml               # Ansible playbook
└── tasks/                # Ansible tasks
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
| `broot`      | `br`            | Interactive tree navigator     |
| `navi`       | `nv`, `Ctrl+G`  | Interactive cheatsheets        |
| `bandwhich`  | `bw`            | Network bandwidth monitor      |
| `lnav`       | `logs`          | Log file navigator             |
| `hyperfine`  | `bench`         | CLI benchmarking               |
| `tokei`      | `loc`           | Code statistics                |
| `glow`       | `mdp`           | Markdown preview               |
| `gping`      | `ping`          | Ping with graph                |

---

## TUI Applications

| App                                                       | Alias      | Description           |
| --------------------------------------------------------- | ---------- | --------------------- |
| [lazygit](https://github.com/jesseduffield/lazygit)       | `lg`       | Git TUI               |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | `ld`       | Docker TUI            |
| [btop](https://github.com/aristocratos/btop)              | `bt`       | Resource monitor      |
| [k9s](https://k9scli.io/)                                 | `k9`       | Kubernetes TUI        |
| [yazi](https://yazi-rs.github.io/)                        | `ya`, `yy` | File manager          |
| [dive](https://github.com/wagoodman/dive)                 | `div`      | Docker image analyzer |
| [posting](https://github.com/darrenburns/posting)         | `post`     | HTTP client TUI       |
| [harlequin](https://harlequin.sh/)                        | `hq`       | SQL TUI               |
| [trippy](https://github.com/fujiapple852/trippy)          | `tr`       | Network diagnostic    |

---

## Aliases Reference

### File Navigation (Eza)

| Alias | Command                          |
| ----- | -------------------------------- |
| `l`   | Detailed list with icons and git |
| `ls`  | Tree level 1 with icons          |
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
| `ga`    | `git add -p`           | Interactive staging     |
| `gdiff` | `git diff`             | Show diff               |
| `glog`  | Pretty log graph       | Visual commit history   |
| `grb`   | `git rebase`           | Rebase                  |
| `grbi`  | `git rebase -i`        | Interactive rebase      |
| `gsh`   | `git stash`            | Stash changes           |
| `gshp`  | `git stash pop`        | Pop stash               |
| `gshl`  | `git stash list`       | List stashes            |
| `grs`   | `git restore --staged` | Unstage files           |
| `gcp`   | `git cherry-pick`      | Cherry-pick             |

### Forgit (Interactive Git with FZF)

| Alias    | Description                 |
| -------- | --------------------------- |
| `ga`     | Interactive `git add`       |
| `glo`    | Interactive `git log`       |
| `gd`     | Interactive `git diff`      |
| `gcb`    | Interactive checkout branch |
| `gbd`    | Interactive delete branch   |
| `gss`    | Interactive stash show      |
| `gsp`    | Interactive stash push      |
| `grb`    | Interactive rebase          |
| `gbl`    | Interactive blame           |
| `gclean` | Interactive clean           |
| `gfu`    | Interactive fixup           |

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

### Tmux

| Alias  | Command                |
| ------ | ---------------------- |
| `ta`   | `tmux attach -t`       |
| `ts`   | `tmux new-session -s`  |
| `tl`   | `tmux list-sessions`   |
| `tks`  | `tmux kill-session`    |
| `tkss` | `tmux kill-session -t` |
| `tksv` | `tmux kill-server`     |

### System Utilities

| Alias     | Command             | Description              |
| --------- | ------------------- | ------------------------ |
| `cat`     | `bat`               | With syntax highlighting |
| `df`      | `duf`               | Disk free                |
| `du`      | `dust`              | Disk usage               |
| `duh`     | `dust -d 1`         | Current dir usage        |
| `ps`      | `procs`             | Process list             |
| `pst`     | `procs --tree`      | Process tree             |
| `psa`     | `procs --sortd cpu` | Sort by CPU              |
| `ping`    | `gping`             | With graph               |
| `diff`    | `delta`             | Better diff              |
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
| `tmuxrc`   | Tmux config        |
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

| Function  | Description                 | Usage                              |
| --------- | --------------------------- | ---------------------------------- |
| `yy`      | Yazi with cd integration    | `yy` (exit yazi into selected dir) |
| `fcd`     | FZF directory navigator     | `fcd`                              |
| `fv`      | FZF file opener (nvim)      | `fv`                               |
| `tm`      | FZF tmux session launcher   | `tm` or `tm session-name`          |
| `mkcd`    | Create and enter directory  | `mkcd new-project`                 |
| `extract` | Universal archive extractor | `extract file.tar.gz`              |
| `nvims`   | Neovim config switcher      | `nvims`                            |
| `htt`     | HTTPyac with pretty output  | `htt request.http`                 |

---

## Tmux Configuration

### Prefix: `Ctrl+A`

### Session Management

| Key | Action                         |
| --- | ------------------------------ |
| `s` | Choose session (tree view)     |
| `C` | New session                    |
| `X` | Kill session (with confirm)    |
| `o` | SessionX (FZF session manager) |

### Pane Management

| Key            | Action                             |
| -------------- | ---------------------------------- |
| `\|` or `\`    | Split horizontal                   |
| `-` or `_`     | Split vertical                     |
| `h/j/k/l`      | Navigate panes (vim-style)         |
| `H/J/K/L`      | Resize panes (5 units)             |
| `Alt+h/j/k/l`  | Resize panes (1 unit)              |
| `m` or `z`     | Zoom pane                          |
| `Ctrl+h/j/k/l` | Navigate (with vim-tmux-navigator) |

### Window Management

| Key      | Action            |
| -------- | ----------------- |
| `c`      | New window        |
| `Ctrl+H` | Previous window   |
| `Ctrl+L` | Next window       |
| `Tab`    | Last window       |
| `<`      | Swap window left  |
| `>`      | Swap window right |
| `0-9`    | Select window     |

### Popup Windows

| Key | Opens              |
| --- | ------------------ |
| `g` | Lazygit            |
| `b` | Btop               |
| `y` | Yazi               |
| `f` | FZF file finder    |
| `n` | Notes (~/notes.md) |

### Plugins

| Key | Plugin                         |
| --- | ------------------------------ |
| `F` | tmux-fzf                       |
| `T` | tmux-thumbs (copy hints)       |
| `u` | tmux-fzf-url (open URLs)       |
| `e` | Extrakto (search pane content) |

### Copy Mode (vi-style)

| Key      | Action              |
| -------- | ------------------- |
| `Enter`  | Enter copy mode     |
| `v`      | Begin selection     |
| `Ctrl+v` | Rectangle selection |
| `y`      | Copy and exit       |
| `Escape` | Cancel              |

### Layouts

| Key     | Layout                      |
| ------- | --------------------------- |
| `Alt+1` | Main horizontal             |
| `Alt+2` | Main vertical               |
| `Alt+3` | Tiled                       |
| `Alt+4` | Even horizontal             |
| `Alt+5` | Even vertical               |
| `D`     | Dev layout (70/30 split)    |
| `I`     | IDE layout (main + 2 right) |

### Other

| Key      | Action                   |
| -------- | ------------------------ |
| `r`      | Reload config            |
| `S`      | Sync panes (type in all) |
| `Ctrl+K` | Clear screen + history   |
| `t`      | Toggle status bar        |
| `I`      | Install plugins (TPM)    |
| `U`      | Update plugins (TPM)     |

### Session Persistence

Sessions are automatically saved every 5 minutes and restored on tmux start.

- Manual save: `prefix + Ctrl+s`
- Manual restore: `prefix + Ctrl+r`

---

## Zsh Plugins

Managed by [Zinit](https://github.com/zdharma-continuum/zinit) with turbo mode (async loading):

| Plugin                                                                                    | Description                |
| ----------------------------------------------------------------------------------------- | -------------------------- |
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Syntax highlighting        |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)                   | History-based suggestions  |
| [zsh-completions](https://github.com/zsh-users/zsh-completions)                           | Additional completions     |
| [fzf-tab](https://github.com/Aloxaf/fzf-tab)                                              | FZF-powered tab completion |
| [zsh-autopair](https://github.com/hlissner/zsh-autopair)                                  | Auto-pair brackets         |
| [zsh-sudo](https://github.com/hcgraf/zsh-sudo)                                            | Double-ESC for sudo        |
| [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)               | Alias reminders            |
| [forgit](https://github.com/wfxr/forgit)                                                  | FZF + Git integration      |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | History search             |

### OMZ Snippets

- git, extract, colored-man-pages, safe-paste
- docker, docker-compose, kubectl, terraform

---

## Key Bindings (Zsh)

| Key               | Action                     |
| ----------------- | -------------------------- |
| `jj`              | Exit insert mode (vi-mode) |
| `Ctrl+R`          | History search (Atuin)     |
| `Ctrl+G`          | Navi cheatsheets           |
| `Ctrl+T`          | FZF file search            |
| `Alt+C`           | FZF cd                     |
| `Ctrl+A`          | Beginning of line          |
| `Ctrl+E`          | End of line                |
| `Ctrl+K`          | Kill to end of line        |
| `Ctrl+U`          | Kill whole line            |
| `Ctrl+W`          | Kill word backward         |
| `Ctrl+Left/Right` | Word navigation            |

---

## Features

### Auto-start Tmux

Terminal automatically attaches to existing tmux session or creates new one.

**Disable temporarily:**

```bash
DISABLE_TMUX_AUTOSTART=1 zsh
```

**Disable permanently** (add to `~/.zshrc.local`):

```bash
export DISABLE_TMUX_AUTOSTART=1
```

Skips auto-start for:

- SSH sessions
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

- **Core**: bat, eza, fd, fzf, ripgrep, zoxide, tmux, neovim
- **Modern CLI**: dust, duf, procs, bottom, delta, xh, jless, broot, navi
- **DevOps**: kubectl, helm, k9s, terraform, ansible, docker
- **Git**: lazygit, gh, glab, delta
- **Languages**: go, python, node (via nvm)
- **Network**: trippy, mtr, nmap, doggo, bandwhich

---

## Customization

### Local overrides

Create `~/.zshrc.local` for machine-specific settings:

```bash
# Example ~/.zshrc.local
export GITHUB_TOKEN="..."
export DISABLE_TMUX_AUTOSTART=1
alias myalias='...'
```

### Theme

Uses **Catppuccin Mocha** everywhere:

- Zsh syntax highlighting
- FZF
- Tmux
- Bat
- Delta
- Lazygit

---

## Troubleshooting

### Tmux plugins not working

```bash
# Inside tmux, press:
# Ctrl+A then I (capital i)

# Or manually:
~/.config/tmux/plugins/tpm/bin/install_plugins
```

### Slow shell startup

Check startup time:

```bash
time zsh -i -c exit
```

Should be under 200ms. If slow, check:

- NVM auto-loading (should be lazy)
- Broken completions

### Zinit not loading

```bash
rm -rf ~/.local/share/zinit
exec zsh
```

---

## License

MIT
