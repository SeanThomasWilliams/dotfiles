" ======================== Vundle Config =================

filetype off
set rtp+=~/.vim/bundle/vundle/
"set rtp+=$GOROOT/misc/vim
call vundle#rc()
Bundle 'gmarik/vundle'

"          _ __  __          __
"   ____ _(_) /_/ /_  __  __/ /_
"  / __ `/ / __/ __ \/ / / / __ \
" / /_/ / / /_/ / / / /_/ / /_/ /
" \__, /_/\__/_/ /_/\__,_/_.___/
"/____/ ----- Vim Bundles -------
"

Bundle 'SeanThomasWilliams/dwm.vim'
Bundle 'gagoar/StripWhiteSpaces'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/vimwiki'
Bundle 'jnwhiteh/vim-golang'

"+----------------- Basic Configurations ------------+
"

" GUI Configuration
if has('gui_running')
    set spell " Spelling looks ugly in command line mode
    set spelllang=en_us " We speak amuurican
    set guioptions-=T
    set guioptions=+M "Turn off annoying bars
    set guioptions+=LlRrb "Some kind of hack for scrollbars
    set guioptions-=LlRrb
    set guifont=Terminus\ 10
endif

" =========================
" Vim-Script Configurations
" =========================
let g:NERDTreeChDirMode=2 " Let NERDTRee Change Directories for Me
let g:NERDTreeIgnore = ['\.pyc$', '\.swp$', '.DS_Store'] " Nerdtree doesnt follow wildignore anymore need to set them manually.
let g:Powerline_symbols='fancy' " Use fancy theme for PowerLine
let g:indent_guides_guide_size = 1 " Only use one column to show indent
let g:indent_guides_start_level = 2 " Start on the second level of indents
let g:syntastic_javascript_jslint_conf = "" " Default jslint

" Keymappings
" ============================
"
" Quick write, write quit and quit key mappings for normal mode
nmap <leader>w :write<CR>
nmap <leader>wq :write <bar> :quit<CR>
nmap <leader>q :quit<CR>

" Syntastic / Location list mappings
nmap <silent><leader>lc :lcl<CR>
nmap <silent><leader>lo :lw<CR>

" NERDTRee Keymappings
nmap <leader>nt :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFocus<CR>
nmap <leader>nch :NERDTree .<CR>

" Autocommands that cant live in after/filetypes
" ----------------------------------------------

if has('autocmd')
    autocmd BufNewFile,Bufread *.wsgi set ft=python
endif

" Extra Functions
" =====================

function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" If there is a vimrc.local source that before current
if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
set autoindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set backup " Store temporary files in a central spot
set backupdir=/var/tmp,/tmp
set backupdir=~/.vim/tmp/backup/
set cmdheight=2
set cursorline " Show highlight on the cursor line
set directory=~/.vim/tmp/
set diffopt+=iwhite
set encoding=utf8 " We write unicode so use utf8
set errorbells
set expandtab " Always use soft tabs
set hidden "If I close a buffer dont delete the changes
set history=10000
set hlsearch "Highlight results of a search
set ignorecase "Dont care about case when searching
set incsearch " Show search results while doing /
set laststatus=2 " Always have a status line regardless
"set list
"set listchars=tab:▸\ ,trail:⋅,nbsp:⋅ ",eol:¬
set magic
set nocompatible
set noswapfile
set number
set numberwidth=5
set scrolloff=3 " keep more context when scrolling off the end of a buffer
set shell=bash " This makes RVM work inside Vim. I have no idea why.
set shiftwidth=4
set showcmd " display incomplete commands
set showmatch
set showmode " Always show mode
set showtabline=2
set smartindent " Be smart when indenting
set softtabstop=4
set switchbuf=useopen
set t_Co=256 " If in terminal use 256 colors
set t_ti= t_te= " Prevent Vim from clobbering the scrollback buffer. See
set tabstop=4
set tags=~/.jstags,~/.tags,./tags " Look for tags in this file
set title "Show a window title
set textwidth=120
set undolevels=20 " Keep 20 undo levels
" set visualbell "Make the screen flash on bell
set wildignore=*.swp,*.bak,*.pyc " Set wildignore to hid swp, bak and pyc files
set wildmenu " make tab completion for files/buffers act like bash
set wildmode=longest,list " use emacs-style tab completion when selecting files, etc
set winminheight=0
set winwidth=79
syn case match
syn sync minlines=80
syntax on " Enable highlighting for syntax

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd FileType javascript,python set sw=4 sts=4 et

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
color inkpot

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PyLint
"augroup ftpy
"   autocmd!
"   autocmd FileType python compiler pylint
"augroup end

