au BufEnter *.md setl syntax=markdown
nnoremap <silent> <leader>we :norm 2o### <CR>"=strftime("%c")<CR>p:norm 2o<CR>i
nnoremap <silent> <leader>go :!open <C-r>=expand('%:s?.md?.html?:s?vimwiki?vimwiki/html?')<CR><CR>
