" Neovim resolves compound `yaml.jinja` filetypes through its jinja syntax
" script. For this one filetype, add YAML as the base language and then
" overlay the template delimiters. Other Jinja buffers keep their normal
" syntax unchanged.
if &filetype !=# "yaml.jinja"
  finish
endif

if exists("b:current_syntax")
  unlet b:current_syntax
endif
runtime! syntax/yaml.vim

if exists("b:current_syntax")
  unlet b:current_syntax
endif

syntax match jinjaStatement /{%-\?\s*\%(if\|elif\|else\|endif\|for\|endfor\|block\|endblock\|extends\|include\|macro\|endmacro\|set\|endset\)\>[^%]*%}/
syntax match jinjaExpression /{{-\?[^}]*-\?}}/
syntax match jinjaComment /{#-\?[^#]*#-\?}/

highlight default link jinjaStatement PreProc
highlight default link jinjaExpression Special
highlight default link jinjaComment Comment

let b:current_syntax = "yaml.jinja"
