setlocal omnifunc=pythoncomplete#Complete

let g:easytags_python_enabled = 1

let g:pyindent_open_paren = '&sw' " Vim defaults to double the shiftwidth
                                  " which is tacky
inoremap # X<c-h>#
