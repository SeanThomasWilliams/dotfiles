" ======================== Vundle Config =================
"          _ __  __          __
"   ____ _(_) /_/ /_  __  __/ /_
"  / __ `/ / __/ __ \/ / / / __ \
" / /_/ / / /_/ / / / /_/ / /_/ /
" \__, /_/\__/_/ /_/\__,_/_.___/
"/____/ ----- Vim Bundles -------
"

set nocompatible " Required
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
" Vundle plugin manager
Plugin 'gmarik/vundle'
" Other plugins
Plugin 'Ivo-Donchev/vim-react-goto-definition'
Plugin 'RRethy/vim-illuminate'
Plugin 'SeanThomasWilliams/dwm.vim'
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'benekastah/neomake'
Plugin 'benmills/vimux'
Plugin 'benmills/vimux-golang'
Plugin 'bling/vim-airline'
Plugin 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plugin 'davidhalter/jedi-vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'gagoar/StripWhiteSpaces'
Plugin 'honza/vim-snippets'
Plugin 'jacoborus/tender.vim'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'lilydjwg/colorizer'
Plugin 'luochen1990/rainbow'
Plugin 'marijnh/tern_for_vim'
Plugin 'mileszs/ack.vim'
Plugin 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plugin 'pangloss/vim-javascript'
Plugin 'pearofducks/ansible-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'prettier/vim-prettier', { 'do': 'yarn install' }
Plugin 'sbdchd/neoformat'
Plugin 'shmup/vim-sql-syntax'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'vim-perl/vim-perl'
Plugin 'vimwiki/vimwiki'
Plugin 'will133/vim-dirdiff'
Plugin 'zchee/deoplete-go', { 'do': 'make' }
Plugin 'zchee/deoplete-jedi'

" Required, plugins available after.
call vundle#end()
filetype plugin indent on

"+----------------- Basic Configurations ------------+
" GUI Configuration
if has('gui_running')
  set spell " Spelling looks ugly in command line mode
  set spelllang=en_us " We speak amuurican
  set guioptions-=T
  "set guioptions=+M "Turn off annoying bars
  set guioptions+=LlRrb "Some kind of hack for scrollbars
  set guioptions-=LlRrb
  set guifont=Terminus\ 10
endif

" Vim-Script Configurations
let g:indent_guides_guide_size = 1 " Only use one column to show indent
let g:indent_guides_start_level = 2 " Start on the second level o

" Keymappings
" Quick write, write quit and quit key mappings for normal mode
nmap <leader>wq :write <bar> :quit<CR>
nmap <leader>q :quit<CR>

" Reload current file
nmap <leader>r :e! %<CR>

" Location list mappings
nmap <silent><leader>lc :lcl<CR>
nmap <silent><leader>lo :lw<CR>

" Quick search and replace
nmap  S  :%s//g<LEFT><LEFT>

" Quick copen/cclose
nnoremap <silent> <leader>c :cclose<CR>
nnoremap <silent> <leader>C :copen<CR>

" Map hotkey for make
nnoremap <silent> <leader>m :make<CR><C-w><Up>

" Make sure shebang-scripts can be run
if !exists('*MakeScriptExecuteable')
  function MakeScriptExecuteable()
    if getline(1) =~ "^#!.*/bin/"
      silent !chmod +x %:p
    endif
  endfunction
endif

