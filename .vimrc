" ======================== Vundle Config =================
"          _ __  __          __
"   ____ _(_) /_/ /_  __  __/ /_
"  / __ `/ / __/ __ \/ / / / __ \
" / /_/ / / /_/ / / / /_/ / /_/ /
" \__, /_/\__/_/ /_/\__,_/_.___/
"/____/ ----- Vim Bundles -------
"

set nocompatible " Required

call plug#begin('~/.vim/plugged')
" Other plugins
" Plug 'davidhalter/jedi-vim'
" Plug 'ervandew/supertab'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" Plug 'zchee/deoplete-jedi'
" Plug 'RRethy/vim-illuminate'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'hashivim/vim-terraform'
" Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'Ivo-Donchev/vim-react-goto-definition'
Plug 'SeanThomasWilliams/dwm.vim'
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'arakashic/nvim-colors-solarized'
Plug 'benekastah/neomake'
Plug 'benmills/vimux'
Plug 'benmills/vimux-golang'
Plug 'bling/vim-airline'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'gagoar/StripWhiteSpaces'
Plug 'github/copilot.vim'
Plug 'honza/vim-snippets'
Plug 'hrsh7th/nvim-compe'
Plug 'jacoborus/tender.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kristijanhusak/completion-tags'
Plug 'leafgarland/typescript-vim'
Plug 'lilydjwg/colorizer'
Plug 'ludovicchabant/vim-gutentags'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'marijnh/tern_for_vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'neovim/nvim-lspconfig', { 'do': 'sudo npm i -g pyright' }
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'peitalin/vim-jsx-typescript'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --no-lockfile' }
Plug 'projekt0n/github-nvim-theme'
Plug 'sbdchd/neoformat'
Plug 'shmup/vim-sql-syntax'
Plug 'towolf/vim-helm'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-perl/vim-perl'
Plug 'vimwiki/vimwiki'
Plug 'will133/vim-dirdiff'
" Plug 'xiyaowong/nvim-transparent'

" Required, plugins available after.
call plug#end()

lua require('init')

"+----------------- Basic Configurations ------------+
" GUI Configuration
if has('gui_running')
  set guioptions-=T
  set guioptions+=LlRrb "Some kind of hack for scrollbars
  set guioptions-=LlRrb
  set guifont=Terminus\ 10
endif

" Commenting blocks of code.
let b:comment_leader = '# '
autocmd FileType c,cpp,go,java,scala    let b:comment_leader = '// '
autocmd FileType yaml,sh,ruby,python    let b:comment_leader = '# '
autocmd FileType terraform              let b:comment_leader = '# '
autocmd FileType conf,fstab             let b:comment_leader = '# '
autocmd FileType tex                    let b:comment_leader = '% '
autocmd FileType mail                   let b:comment_leader = '> '
autocmd FileType vim                    let b:comment_leader = '" '
" Comment and uncomment
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Vim-Script Configurations
let g:indent_guides_guide_size = 1 " Only use one column to show indent
let g:indent_guides_start_level = 2 " Start on the second level o

" Keymappings
" Quick write, write quit and quit key mappings for normal mode
nmap <leader>wq :write <bar> :quit<CR>
nmap <leader>q :quit<CR>

" Reload current file
nmap <leader>re :e! %<CR>

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

" Don't lose selection when shifting text in visual or select mode
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
" Run PlugInstall after reload
nnoremap <Leader>pi :source $MYVIMRC<CR>:PlugInstall<CR>

" Show neovim health
nnoremap <Leader>ch :checkhealth<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ file management options
set autoread                      " Automatically reread changed files without asking me anything
set autowrite                     " Automatically save before :next, :make etc.
set undolevels=1000               " How many undos
set undoreload=10000              " number of lines to save for undo
set undodir=~/.vim/tmp/undo//     " undo files
set undofile                      " Save undo's after file closes
set backup                        " Store temporary files in a central spot
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set fileformats=unix,dos,mac      " Prefer Unix over Windows over OS 9 formats
set history=10000                 " Command history
set noswapfile                    " it's 2013, Vim.
set tags=~/.tags,./tags           " Look for tags in this file
" }}}

