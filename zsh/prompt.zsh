# The init shim is stable for a Starship binary and is regenerated only after
# that binary changes. It does not cache dynamic prompt data: Starship still
# evaluates the current directory and repository at each prompt.
if (( $+commands[starship] )); then
  _starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship/init.zsh"
  _source_generated_zsh_init "$_starship_cache" "$commands[starship]" init zsh
  if [[ -r "$_starship_cache" ]]; then

    # Starship's Zsh init always installs a command substitution for RPROMPT.
    # The tracked right_format is empty, so avoid spawning a second Starship
    # process whose output would be empty. A later ~/.zshrc.local may still set
    # its own RPROMPT if the user wants one.
    RPROMPT=""
  fi
  unset _starship_cache
fi
