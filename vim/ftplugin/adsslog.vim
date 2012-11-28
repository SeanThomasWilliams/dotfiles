setlocal foldcolumn=8
setlocal foldmethod=marker
setlocal foldmarker=<<:,:>>
"reload when file changes
setlocal autoread

"fold on log message
nnoremap ,; :setlocal foldmarker=<<;,;>><CR>
"fold on function call
nnoremap ,: :setlocal foldmarker=<<:,:>><CR>
"reload file
nnoremap \r :e %
"copy file contents into new tab
nnoremap \c ggVGy:tabnew<CR>:set ft=adsslog<CR>pgg
"search for all function calls
nnoremap \f :grep '<<:' %<CR>:copen<CR>
"delete everything except function enter/exit lines
nnoremap \t :%v;\v(\<\<:)\|(:\>\>);d<CR>

