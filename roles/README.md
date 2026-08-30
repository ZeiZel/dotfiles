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
- `dotfiles`: Tmux/Workmux Stow deployment, pinned TPM and reviewr
  installation, Herdr service startup and available Codex/Claude/Hermes
  integrations.
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
the repository. Existing repository-owned tmux links are migrated safely
before Stow; regular files and foreign links are preserved. Tmux and Workmux
are deployed, and TPM/plugins are provisioned after Stow. Herdr must be
installed by the preceding Homebrew role before reviewr or agent integrations
are reconciled. Its login service remains managed on macOS for manual use.

Keyboard repeat policy is shared in `group_vars/all.yml` as a 20 ms interval
and 150 ms initial delay. macOS persists the nearest native defaults ticks and
reapplies exact nanosecond HID values at login. Linux applies the policy through
X11 (`xkbset`) and GNOME/Plasma Wayland settings; unsupported generic Wayland
sessions report a diagnostic and leave the desktop unchanged.
