# Zsh configuration

`zsh/.zshrc` is linked to `~/.zshrc`. It uses an explicit source manifest so
widget and keymap ownership cannot change with filename order. Terminal-backed
interactive shells load:

1. environment and options;
2. theme and one cached `compinit`;
3. FZF, Atuin, Zoxide, Broot and Navi integrations;
4. aliases, functions and Starship;
5. Homebrew-managed plugins;
6. final Emacs key bindings;
7. optional `~/.zshrc.local` and the normal terminal-to-Herdr handoff.

Interactive commands without a TTY load only environment, options, aliases and
functions and remain silent.

## File ownership

- `env.zsh`: XDG variables, editor selection, PATH and language runtimes.
- `aliases.zsh`: aliases only; keep destructive aliases explicit.
- `functions.zsh`: reusable shell functions.
- `plugins.zsh`: versioned Homebrew plugin loading.
- `init.zsh`: initialization and cached generated integrations.
- `fzf.zsh`: FZF defaults, previews and widgets.
- `kbd.zsh`: key bindings.
- `options.zsh`: shell options.
- `theme.zsh`, `prompt.zsh`: presentation.
- `herdr-auto.zsh`: default Herdr attachment with recursion, SSH and IDE
  guards. Set `ZSH_HERDR_AUTOSTART=0` for a plain shell.
- `completitions.zsh`: existing completion setup (filename is intentionally
  retained for compatibility).

Adding a file does not activate it. Add it to the manifest in `.zshrc` at the
point where its widgets and bindings belong. Keep top-level code silent and
guard optional commands/files.

Machine-specific paths, tokens and credentials do not belong here. Copy
`.zshrc.local.example` to the untracked `~/.zshrc.local` and keep local values
there.

Up/Down always use native Zsh history. Atuin owns only `Ctrl+R`. `bindkey -e`
is explicit because `EDITOR=nvim` would otherwise make Zsh choose vi mode.
NVM is lazy-loaded; the default Node binary is placed on PATH without sourcing
`nvm.sh`.

Starship is initialized from a binary-invalidated cache, but its prompt data is
always live. The prompt retains repository status and language/runtime context
only in directories whose project markers match. Starship bounds directory
scans to 20 ms and external version commands to 150 ms; it does not make
network requests on startup or fetch Git remotes. Starship does not provide a
supported asynchronous or transient-prompt implementation for Zsh, so this
configuration deliberately avoids a custom background job that could race ZLE.
The generated Starship, FZF, Atuin, Zoxide, Broot and Navi integration shims
are refreshed in a detached, lock-protected process when a binary changes.
Existing shims are sourced immediately; on a clean cache the first shell keeps
its native bindings and the integrations become available on the next shell
after generation completes.
Because the tracked `right_format` is empty, `prompt.zsh` also clears the empty
`RPROMPT` command substitution installed by Starship. This avoids a second
Starship process on every prompt; a later local override may still set its own
`RPROMPT`.

History preserves prior occurrences of commands. `HIST_IGNORE_ALL_DUPS` and
`HIST_SAVE_NO_DUPS` are intentionally not enabled because they remove older
duplicate entries and can look like history loss. Consecutive duplicates are
still suppressed with `HIST_IGNORE_DUPS`.

Herdr handoff runs last, after the local override. It replaces only the outer
terminal shell; Herdr injects `HERDR_ENV=1` into panes, whose Zsh configuration
then loads exactly once. Existing Tmux panes are never nested. Inside Herdr,
send `Ctrl+A Ctrl+A` when ZLE should receive its normal beginning-of-line key.

Validate changes with:

```bash
zsh -n zsh/.zshrc zsh/*.zsh
zsh -c 'source ./zsh/env.zsh; command -v <affected-tool>'
autoload -Uz compaudit
compaudit
```
