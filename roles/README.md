# Ansible roles

`all.yml` is the only playbook entry point. It loads platform variables before
executing roles in dependency order:

1. `macos` or `linux`
2. `homebrew`
3. `dotfiles`
4. `git`
5. `node`
6. `docker`

## Contracts

- `macos`: macOS defaults and host-specific privileges.
- `linux`: distro bootstrap packages, Homebrew shell setup and default Zsh.
- `homebrew`: Homebrew installation, non-upgrading `Brewfile` application,
  safe skipping of already-present GUI bundles, App Store bundle checks/
  `mas get`, and Rust toolchain.
- `dotfiles`: Stow deployment, pinned reviewr installation, Herdr service
  startup and available Codex/Claude/Hermes integrations.
- `git`: interactive identity collection and local identity cache.
- `node`: pinned NVM, default Node LTS, pinned global developer tools and
  uv-managed Aider.
- `docker`: Docker Desktop verification on macOS; vendor Docker Engine
  provisioning on Ubuntu/Debian. Other Linux families receive a clear
  unsupported notice, and the role never reboots the host.

Variables shared across roles belong in `group_vars/all.yml`. Platform values
belong in `group_vars/darwin.yml` or `group_vars/linux.yml`. A role default
should document which variables that role consumes.

Run targeted validation after changing a role:

```bash
ANSIBLE_LOCAL_TEMP=/private/tmp/ansible-dotfiles-tmp \
  ansible-lint roles/<role>/tasks/main.yml

ANSIBLE_LOCAL_TEMP=/private/tmp/ansible-dotfiles-tmp \
  ansible-playbook -i inventory/hosts.ini all.yml --syntax-check
```

The `dotfiles` role previews `stow --stow` in check mode and applies
`stow --restow --no-folding` during a real run; it never adopts host files into
the repository. Existing conflicting targets stop the role and must be
resolved explicitly. `.stowrc` excludes `tmux/`, so the legacy Tmux
configuration and runtime data are retained without being deployed on a new
host. Herdr must be installed by the preceding Homebrew role before reviewr or
agent integrations are reconciled. Its login service is managed on macOS;
Linux starts the server on demand through the Zsh handoff.
