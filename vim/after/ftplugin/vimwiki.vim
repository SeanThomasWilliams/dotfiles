au BufEnter *.md setl syntax=markdwon
nnoremap <silent> <leader>wd :e ~/vimwiki/WorkLog.md<CR>G:InsertTime<CR>o

nnoremap <silent> <leader>go :!open <C-r>=expand('%:s?.md?.html?:s?vimwiki?vimwiki/html?')<CR><CR>
