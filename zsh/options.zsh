# History is shared across interactive shells. SHARE_HISTORY already appends
# incrementally; enabling INC_APPEND_HISTORY at the same time is unsupported.
# Keep old entries: HIST_IGNORE_ALL_DUPS and HIST_SAVE_NO_DUPS discard an
# earlier matching command, which looks like history is randomly disappearing.
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
unsetopt INC_APPEND_HISTORY
unsetopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt INTERACTIVE_COMMENTS

# Ctrl-S must never freeze the terminal through software flow control.
unsetopt FLOW_CONTROL
