# Environment Context for Agents

This file provides agents with context about the user's development environment, available tools, and configuration.

## Shell Environment

- **Shell**: zsh with antigen plugin manager
- **Theme**: Starship prompt with Catppuccin Mocha colors
- **Terminal**: Supports Nerd Fonts (JetBrains Mono, Fira Code, Hack)

## Available CLI Tools

### Core Development
| Tool | Command | Description |
|------|---------|-------------|
| Neovim | `nvim` | Primary editor |
| Tmux | `tmux` | Terminal multiplexer |
| Git | `git` | Version control |
| LazyGit | `lg` | TUI git client |

### Modern CLI Replacements
| Original | Modern | Alias |
|----------|--------|-------|
| `cat` | `bat` | `cat` (aliased) |
| `ls` | `eza` | `ls`, `l`, `ll`, `lt` |
| `find` | `fd` | `ff`, `fdir` |
| `grep` | `ripgrep` | `rg` |
| `diff` | `delta` | `diff` (aliased) |
| `df` | `duf` | `df` (aliased) |
| `du` | `dust` | `du` (aliased) |
| `ps` | `procs` | `ps` (aliased) |
| `top` | `btop` | `bt` |
| `ping` | `gping` | `ping` (aliased) |
| `dig` | `doggo` | `dig`, `dns` |
| `watch` | `viddy` | `vw` |

### File Navigation
| Tool | Command | Description |
|------|---------|-------------|
| Yazi | `ya`, `yy` | File manager with cd integration |
| fzf | `fzf` | Fuzzy finder |
| zoxide | `z` | Smart cd |
| broot | `br` | Interactive tree |

### DevOps & Kubernetes
| Tool | Alias | Description |
|------|-------|-------------|
| kubectl | `k` | Kubernetes CLI |
| k9s | `k9` | Kubernetes TUI |
| helm | `h` | Kubernetes package manager |
| terraform | `tf` | Infrastructure as code |
| docker compose | `dco` | Container orchestration |
| lazydocker | `ld` | Docker TUI |
| dive | `div` | Docker image analyzer |

### Cloud & Infrastructure
| Tool | Description |
|------|-------------|
| awscli | AWS CLI |
| ansible | Configuration management |
| minikube | Local Kubernetes |

### API & HTTP
| Tool | Alias | Description |
|------|-------|-------------|
| xh | `xget`, `xpost` | HTTP client (Rust) |
| httpie | `http` | HTTP client |
| grpcurl | - | gRPC CLI |

### AI Development Tools
| Tool | Command | Description |
|------|---------|-------------|
| Claude Code | `cc`, `claude` | AI coding assistant |
| Aider | `aider` | AI pair programming |
| Repomix | `repomix` | Codebase context generator |
| Beads | `bd` | AI task management with DAG dependencies |
| Gastown | `gt` | Multi-agent orchestration for large projects |

## Git Aliases

```bash
gc    # git commit -m
gca   # git commit -a -m
gp    # git push origin HEAD
gpu   # git pull origin
gst   # git status
glog  # git log with graph
gdiff # git diff
gco   # git checkout
gb    # git branch
ga    # git add -p (patch mode)
gsh   # git stash
```

## Docker Aliases

```bash
dco     # docker compose
dcup    # docker compose up -d
dcdown  # docker compose down
dclogs  # docker compose logs -f
dps     # docker ps
dx      # docker exec -it
```

## Kubernetes Aliases

```bash
k       # kubectl
kgp     # kubectl get pods
kgs     # kubectl get svc
kl      # kubectl logs -f
ke      # kubectl exec -it
kpf     # kubectl port-forward
kc      # kubectx (context switch)
kns     # kubens (namespace switch)
```

## Node.js / npm

```bash
ni      # npm install
nid     # npm install -D
nr      # npm run
nrd     # npm run dev
nrb     # npm run build
pi      # pnpm install
pr      # pnpm run
px      # pnpm dlx (like npx)
```

## Custom Functions

| Function | Description |
|----------|-------------|
| `yy` | Yazi with cd integration |
| `fcd` | Fuzzy find and cd to directory |
| `fv` | Fuzzy find and open file in nvim |
| `tm` | Tmux session launcher with fzf |
| `mkcd` | Create directory and cd into it |
| `extract` | Extract any archive format |

## Configuration Paths

| Config | Path |
|--------|------|
| Dotfiles | `~/.dotfiles` or `~/projects/dotfiles` |
| Neovim | `~/.config/nvim` |
| Tmux | `~/.config/tmux` |
| Zsh | `~/.zshrc` (sources dotfiles/zsh/) |
| Yazi | `~/.config/yazi` |
| Claude | `~/.claude` (symlink to dotfiles/.claude) |

## MCP Servers Available

When using Claude Code in projects, these MCP servers can be configured:

| Server | Purpose |
|--------|---------|
| context7 | Library documentation lookup |
| sequential-thinking | Complex reasoning support |
| github | GitHub integration (PRs, issues) |
| playwright | E2E testing automation |
| figma | Figma design integration |

## AI Agent Tool Commands

**MANDATORY: Agents must use these tools when available:**

### Beads CLI (`bd`) - Task Management
```bash
bd init           # Initialize workspace
bd ready          # View tasks ready for work
bd list           # View all tasks
bd create --title "[Component] Action" --description "..."  # Create task
bd update bd-123 --claim  # Claim task
bd close bd-123 --message "Done"  # Complete task
bd dep add bd-124 bd-123  # Add dependency (bd-124 depends on bd-123)
bd show bd-123    # View task details
bd reopen bd-123  # Reopen task
```

### Gastown CLI (`gt`) - Large Project Orchestration
```bash
gt install .      # Initialize Gastown
gt rig add main . # Add repository
gt sling          # Distribute tasks to agents
gt convoy create "name" bd-123 bd-124  # Group related tasks
gt feed           # Monitor progress
gt rig status main  # Check rig status
```

### Repomix - Context Snapshots
```bash
repomix --output docs/context/codebase-snapshot.txt  # Generate snapshot
```

### Aider - Pair Programming
```bash
aider [files]     # Start interactive session
```

## Usage Notes for Agents

1. **Always use zsh**: User's shell is zsh with custom aliases
2. **Use modern tools**: Prefer eza over ls, bat over cat, fd over find
3. **Leverage aliases**: Use short aliases (lg, k9, dco, etc.)
4. **File navigation**: yazi (`yy`) or fzf (`fcd`, `fv`) for quick navigation
5. **Git operations**: Use lazygit (`lg`) for complex git workflows
6. **AI tools**: Use repomix for context, aider for pair programming
7. **Paths**: Dotfiles at `~/.dotfiles`, configs in `~/.config/`
8. **MANDATORY - Beads**: Always use `bd` for task management when available
9. **MANDATORY - Gastown**: Use `gt` for large projects (>50 files)
10. **MANDATORY - Repomix**: Refresh context before spawning agents
