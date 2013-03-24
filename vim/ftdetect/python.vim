au BufNewFile,BufRead *.py set filetype=python
au! BufNewFile,BufRead *.py compiler pylint
autocmd FileType python set omnifunc=pythoncomplete#Complete