" Autocommands that cant live in after/filetypes
if has('autocmd')
  augroup EditVim
    autocmd!

    " Save when losing focus
    " autocmd FocusLost * :silent! wall
    au BufWritePost * call MakeScriptExecuteable()

    " CWD to file dir
    "autocmd BufEnter * silent! lcd %:p:h

    " Show absolute numbers when in insert mode
    autocmd InsertEnter * :setlocal norelativenumber
    autocmd InsertLeave * :setlocal relativenumber

    " Only use relative numbers when the window is active
    autocmd BufEnter * :setlocal relativenumber
    autocmd WinEnter * :setlocal relativenumber
    autocmd BufLeave * :setlocal norelativenumber
    autocmd WinLeave * :setlocal norelativenumber

    " Only show cursorline in the current window and in normal mode.
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline

    " Fold shell scripts
    autocmd FileType sh let g:sh_fold_enabled=3
    autocmd FileType sh let g:is_bash=1
    autocmd FileType sh set foldmethod=syntax

    " Resize splits when the window is resized
    autocmd VimResized * :wincmd =

    " Filetypes
    autocmd BufNewFile,BufRead *.config setlocal ft=yaml et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.js setlocal et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.json setlocal et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.lua setlocal noet ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead *.py setlocal et ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead *.sh setlocal et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead */aws/jenkins/* setlocal ft=groovy et ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead */playbooks/vars/*.yml setlocal filetype=yaml.ansible et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead */tasks/*.yml setlocal filetype=yaml.ansible et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead Jenkinsfile* setlocal ft=groovy et ts=2 sw=2 sts=2
    autocmd BufNewFile,Bufread *.spect setlocal ft=spec
    autocmd BufNewFile,Bufread *.wsgi setlocal ft=python
    autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead Makefile setlocal noet ts=4 sw=4 sts=4

    " Python
    " Jedi defaults <leader>d to goto
    autocmd FileType python nmap <leader>D :split<CR>:call jedi#goto()<CR>

    " Beeauetify
    autocmd FileType json nnoremap <leader>f :Prettier<CR>
    autocmd FileType javascript nnoremap <leader>f :Prettier<CR>
    autocmd FileType html nnoremap <leader>f :call HtmlBeautify()<CR>
    autocmd FileType css nnoremap <leader>f :call CSSBeautify()<CR>
    autocmd FileType python nnoremap <leader>f :Neoformat<CR>
    autocmd FileType yaml nnoremap <leader>f :Neoformat<CR>

    " VimWIKI
    autocmd FileType vimwiki nnoremap <silent><leader>m :VimwikiAll2HTML<CR>

    " Golang
    autocmd FileType go map <leader>gi :wa<CR> :GoImports<CR>
    autocmd FileType go map <leader>b :wa<CR> :GoBuild<CR>
    autocmd FileType go map <leader>ra :wa<CR> :GolangTestCurrentPackage<CR>
    autocmd FileType go map <leader>rf :wa<CR> :GolangTestFocused<CR>
    autocmd FileType go nmap <leader>i <Plug>(go-info)
    autocmd FileType go nmap <leader>r <Plug>(go-rename)
    autocmd FileType go nmap <leader>d <Plug>(go-def)
    autocmd FileType go nmap <leader>D <Plug>(go-def-split)
    autocmd FileType go nmap <leader>rt <Plug>(go-run-tab)
    autocmd FileType go nmap <leader>rs <Plug>(go-run-split)
    autocmd FileType go nmap <leader>rv <Plug>(go-run-vertical)

    " JavaScript
    " React-goto-definition
    autocmd FileType javascript nmap <leader>rd :call ReactGotoDef()<CR>
    " Tern
    autocmd FileType javascript nmap <leader>d :TernDefSplit<CR>
    autocmd FileType javascript nmap <leader>D :TernDef<CR>
    autocmd FileType javascript nmap <leader>i :TernDoc<CR>

    " Neomake
    autocmd ColorScheme *
          \ hi link NeomakeError SpellBad |
          \ hi link NeomakeWarning SpellCap

    " Neomake options
    " When writing a buffer (no delay).
    "call neomake#configure#automake('w')
    " When writing a buffer (no delay), and on normal mode changes (after 750ms).
    "call neomake#configure#automake('rnw', 750)
    " When reading a buffer (after 1s), and when writing (no delay).
    "call neomake#configure#automake('rw', 1000)
    " Full config: when writing or reading a buffer, and on changes in insert and
    " normal mode (after 1s; no delay when writing).
    call neomake#configure#automake('nrwi', 1000)
  augroup END
endif

" Don't lose selection when shifting text in visual mode
xnoremap < <gv
xnoremap > >gv

" ARROW KEYS ARE UNACCEPTABLE
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

map <Esc>[B <Down>

" If there is a vimrc.local source that before current
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" Edit vimrc configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" Reload vimrc configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Show neovim health
nnoremap <Leader>ch :checkhealth<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('+relativenumber')
  set relativenumber
endif

if has('persistent_undo')
  set undolevels=5000
  set undodir=~/.vim/tmp/undo//     " undo files
  set undofile
endif

set autoindent
set autoread                    " Automatically reread changed files without asking me anything
set autowrite                   " Automatically save before :next, :make etc.
set background=dark
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set backup " Store temporary files in a central spot
set backupdir=~/.vim/tmp/backup// " backups
set cmdheight=2
set complete=.,w,b,u,t " Better Completion
set completeopt=menuone,preview " Better Completion Options
set clipboard+=unnamedplus
set cursorline " Show highlight on the cursor line
set diffopt+=iwhite
set directory=~/.vim/tmp/swap//   " swap files
set encoding=utf8 " We write unicode so use utf8
set errorbells
set expandtab " Always use soft tabs
set foldenable
set foldmethod=syntax
set foldlevelstart=20
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set hidden "If I close a buffer dont delete the changes
set history=10000
set hlsearch "Highlight results of a search
set ignorecase "Dont care about case when searching
set incsearch " Show search results while doing /
set laststatus=2 " Always have a status line regardless
set lazyredraw
set nolist " Don't use the listchars
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:⋅
set magic
set matchtime=3
set modelines=0
set nocompatible
set noerrorbells                " No beeps
set noshowmode " Always show mode
set noswapfile                    " it's 2013, Vim.
set number
set numberwidth=5
set omnifunc=syntaxcomplete#Complete
set pastetoggle=<F4>
set scrolloff=3 " keep moreiabbrev lmis ಠ‿ಠearch matches in the middle of the window.
set shell=bash " This makes RVM work inside Vim. I have no idea why.
set shiftround " Round intentations to the nearest shiftwidth
set shiftwidth=2
set showbreak=↪
set showcmd " display incomplete commands
set showmatch
set showtabline=2
set smartcase
set smartindent " Be smart when indenting
set softtabstop=2
set splitbelow                  " Split horizontal windows below to the current windows
set splitright                  " Split vertical windows right to the current windows
set switchbuf=useopen
set synmaxcol=500 " Don't try to highlight lines longer than X characters.
set t_Co=256 " If in terminal use 256 colors
set t_te= " Prevent Vim from clobbering the scrollback buffer.
set t_ti= " Prevent Vim from clobbering the scrollback buffer.
set tabstop=4
set tags=~/.tags,./tags " Look for tags in this file
set textwidth=120
set timeoutlen=250
set title "Show a window title
set ttyfast
set updatecount=10
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=__pycache__                      " Python cache
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.swp,*.bak,*.pyc                " Set wildignore to hid swp, bak and pyc files
set wildignore+=*.sw?                            " Vim swap files
set wildmenu " make tab completion for files/buffers act like bash
set wildmode=list:full
set winminheight=0
set winwidth=79

syntax case match
syntax sync minlines=1024
syntax on " Enable highlighting for syntax

" Make directories automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif

" Center on c-o
nnoremap <c-o> <c-o>zz

" Don't jump on *
nnoremap * *``

" COLOR
colorscheme tender
let g:airline_theme = 'tender'
" Enable true color 启用终端24位色
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" STATUS LINE
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" MISC FUNCTIONS

" Insert the current time
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<CR>

" MISC KEY MAPS
nnoremap <silent> <F2> :set nonumber!<CR>:set relativenumber!<CR>:set foldcolumn=0<CR>
nnoremap <F5> <ESC>:w<CR>:call CallInterpreter()<CR>

map <F11> :!ctags -R -f ./tags . &<CR>

"omnicomplete
inoremap <C-Space> <C-X><C-I>
inoremap <C-Space> <C-X><C-I>

" Resize splits
nnoremap <silent> + :exe "vertical resize " . (winwidth(0) * 4/3)<CR>
nnoremap <silent> - :exe "vertical resize " . (winwidth(0) * 3/4)<CR>

" " Copy to clipboard
vnoremap  <leader>y "+y
nnoremap  <leader>Y "+yg_
nnoremap  <leader>y "+y
nnoremap  <leader>yy "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" switch tabs with Ctrl left and right
nnoremap <C-right> :tabnext<CR>
nnoremap <C-left> :tabprevious<CR>
" switch buffers with Ctrl up and down
nnoremap <C-up> :bn<CR>
nnoremap <C-down> :bN<CR>
" and whilst in insert mode
inoremap <C-right> <Esc>:tabnext<CR>
inoremap <C-left> <Esc>:tabprevious<CR>
" switch buffers with Ctrl up and down in insert mode
inoremap <C-up> <Esc>:bn<CR>
inoremap <C-down> <Esc>:bN<CR>

" New tab shortcut
nnoremap <leader>w :tabnew<CR>:TW<CR>

" Swap files
nnoremap <leader><leader> <c-^>

nnoremap <C-C> :call DWM_Close()<CR>
nnoremap <C-A> :call DWM_Focus()<CR>

"clear highlight search
nmap <silent> <leader><space> :nohlsearch<CR>
nnoremap <silent> <leader>s :StripWhiteSpaces<CR>

"Fix shell expansion with putty
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

"tab handling
nnoremap <leader>t :tab sp<CR>
nnoremap <leader>c :tabc<CR>

"make Y behave more like C and D
nmap Y y$

" CtrlP
"let g:ctrlp_working_path_mode = 'ra'
""let g:ctrlp_extensions = ['dir']
"let g:ctrlp_switch_buffer = 'et'    " jump to a file if it's open already
"let g:ctrlp_mruf_max=450        " number of recently opened files
"let g:ctrlp_max_files=10000         " do not limit the number of searchable files
"let g:ctrlp_use_caching = 0
"let g:ctrlp_clear_cache_on_exit = 1
"let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
"let g:ctrlp_custom_ignore = {
"      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|ext$\|resources$\|project_files$\|export$',
"      \ 'file': '\v\.(exe|so|dll|swp|swo|pyc|orig|jpg|png|tif|jpg|png|tiff)$',
"      \ }
"let g:ctrlp_buftag_types = {
"      \ 'go'         : '--language-force=go --golang-types=ftv',
"      \ 'coffee'     : '--language-force=coffee --coffee-types=cmfvf',
"      \ 'markdown'   : '--language-force=markdown --markdown-types=hik',
"      \ 'objc'       : '--language-force=objc --objc-types=mpci',
"      \ 'rc'         : '--language-force=rust --rust-types=fTm'
"      \ }
"let g:ctrlp_by_filename = 0
"let g:ctrlp_lazy_update = 1


"if executable('ag')
"  "let g:ackprg = 'ag --vimgrep'
"
"  " Use ag over grep
"  "set grepprg=ag\ --nocolor\ --nogroup\ --vimgrep
"
"  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
""  let g:ctrlp_user_command = {
""      \ 'types': {
""        \ 1: ['.git', 'cd %s && git ls-files']
""        \ },
""      \ 'fallback': 'ag %s -l --nocolor -g "" ' . $CONDA_PREFIX
""      \ }
"
"  "NOTE: --ignore option use wildcard PATTERN instead of regex PATTERN,and
"  "it does not support {}
"  "--hidden:enable seach hidden dirs and files
"  "-g <regex PATTERN>:search file name that match the PATTERN
"  let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup
"              \ --ignore "*.exe"
"              \ --ignore "*.out"
"              \ --ignore "*.hex"
"              \ --ignore "cscope*"
"              \ --ignore "*.so"
"              \ --ignore "*.dll"
"              \ --ignore ".git"
"              \ -g "" '.$CONDA_PREFIX .'/'
"
"  " ag is fast enough that CtrlP doesn't need to cache
"  "let g:ctrlp_use_caching = 0
"endif

if !empty(glob($HOME . '/anaconda3/bin/python3'))
  let g:python3_host_prog = $HOME . '/anaconda3/bin/python3'
endif
if has('python') " if dynamic py|py3, this line already activates python2.
  let s:python_version = 2
elseif has('python3')
  let s:python_version = 3
else
  let s:python_version = 0
endif

let $SITE_PACKAGES=expand("$CONDA_PREFIX") . '/lib/python3.7/site-packages'
nnoremap <C-t> :FZF<CR>
nnoremap <C-p> :Files $SITE_PACKAGES<CR>
nnoremap <C-\> :split<CR> :FZF<CR>

nnoremap <leader>a :execute 'Ag '.input('Ag: ')<CR>
nnoremap <leader>A :Ag <C-r><C-w><CR>
nnoremap <leader>l :execute 'Locate "'.input('Locate: ').'"'<CR>

" Change to directory of current file
nnoremap <leader>cd :lcd%:p:h<CR>

" ctrl-n/m to jump between 'compiler' messages
"nnoremap <silent> <C-n> :cn<CR>
"nnoremap <silent> <C-m> :cp<CR>

" fix syntax hl:
nnoremap U :syntax sync fromstart<CR>:redraw!<CR>

" ------------------------------------------"
" Plugin Settings
" ----------------------------------------- "

" ansible-vim
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1

" Skip the check of neovim module
let g:python3_host_skip_check = 1

" Deoplete
let g:deoplete#auto_complete_delay = 50
let g:deoplete#min_pattern_length = 1
let g:deoplete#max_list = 100
let g:deoplete#smart_case = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1

" Deoplete Jedi/Python
let g:deoplete#sources#jedi#show_docstring = 1
let g:jedi#completions_command = "<C-Space>"
let g:jedi#documentation_command = "K"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_definitions_command = ""
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"
let g:jedi#usages_command = "<leader>n"

" Deoplete Golang
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#json_directory = $HOME . '.vim/deocache'
let g:deoplete#sources#go#use_cache = 1

" Deoplete javascript/ternjs
let g:deoplete#sources#ternjs#timeout = 1
" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#case_insensitive = 1

" tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:tern_request_timeout = 6000

" Go settings
let g:go_auto_type_info = 1
let g:go_dispatch_enabled = 1
let g:go_fmt_fail_silently = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_jump_to_error = 1
let g:go_play_open_browser = 0
let g:go_def_mapping_enabled=0

" Tern
let g:tern_map_keys = 1
let g:tern_map_prefix = '<leader>'
let g:tern_show_argument_hints='on_hold'

" vim-illuminate
hi link illuminatedWord Visual

" Rainbow
let g:rainbow_active = 1

" Neoformat
" Python formatters
let g:neoformat_enabled_python = ['yapf', 'isort', 'docformatter']
" YAML formatters
let g:neoformat_enabled_yaml = ['pyyaml', 'prettier']
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1
" Have Neoformat only msg when there is an error
let g:neoformat_only_msg_on_error = 1

" Neomake
let g:neomake_python_enabled_makers = ['python', 'pycodestyle']
let g:neomake_javascript_enabled_makers = ['eslint', 'jshint']
let g:neomake_error_sign = {
      \ 'text': 'E>',
      \ 'texthl': 'ErrorMsg',
      \ }
let g:neomake_warning_sign = {
      \ 'text': 'W>',
      \ 'texthl': 'WarningMsg',
      \ }
let g:neomake_tempfile_dir = '/tmp/neomake%:p:h'

" Firefox refresh
"let g:firefox_refresh_files = "*.js"
"let $firefox_refresh_host = "webclient"

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_mode_map = {} " see source for the defaults

let g:autopep8_max_line_length=120
let g:autopep8_pep8_passes=100
let g:autopep8_aggressive=2
let g:autopep8_indent_size=4
let g:autopep8_disable_show_diff=1
let g:autopep8_on_save = 1

" vim-dirdiff
let g:DirDiffExcludes = "certs,images,plm*,prps*,one*,ammo*,pmrt*,ccar*,cie*,*test*.yml,*lab*.yml,*prod*.yml,README.md,*.war,*.rpm"
let g:DirDiffIgnore = "Id:"
" ignore white space in diff
let g:DirDiffAddArgs = "-w"
let g:DirDiffEnableMappings = 1

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" snippets / neosnippet
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" C-k to execute snippet
imap <C-s>     <Plug>(neosnippet_expand)
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"" Expand the completed snippet trigger by <CR>.
imap <expr><CR>
      \ (pumvisible() && neosnippet#expandable()) ?
      \ "\<Plug>(neosnippet_expand)" : "\<CR>"

" For conceal markers.
if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

" Thyme pormordio timer
nmap <silent><leader>p :silent !thyme -d<CR>

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" Vimwiki
" Turn off URL shortening
let g:vimwiki_url_maxsave=0
" Wiki export config
let g:vimwiki_list = [{
      \ 'path': '$HOME/sync/vimwiki/',
      \ 'path_html': '$HOME/wiki/',
      \ 'diary_index': 'index',
      \ 'diary_rel_path': 'diary/',
      \ 'template_path': '$HOME/wiki/vimwiki-assets/',
      \ 'template_default': 'default',
      \ 'template_ext': '.tmpl',
      \ 'auto_export': 0,
      \ 'automatic_nested_syntaxes': 0,
      \ 'nested_syntaxes': {
      \ 'js':'javascript',
      \ 'json':'javascript',
      \ 'java':'java',
      \ 'yaml':'yaml',
      \ 'bash':'bash',
      \ 'sh':'shell',
      \ 'python':'python'
      \ }}]

let g:autopep8_max_line_length=120

" Vimux Config
let g:VimuxHeight = "33"
" Doesn't seem to work
let g:VimuxUseNearest = 1

function! VimuxShebangSlime()
  call VimuxOpenRunner()
  if getline(1) =~ "^#!.*/bin/"
    " Get the command after the shebang
    let runcmd = strpart(getline(1), 2)
    call VimuxSendText(runcmd . ' ' . @v)
  else
    call VimuxSendText(@v)
    call VimuxSendKeys("Enter")
  endif
endfunction

vmap <Leader>vs "vy :call VimuxShebangSlime()<CR>gv
nmap <Leader>vo :call VimuxOpenRunner()<CR>
