# Use one explicit editing model. Zsh otherwise chooses vi mode when
# EDITOR/VISUAL contains "vi" (including "nvim").
bindkey -e
export KEYTIMEOUT=10

# History navigation. Terminals may emit CSI or SS3 cursor sequences depending
# on the current application mode, so support both variants.
for _zsh_keymap in emacs; do
  bindkey -M "$_zsh_keymap" '^[[A' up-line-or-history
  bindkey -M "$_zsh_keymap" '^[OA' up-line-or-history
  bindkey -M "$_zsh_keymap" '^[[B' down-line-or-history
  bindkey -M "$_zsh_keymap" '^[OB' down-line-or-history
  bindkey -M "$_zsh_keymap" '^P' up-line-or-history
  bindkey -M "$_zsh_keymap" '^N' down-line-or-history
done
unset _zsh_keymap

# fzf's generated integration also claims Ctrl-R. Atuin is the authoritative
# history UI in this configuration, so restore its widget after every plugin
# has registered its bindings. The guard keeps optional Atuin installs silent.
if [[ -n "${widgets[atuin-search]-}" ]]; then
  bindkey -M emacs '^R' atuin-search
fi

# Word navigation
bindkey '^[[1;5C' forward-word # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# Line editing
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