"let g:pylint_inline_highlight = 0
"let g:pylint_onwrite = 0
"let g:pylint_signs = 0

nnoremap <silent> <Leader>p :Pylint<CR> :copen<CR>
nnoremap <silent> <Leader>P :call Pep8()<CR> :copen<<CR>
nnoremap <silent> <Leader>c :cclose<CR>
nnoremap <silent> <Leader>C :copen<CR>

" Tagbar
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufEnter * if match( getline(1) , '^\#!') == 0 | execute("let b:interpreter = getline(1)[2:]") | endif

fun! CallInterpreter()
    if exists("b:interpreter")
         exec ("!".b:interpreter." %")
    endif
endfun

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F5> <ESC>:w<CR>:call CallInterpreter()<CR>

map <F11> :!ctags -R -f ./tags . &<CR>

" Call godoc on keyword
nnoremap <silent><Leader>d :Godoc<CR>

"omnicomplete
inoremap <C-Space> <C-X><C-I>

" Resize splits
nnoremap <silent> = :exe "vertical resize " . (winwidth(0) * 4/3)<CR>
nnoremap <silent> - :exe "vertical resize " . (winwidth(0) * 3/4)<CR>

" Find tag for selected word
nnoremap <C-]> :execute 'tj' expand('<cword>')<CR>zv

map <leader>y "*y

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>

nnoremap <leader><leader> <c-^>

"omnicomplete
inoremap <C-Space> <C-X><C-I>

"Ctrl-ArrowKeys = move between splits
nnoremap <C-Down> <C-W><down>
nnoremap <C-Left> <C-W><left>
nnoremap <C-Right> <C-W><right>
nnoremap <C-Up> <C-W><up>

nnoremap <C-\> :call DWM_New() <bar> :CtrlPCurWD<CR>
nnoremap <C-C> :call DWM_Close()<CR>
nnoremap <C-A> :call DWM_Focus()<CR>

"clear highlight search
nmap <silent> <leader><space> :nohlsearch<CR>
nnoremap <silent> <Leader>s :StripWhiteSpaces<CR>

"nnoremap ; :
"vnoremap ; :
"vnoremap : ;

map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

nnoremap <silent> <Leader>] :TagbarToggle<CR>
nnoremap <C-]> :execute 'tj' expand('<cword>')<CR>zv

"tab handling
nnoremap <Leader>t :tab sp<CR>
nnoremap <Leader>w :tabc<CR>
nnoremap <Leader>l :TagbarToggle<CR>
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

"make Y behave more like C and D
nmap Y y$

" Ack features
nnoremap <Leader>a :Ack
nnoremap <Leader>A :Ack <C-r><C-w><CR>

" CtrlP
"let g:ctrlp_working_path_mode = 2
"let g:ctrlp_extensions = ['dir']
let g:ctrlp_custom_ignore = {
\ 'dir':  'public/js/lib$',
\ 'file': '\.exe$\|\.so$\|\.dll$|\.swp$|\.swo$|\.pyc$|\.orig$',
\ 'link': 'some_bad_symbolic_links',
\ }
nnoremap <C-t> :CtrlPCurWD<CR>

" ctrl-j/k to jump between 'compiler' messages
nnoremap <silent> <C-n> :cn<CR>
nnoremap <silent> <C-m> :cp<CR>

" fix syntax hl:
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>
"save | close tab | reload vimrc
nnoremap <leader>V :w \| tabc \| so ~/.vimrc<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <c-l> <c-x><c-l>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()
nnoremap <Leader>cf :OpenChangedFiles<CR>

"DiffOrig opens a diff between the current buffer and the saved version
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" InsertTime COMMAND
" Insert the current time
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

cabbrev help vertical help
cabbrev hsplit split
cabbrev new vnew
cabbrev right botright
cabbrev sp vsp
cabbrev split vsplit
cabbrev sta vertical sta

" VJDE
let g:vjde_tab_cfu=1
let g:vjde_ctags_exts="java"

" Firefox refresh
" let g:firefox_refresh_files = "*.js"
let $firefox_refresh_host = "webclient"

" Go
let g:gofmt_command="goimports"
autocmd FileType go autocmd BufWritePre <buffer> Fmt
