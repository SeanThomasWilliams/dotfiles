"Check that we don't double-load the plugin
if exists("g:loaded_browserrefresh")
  finish
endif
let g:loaded_browserrefresh = 1

" Default to a bunch of files...
if !exists("g:firefox_refresh_files")
    let g:firefox_refresh_files = '*.html,*.htm,*.py,*.css,*.js'
endif

if !exists("$firefox_refresh_host")
    let $firefox_refresh_host = 'webclient'
endif

function! RefreshBrowser()
    silent !echo  'reload' | nc -w 1 "$firefox_refresh_host" 32000 2>&1 > /dev/null
endfunction

exec 'autocmd BufWritePost ' . g:firefox_refresh_files . ' :call RefreshBrowser()'

" Manual key for reloading
"map <F5> <esc>:call RefershBrowser()<cr>
