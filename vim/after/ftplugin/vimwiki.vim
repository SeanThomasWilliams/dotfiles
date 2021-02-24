au BufEnter *.md setl syntax=markdwon
nnoremap <silent> <leader>wd :norm 2o### <CR>"=strftime("%c")<CR>p:norm 2o<CR>i
nnoremap <silent> <leader>go :!open <C-r>=expand('%:s?.md?.html?:s?vimwiki?vimwiki/html?')<CR><CR>