" {{{ colorscheme/style options
colorscheme github_dimmed " github_dark_default github_dark
let g:airline_theme = 'tender'
" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors " Enables truecolor in neovim >= 0.1.5
endif

set number        " Displays line numbers
set colorcolumn=+1 " highlight column after 'textwidth'
set novisualbell
set errorbells
set cursorline " Show highlight on the cursor line
"set showbreak=↪
set background=dark
set bg=dark
" Make syntax errors in SCREAM
" (otherwise a missing comma in JSON is bold red vs regular red - not visible)
" :highlight Error term=reverse cterm=bold ctermfg=7 ctermbg=1 guifg=White guibg=Red
" }}}

" {{{ Misc UI settings
set encoding=utf-8
scriptencoding utf-8
set pastetoggle=<F4>
set shell=bash " This makes RVM work inside Vim. I have no idea why.
set showcmd " display incomplete commands
set splitbelow                  " Split horizontal windows below to the current windows
set splitright                  " Split vertical windows right to the current windows
set switchbuf=useopen
set synmaxcol=500 " Don't try to highlight lines longer than X characters.
set cmdheight=1
set laststatus=2 " Always have a status line regardless
set modeline
set modelines=5
set numberwidth=5
set mouse=a " Enable mouse in console mode
set noshelltemp " Be a bit faster when executing command-line shell stuff
set hidden " hide open buffers instead of closing them, when opening a new one with :e
set shortmess=actI " Deactivate the PRESS ENTER OR TYPE COMMAND TO CONTINUE message
set clipboard=unnamed " Allows copy-pasting from other apps
set scrolloff=3 " keep moreiabbrev lmis ಠ‿ಠearch matches in the middle of the window.
set redrawtime=10000 " time in ms for redrawing the display (default 2000)
set sidescrolloff=1 " Add some space around the cursor when moving it near the borders of the screen
set lazyredraw " Don't update screen during macro and script execution
set winminheight=0
set winwidth=79
set textwidth=120
set timeoutlen=250
set title " Show a window title
set updatecount=10
" }}}

" {{{ Folding settings
set foldenable
set foldmethod=syntax " Use syntax fold
set foldlevel=99      " Folds are open by default
set foldlevelstart=99 " Folds are open by default (new way)
let ruby_fold=0
let go_fold=0
let lua_fold=1
let javascript_fold=1
" }}}

" {{{ completion options
" set omnifunc=syntaxcomplete#Complete
set complete=.,w,b,u,t " Better Completion
" set completeopt=menuone,noselect
set completeopt=menuone
set completeopt+=noinsert
set completeopt-=preview
set iskeyword+=- " Allow autocomplete to treat thes as part of a completion
set updatetime=300
" }}}

" {{{ Search settings
set magic
set hlsearch    " highlight matches
set incsearch   " incremental searching
set inccommand= " incremental everything
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter
" }}}

" {{{ Whitespace settings
set diffopt=internal,algorithm:patience,indent-heuristic
set nowrap                          " don't wrap lines
set tabstop=2                       " a tab is two spaces
set shiftround                      " Round intentations to the nearest shiftwidth
set showtabline=2                   " When tab labels will be shown
set softtabstop=2                   " Number of spaces for a tab
set shiftwidth=2                    " an autoindent (with <<) is two spaces
set autoindent                      " Copy indent from the current line to a new line
set smartindent                     " Be smart when indenting
set smarttab                        " Insert "tabstop" spaces when tab is pressed
set expandtab                       " use spaces, not tabs
set backspace=indent,eol,start      " backspace through everything in insert mode
set list                            " Show invisible characters using listchars
set listchars=""                    " Reset the listchars
set listchars=tab:›\                " show tabs as lsaquos
set listchars+=trail:·              " show trailing spaces as dots
set listchars+=nbsp:·               " show trailing non-breaking-spaces as dots
set listchars+=extends:❯            " The character in the last column when the line continues right
set listchars+=precedes:❮           " The character in the first column when the line continues left
" }}}

