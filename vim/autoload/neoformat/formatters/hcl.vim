function! neoformat#formatters#hcl#enabled() abort
    return ['packerfmt']
endfunction

function! neoformat#formatters#hcl#packerfmt() abort
    return {
        \ 'exe': 'packer',
        \ 'args': ['fmt', '-'],
        \ 'stdin': 1
        \ }
endfunction
