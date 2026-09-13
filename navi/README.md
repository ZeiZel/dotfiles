# Navi configuration

[navi](https://github.com/denisidoro/navi) is an interactive cheatsheet: it
turns a description into a runnable command and prompts for the parts that
change. The Brewfile installs it, `zsh/init.zsh` loads its Zsh widget, and this
directory is the source of truth for its configuration and cheats.

Stow deploys this directory to `~/.config/navi`, which is also navi's own
default configuration location, so nothing needs `NAVI_CONFIG` or `--path`.

## Entry points

| Command      | What it does                                      |
| ------------ | ------------------------------------------------- |
| `Ctrl+G`     | Zsh widget: pick a snippet into the command line   |
| `nav`        | `navi`, run standalone                             |
| `navq <q>`   | `navi --query <q>`, prefilled search               |
| `navi --tldr <cmd>` | Fall back to the tldr-pages entry for a command |

Prefer `Ctrl+G`. The widget puts the resolved snippet into the Zsh line editor,
so it runs in the interactive shell with every alias and function available and
you get to read and edit it before pressing Enter. Running `navi` standalone
executes the snippet through the non-interactive shell in `config.yaml`, which
loads no rc file: entries calling `heavy`, `idle`, `hogs`, `dev` or any other
Zsh function only work through the widget.

## Layout

```text
navi/
├── config.yaml        # Cheat paths, column widths, finder and shell
├── README.md
└── cheats/
    ├── ansible.cheat     # Playbooks, inventory, vault
    ├── cloud.cheat       # AWS CLI, minikube
    ├── database.cheat    # PostgreSQL, Redis, Harlequin
    ├── dev.cheat         # Node/pnpm/Nx, Go, Rust, Python/uv, .NET
    ├── docker.cheat      # Containers, Compose, images, cleanup
    ├── dotfiles.cheat    # This repository: Ansible, Brewfile, Stow, validation
    ├── files.cheat       # fd, ripgrep, eza, dust, duf, broot, archives
    ├── forge.cheat       # gh and glab
    ├── git.cheat         # Everyday Git, conflicts, worktrees, reflog
    ├── helm.cheat        # Releases, values, rollbacks
    ├── http.cheat        # xh, curl, grpcurl, posting, resterm, httpyac
    ├── kubernetes.cheat  # Pods, logs, exec, rollouts, contexts
    ├── network.cheat     # doggo, gping, trippy, nmap, tcpdump, bandwhich
    ├── security.cheat    # gitleaks, trivy, certificates, checksums
    ├── system.cheat      # Processes, scheduling bands, benchmarks, logs
    ├── terraform.cheat   # Plan, apply, state surgery, workspaces
    ├── text.cheat        # jq, yq, sd, choose, ast-grep, difftastic
    └── workspace.cheat   # Tmux, Workmux, Herdr command lines
```

## Cheat syntax

```sh
% docker

# Shell into a container (bash, else sh)
docker exec -it <container> sh -lc 'command -v bash >/dev/null 2>&1 && exec bash || exec sh'

$ container: docker ps --format '{{.Names}}\t{{.Image}}' --- --column 1 --delimiter '\t'
```

- `%` opens a cheatsheet and declares its tags.
- `;` is a silent comment; it never becomes an entry.
- `#` is the description the finder searches and displays.
- `<name>` is a placeholder. A `$ name:` line turns it into a picker; without
  one navi prompts for free text.
- A `$` line may reference an earlier placeholder, so `$ pod:` can be scoped by
  the `<ns>` the user just chose. Dependencies resolve in order of first use.
- Options after `---` configure the picker: `--column`, `--delimiter`, `--map`,
  `--multi`, `--preview`, `--prevent-extra`.

### Conventions used here

- **Descriptions are short and front-loaded.** navi's finder only searches the
  text it can display, and the comment column is truncated to its configured
  width. A keyword past the cut is unreachable, so the distinguishing words come
  first and descriptions stay near 45 characters.
- **Descriptions are unique across all files.** Two identical descriptions
  produce two indistinguishable rows and make `--best-match` ambiguous.
- **`DESTRUCTIVE` and `APPLIES` prefixes** mark entries that delete something or
  mutate this host. They also make the whole class searchable: type
  `DESTRUCTIVE` to see everything that bites.
- **Pickers read live state.** Container, pod, release, branch and profile lists
  come from the tool itself, so an entry never runs against a name typed from
  memory.
- **No host-specific values.** Hostnames, cluster names, proxy wrappers, fixed
  `KUBECONFIG` paths and connection strings are machine state, not repository
  state.

## Machine-local cheats

`config.yaml` lists a second cheat path that this repository never ships:

```text
~/.config/navi/cheats.local/
```

The `dotfiles` Ansible role creates it empty. Put anything host-specific there —
a corporate proxy wrapper, a `KUBECONFIG` per stand, a jump host, a database
URL. navi merges it with the tracked cheats, and a missing directory is not an
error, so a fresh host stays quiet.

Because `.gitignore` already ignores `*.local`, `navi/cheats.local/` inside this
repository works too: it stays untracked and Stow deploys it alongside the
tracked cheats.

Never put a credential in either location. A cheat records the shape of a
command; the secret belongs in the environment or a credential file the command
reads for itself.

## Adding a cheat

1. Add the entry to the file that owns the tool, or create a new `.cheat` file
   with a `%` tag line.
2. Keep the description short, unique and keyword-first.
3. Prefer a picker over free text whenever the tool can list the valid values.
4. Validate before committing:

```bash
# Every description resolves, and nothing is executed while checking.
navi --path navi/cheats --print --prevent-interpolation \
  --query '<the new description>' --best-match

# Descriptions must stay unique.
grep -h '^# ' navi/cheats/*.cheat | sort | uniq -d
```

Cheats are plain files read at invocation time. Editing one takes effect on the
next `Ctrl+G`; only a change to `config.yaml` needs the file to be redeployed
with `stow --restow --no-folding .`.