" {{{ Wildmenu settings
set wildmenu wildmode=longest:full
set wildignorecase
" Ignore these files when auto-completing with tab (for example when opening with :e)
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem          " general programming
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz                      " compressed files
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " vendor and sass
set wildignore+=*/node_modules/*
set wildignore+=*.swp,*~,._*
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.min.*                          " Minified web artifacts
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=*.swp,*.bak,*.pyc                " Set wildignore to hid swp, bak and pyc files
set wildignore+=.hg,.git,.svn                    " Version control
" }}}

" {{{ Matching closing character settings
set showmatch     " Display matching parent
set matchtime=4   " Time to display matching parent, in tens of second
set mmp=5000      " Set pattern max memory
" }}}

syntax case match
syntax sync minlines=1024
if !exists("g:syntax_on")
    syntax enable
endif

" Autocommands that cant live in after/filetypes
if has('autocmd')
  filetype plugin indent on           " allow for individual indentations per file type

  augroup LargeFile
    let g:large_file = 1048576 " 1MB

    " Set options:
    "   eventignore+=FileType (no syntax highlighting etc assumes FileType always on)
    "   noswapfile (save copy of file)
    "   bufhidden=unload (save memory when other file is viewed)
    "   buftype=nowritefile (is read-only)
    "   undolevels=-1 (no undo possible)
    "   \ set eventignore+=FileType |
    au BufReadPre *
      \ let f=expand("<afile>") |
      \ if getfsize(f) > g:large_file |
        \ set eventignore=all |
        \ setlocal wrap noswapfile bufhidden=unload buftype=nowrite nohidden syntax=off ft= |
      \ else |
        \ set eventignore-=FileType |
      \ endif
  augroup END

  augroup Shell
    autocmd!
    " Make shell scripts executable
    au BufWritePost * call MakeScriptExecuteable()

    " Make default filetype sh
    autocmd BufEnter * if &filetype == "" | setlocal ft=sh | endif

    " Fold shell scripts
    autocmd FileType sh let g:sh_fold_enabled=3
    autocmd FileType sh let g:is_bash=1
  augroup end

  augroup Numbering
    autocmd!

    " After opening, jump to last known cursor position unless it's invalid or in an event handler
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    if exists('+relativenumber')
      " Show absolute numbers when in insert mode
      autocmd InsertEnter * :setlocal norelativenumber
      autocmd InsertLeave * :setlocal relativenumber

      " Only use relative numbers when the window is active
      autocmd BufEnter * :setlocal relativenumber
      autocmd WinEnter * :setlocal relativenumber
      autocmd BufLeave * :setlocal norelativenumber
      autocmd WinLeave * :setlocal norelativenumber
    endif

    " Only show cursorline in the current window and in normal mode.
    autocmd WinLeave,InsertEnter * set nocursorline
    autocmd WinEnter,InsertLeave * set cursorline
  augroup end

  augroup Sizing
    autocmd!

    " Resize splits when the window is resized
    autocmd VimResized * :wincmd =
  augroup end

  augroup Filetypes
    autocmd!

    " Filetypes
    autocmd BufNewFile,BufRead .alias* setlocal ft=sh
    autocmd BufNewFile,BufRead *.config setlocal ft=yaml et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.j2 setlocal ft=yaml et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.js setlocal et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.json setlocal et ts=2 sw=2 sts=2 conceallevel=0
    autocmd BufNewFile,BufRead *.lua setlocal noet ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead *.py setlocal et ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead *.sh setlocal et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead */aws/jenkins/* setlocal ft=groovy
    autocmd BufNewFile,BufRead */playbooks/vars/*.yml setlocal filetype=yaml.ansible et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead */tasks/*.yml setlocal filetype=yaml.ansible et ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead Jenkinsfile* setlocal ft=groovy
    autocmd BufNewFile,BufRead *.jenkinsfile setlocal ft=groovy
    autocmd BufNewFile,Bufread *.spect setlocal ft=spec
    autocmd BufNewFile,Bufread *.wsgi setlocal ft=python
    autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
    autocmd FileType make setlocal noet ts=4 sw=4 sts=4 foldmethod=marker foldlevel=1
    autocmd FileType make nnoremap <silent> <leader>d :sp<CR> <c-]>
    autocmd FileType markdown setlocal wrap spell spelllang=en_us
    autocmd FileType terraform nnoremap <leader>f :Neoformat<CR>
    autocmd FileType hcl nnoremap <leader>f :Neoformat<CR>
  augroup end

  augroup Python
    autocmd!
    " Python
    " Jedi defaults <leader>d to goto
    autocmd FileType python nnoremap <leader>sd :sp<CR>:call jedi#goto()<CR>
    autocmd FileType python nnoremap <leader>f :Neoformat<CR>
  augroup end

  augroup Golang
    autocmd!

    " Golang
    autocmd FileType go nnoremap <silent> <leader>d  :<C-u>call go#def#Jump('', 0)<CR>
    autocmd FileType go nnoremap <silent> <leader>sd :sp<CR> :silent call go#def#Jump('', 0)<CR>
    autocmd FileType go nnoremap <silent> <leader>gb :wa<CR> :GoBuild<CR>
    autocmd FileType go nnoremap <silent> <leader>gi :wa<CR> :GoImports<CR>
    autocmd FileType go nnoremap <silent> <leader>i  <Plug>(go-info)
    autocmd FileType go nnoremap <silent> <leader>r  <Plug>(go-rename)
    autocmd FileType go nnoremap <silent> <leader>tf :wa<CR> :GolangTestFocused<CR>
    autocmd FileType go nnoremap <silent> <leader>tp :wa<CR> :GolangTestCurrentPackage<CR>
    autocmd FileType go nnoremap <silent> <leader>rt <Plug>(go-run-tab)
    autocmd FileType go nnoremap <silent> <leader>rs <Plug>(go-run-split)
    autocmd FileType go nnoremap <silent> <leader>rv <Plug>(go-run-vertical)
    autocmd BufWritePost *.go silent! GoBuild -i
  augroup end

  augroup Frontend
    autocmd!

    autocmd FileType javascript nnoremap <leader>f :Prettier<CR>
    autocmd FileType html nnoremap <leader>f :call HtmlBeautify()<CR>
    autocmd FileType css nnoremap <leader>f :call CSSBeautify()<CR>

    " React-goto-definition
    autocmd FileType javascript nmap <leader>rd :call ReactGotoDef()<CR>
    " Tern
    autocmd FileType javascript nmap <leader>d :TernDefSplit<CR>
    autocmd FileType javascript nmap <leader>D :TernDef<CR>
    autocmd FileType javascript nmap <leader>i :TernDoc<CR>
  augroup end

  augroup ConfigFiles
    autocmd!

    autocmd FileType json nnoremap <leader>f :Prettier<CR>
    autocmd FileType yaml nnoremap <leader>f :Neoformat<CR>
  augroup end

  augroup Completion
    autocmd!

    " (Optional)Hide Info(Preview) window after completions
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
  augroup end

  augroup Misc
    autocmd!

    " VimWIKI
    autocmd FileType vimwiki nnoremap <silent><leader>M :VimwikiAll2HTML<CR>

    " Neomake
    autocmd ColorScheme *
          \ hi link NeomakeError SpellBad |
          \ hi link NeomakeWarning SpellCap

    " Neomake options
    " normal mode (after 1s; no delay when writing).
    call neomake#configure#automake('nrwi', 1000)
  augroup end
endif

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

" Auto-adjust the quickfix window height
au FileType qf call AdjustWindowHeight(3, 10)
 function! AdjustWindowHeight(minheight, maxheight)
     let l = 1
     let n_lines = 0
     let w_width = winwidth(0)
     while l <= line('$')
         " number to float for division
         let l_len = strlen(getline(l)) + 0.0
         let line_width = l_len/w_width
         let n_lines += float2nr(ceil(line_width))
         let l += 1
     endw
     exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
 endfunction

" Center on c-o
nnoremap <c-o> <c-o>zz

" Don't jump on *
nnoremap * *``

" STATUS LINE
" set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
"------------------------------------------------
" Status Line START
set statusline=%<%f\ %h%m%r
set statusline+=%=%-10.60{LspStatus()}\ %-.(%l,%c%V%)\ %P

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction
" Status Line END
"------------------------------------------------

" MISC FUNCTIONS

" Edit WorkLog Journal
nnoremap <silent> <leader>wl :e ~/vimwiki/WorkLog.md<CR>

" MISC KEY MAPS
nnoremap <silent> <F2> :set nonumber!<CR>:set relativenumber!<CR>:set foldcolumn=0<CR>
nnoremap <F5> <ESC>:w<CR>:call CallInterpreter()<CR>

" Indent by spaces TODO: <silent>
noremap <silent> {{ :s/^  //e<CR>:nohlsearch<CR>
noremap <silent> }} :s/^/  /e<CR>:nohlsearch<CR>

"noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
"noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
"omnicomplete
" inoremap <C-Space> <C-X><C-I>

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

if !empty(glob($HOME . '/anaconda3/bin/python3'))
  let g:python3_host_prog = $HOME . '/anaconda3/bin/python3'
endif

if has('python3') " if dynamic py|py3, this line already activates python3.
  let s:python_version = 3
elseif has('python')
  let s:python_version = 2
else
  let s:python_version = 0
endif

function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n', '', 'g')
endfunction

" Python site-packages
let g:site_packages = ChompedSystem('python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"')

" FZF configuration
nnoremap <C-p> :execute ':Files' . g:site_packages<CR>
nnoremap <C-T> :Tags<CR>
nnoremap <C-\> :split<CR> :FZF<CR>
nnoremap <C-t> :FZF<CR>

" Rg configuration
nnoremap <leader>a :execute 'Rg '.input('Rg: ')<CR>
nnoremap <leader>A :Rg <C-r><C-w><CR>
nnoremap <leader>l :execute 'Locate "'.input('Locate: ').'"'<CR>

" Change to directory of current file
nnoremap <leader>cd :lcd%:p:h<CR>

" fix syntax hl:
nnoremap U :syntax sync fromstart<CR>:redraw!<CR>
nnoremap U :syntax sync fromstart<CR>:redraw!<CR>

" ------------------------------------------"
" Plugin Settings
" ----------------------------------------- "

" LSP + Tag Completion
" Or combine with lsp
"autocmd BufEnter * lua require'completion'.on_attach()
"
"let g:completion_chain_complete_list = {
"      \ 'default': [
"      \    {'complete_items': ['lsp', 'tags']},
"      \  ]}

" tagbar
nnoremap <silent> <leader>b :TagbarToggle<CR>
" autocmd FileType * nested :call tagbar#autoopen(0)
let g:tagbar_compact = 1
let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'ansible',
    \ 'kinds' : [
      \ 't:Tasks',
      \ 'h:Hosts'
    \ ],
    \ 'sort' : 0
    \ }

let g:tagbar_type_terraform = {
    \ 'ctagstype' : 'terraform',
    \ 'kinds' : [
      \ 'd:Data',
      \ 'r:Resources',
      \ 'm:Modules',
      \ 'o:Outputs',
      \ 'P:Providers',
      \ 'v:Variables',
      \ 'f:TFVars'
    \ ],
    \ 'sort': 0
    \ }

if executable('cmake-language-server')
  au User lsp_setup call lsp#register_server({
  \ 'name': 'cmake',
  \ 'cmd': {server_info->['cmake-language-server']},
  \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'build/'))},
  \ 'whitelist': ['cmake'],
  \ 'initialization_options': {
  \   'buildDirectory': 'build',
  \ }
  \})
endif

" gutentags
set statusline+=%{gutentags#statusline()}
let g:gutentags_define_advanced_commands = 1 " Extra Debugging
let g:gutentags_file_list_command = {
\  'markers': {
\    '.pythontags': $HOME . '/bin/python-file-lister'
\  }
\}
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git', '.pythontags', '.forcetags', '.envrc']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" gutentags-ctags
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

" ansible-vim
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1

" Deoplete
" let g:deoplete#omni_patterns = {}
" let g:deoplete#auto_complete_delay = 50
" let g:deoplete#min_pattern_length = 1
" let g:deoplete#max_list = 100
" let g:deoplete#smart_case = 1
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#file#enable_buffer_path = 1

" Deoplete Jedi/Python
" let g:deoplete#sources#jedi#show_docstring = 1
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#documentation_command = "K"
" let g:jedi#goto_assignments_command = "<leader>g"
" let g:jedi#goto_command = "<leader>d"
" let g:jedi#goto_definitions_command = ""
" let g:jedi#rename_command = "<leader>r"
" let g:jedi#show_call_signatures = 1
" let g:jedi#smart_auto_mappings = 1
" let g:jedi#usages_command = "<leader>n"

" Deoplete Golang
" let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" let g:deoplete#sources#go#json_directory = $HOME . '.vim/deocache'
" let g:deoplete#sources#go#use_cache = 1

" Deoplete javascript/ternjs
" let g:deoplete#sources#ternjs#timeout = 1
" Whether to include the types of the completions in the result data. Default: 0
" let g:deoplete#sources#ternjs#types = 1
" let g:deoplete#sources#ternjs#case_insensitive = 1

" call deoplete#initialize()

" tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:tern_request_timeout = 6000

" Go settings
let g:go_gocode_propose_source = 1
let g:go_auto_type_info = 1
let g:go_dispatch_enabled = 1
let g:go_fmt_fail_silently = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_jump_to_error = 1
let g:go_play_open_browser = 0
let g:go_def_mapping_enabled = 0
let g:go_def_reuse_buffer = 1
let g:go_echo_commands_disabled = ['godef']
let g:go_echo_command_info = 0

" Tern
let g:tern_map_keys = 1
let g:tern_map_prefix = '<leader>'
let g:tern_show_argument_hints='on_hold'

" vim-illuminate
" Time in milliseconds (default 250)
let g:Illuminate_delay = 250
" Don't highlight word under cursor (default: 1)
let g:Illuminate_highlightUnderCursor = 1
" Don't illumilate on these filetypes
let g:Illuminate_ftblacklist = ['nerdtree']
" Visual highlight
hi link illuminatedWord Visual

" Rainbow
let g:rainbow_active = 1

" Neoformat
" Python formatters
let g:neoformat_python_autoflake = {
  \ 'exe': 'autoflake',
  \ 'stdin': 0,
  \ 'replace': 1,
  \ 'args': [
    \   '--in-place',
    \   '--remove-all-unused-imports',
    \   '--ignore-init-module-imports',
    \   '--expand-star-imports',
    \   '--remove-unused-variables',
    \   '--remove-duplicate-keys',
  \ ],
  \ }

let g:neoformat_enabled_python = ['isort', 'black']
" YAML formatters
let g:neoformat_enabled_yaml = ['beautifyk8s']
let g:neoformat_yaml_beautifyk8s = {
            \ 'exe': 'beautify-k8s',
            \ 'args': ['-i'],
            \ 'stdin': 0,
            \ 'replace': 0,
            \ 'valid_exit_codes': [0],
            \ }
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1
" Have Neoformat only msg when there is an error
let g:neoformat_only_msg_on_error = 1

" {{{ Neomake options
:highlight NeomakeSign guifg=Yellow guibg=#dc322f gui=bold
let g:neomake_makeprg_buffer_output = 0
"let g:neomake_open_list = 1
let g:neomake_python_enabled_makers = ['python', 'frosted', 'flake8']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_dockerfile_enabled_makers = []
let g:neomake_java_enabled_makers = []
let g:neomake_error_sign = {
      \ 'text': '•',
      \ 'texthl': 'NeomakeSign',
      \ }
let g:neomake_warning_sign = {
      \ 'text': '!',
      \ 'texthl': 'NeomakeSign',
      \ }
let g:neomake_tempfile_dir = '/tmp/neomake%:p:h'
" }}}

" Firefox refresh
"let g:firefox_refresh_files = "*.js"
"let $firefox_refresh_host = "webclient"

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_mode_map = {} " see source for the defaults

" autopep8
let g:autopep8_max_line_length=120
let g:autopep8_pep8_passes=100
let g:autopep8_aggressive=2
let g:autopep8_indent_size=4
let g:autopep8_disable_show_diff=1
let g:autopep8_on_save = 1

" vim-dirdiff
let g:DirDiffExcludes = ".git,certs,images,README.md,*.war,*.rpm"
let g:DirDiffIgnore = ""
let g:DirDiffAddArgs = "-w" " ignore white space in diff
let g:DirDiffEnableMappings = 1

" supertab
" let g:SuperTabDefaultCompletionType = "<c-n>"

" snippets
" let g:neosnippet#enable_snipmate_compatibility = 1
" let g:completion_enable_snippet = 'Neosnippet'
"let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'
"let g:UltiSnipsSnippetDirectories=[expand("$HOME/.vim/plugged/vim-snippets/snippets")]
" let g:UltiSnipsExpandTrigger="<C-x><C-s>"

" terraform
let g:terraform_align = 1
let g:terraform_commentstring = '//%s'
let g:terraform_fmt_on_save = 1
let g:terraform_completion_keys = 0
let g:terraform_registry_module_completion = 1

" C-k to execute snippet
" imap <C-s> <Plug>(neosnippet_expand)
" imap <C-k> <Plug>(neosnippet_expand_or_jump)
" smap <C-k> <Plug>(neosnippet_expand_or_jump)
" xmap <C-k> <Plug>(neosnippet_expand_target)

"" Expand the completed snippet trigger by <CR>.
"imap <expr><CR>
"      \ (pumvisible() && neosnippet#expandable()) ?
"      \ "\<Plug>(neosnippet_expand)" : "\<CR>"

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
let g:vimwiki_folding='expr' "this allows the folding to work for markdown
let g:vimwiki_global_ext = 0
let g:vimwiki_hl_headers = 1
let g:vimwiki_list = [{
  \ 'auto_export': 1,
  \ 'auto_header' : 1,
  \ 'automatic_nested_syntaxes': 1,
  \ 'autotags': 1,
  \ 'custom_wiki2html': '~/vimwiki/scripts/convert.py',
  \ 'ext': '.md',
  \ 'links_space_char' : '_',
  \ 'list_margin': 0,
  \ 'path': '~/vimwiki',
  \ 'path_html': '~/vimwiki/html',
  \ 'syntax': 'markdown',
  \ 'template_default': 'GitHub',
  \ 'template_ext': 'html5',
  \ 'template_path': '~/vimwiki/templates/',
  \ 'nested_syntaxes': {
    \ 'bash': 'sh',
    \ 'elixir': 'elixir',
    \ 'java': 'java',
    \ 'javascript': 'javascript',
    \ 'js': 'javascript',
    \ 'json': 'javascript',
    \ 'python': 'python',
    \ 'ruby': 'ruby',
    \ 'yaml': 'yaml'
  \ },
\ }]

"  \ 'path_html': '~/vimwiki/html/',

autocmd FileType vimwiki set spell spelllang=en_us complete+=kspell

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

function! GoogleSearch()
  let searchterm = expand('<cword>')
  if &filetype != ""
    let searchterm .= "+" . &filetype
  endif
  silent! exec "silent! !open \"http://google.com/search?q=" . searchterm . "\" &"
endfunction

nmap <Leader>gs :call GoogleSearch()<CR>

" Copilot config
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
