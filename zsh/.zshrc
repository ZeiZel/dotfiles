# Keep startup deterministic. In particular, key bindings must load after all
# integrations that register ZLE widgets, otherwise a deferred plugin can
# silently replace them after the first prompt.
typeset -g ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

[[ -r "$ZSH_CONFIG_DIR/env.zsh" ]] && source "$ZSH_CONFIG_DIR/env.zsh"

# Commands such as `zsh -ic` used by automation have no terminal-backed ZLE.
# Keep them silent and expose only environment, options, aliases and functions.
if [[ ! -o interactive || ! -t 0 || ! -t 1 ]]; then
  for _zsh_config_file in options.zsh aliases.zsh functions.zsh; do
    [[ -r "$ZSH_CONFIG_DIR/$_zsh_config_file" ]] &&
      source "$ZSH_CONFIG_DIR/$_zsh_config_file"
  done
  unset _zsh_config_file
  [[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
  return 0
fi

typeset -ga _zsh_config_files=(
  options.zsh
  theme.zsh
  completitions.zsh
  init.zsh
  fzf.zsh
  aliases.zsh
  functions.zsh
  prompt.zsh
  plugins.zsh
  kbd.zsh
)

for _zsh_config_file in "${_zsh_config_files[@]}"; do
  [[ -r "$ZSH_CONFIG_DIR/$_zsh_config_file" ]] &&
    source "$ZSH_CONFIG_DIR/$_zsh_config_file"
done

unset _zsh_config_file _zsh_config_files
unfunction _source_generated_zsh_init 2>/dev/null

# Machine-local settings are deliberately untracked.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Normal local terminal windows enter Tmux after the shell configuration is
# ready. Herdr remains available through its explicit aliases/commands.
# Set ZSH_TMUX_AUTOSTART=0 in the local override for a plain shell.
[[ -r "$ZSH_CONFIG_DIR/tmux-auto.zsh" ]] &&
  source "$ZSH_CONFIG_DIR/tmux-auto.zsh"
