# Open any file with a fragment in vim, fragments are generated
# by the hyperlink_grep kitten and nothing else so far.
protocol file
fragment_matches [0-9]+
action launch --type=overlay vim +${FRAGMENT} ${FILE_PATH}

# Open text files without fragments in the editor
protocol file
mime text/*
action launch --type=overlay ${EDITOR} ${FILE_PATH}
