skip_global_compinit=1

if [[ -d "$HOME/.config/zsh" ]]; then
  for config_file in "$HOME/.config/zsh"/*.zsh; do
    [[ -f "$config_file" ]] && source "$config_file"
  done
  unset config_file
fi

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
