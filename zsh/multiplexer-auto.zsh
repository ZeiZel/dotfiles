# ============================================
# MULTIPLEXER DISPATCH
# ============================================
# Sourced after ~/.zshrc.local so local settings control the backend.

case "${ZSH_MULTIPLEXER:-tmux}" in
  tmux)
    [[ -r "$ZSH_CONFIG_DIR/tmux-auto.zsh" ]] &&
      source "$ZSH_CONFIG_DIR/tmux-auto.zsh"
    ;;
  herdr)
    [[ -r "$ZSH_CONFIG_DIR/herdr-auto.zsh" ]] &&
      source "$ZSH_CONFIG_DIR/herdr-auto.zsh"
    ;;
  none)
    ;;
  *)
    # Invalid values fail safe to a plain shell without startup noise.
    ;;
esac
