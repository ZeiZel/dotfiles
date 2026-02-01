# ============================================
# ZSHRC - Main Configuration
# ============================================

zmodload zsh/zprof

# Load all configuration files from ~/.config/zsh/
# Files are loaded in alphanumeric order (01-, 02-, etc.)
if [[ -d "$HOME/.config/zsh" ]]; then
  for config_file in "$HOME/.config/zsh"/*.zsh; do
    [[ -f "$config_file" ]] && source "$config_file"
  done
  unset config_file
fi

# Load local overrides (not tracked by git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

zprof