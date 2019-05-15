filetype plugin on
set nocompatible
filetype off
set bg=dark
set t_Co=256
set updatetime=100
" disable stupid beeping
set vb t_vb=
" disable capitalize spell checking
set spellcapcheck=
" spelling on autocomplete
set complete+=kspell

" tabs and spaces
set tabstop=8 expandtab shiftwidth=4 softtabstop=4

" yank to clipboard
vmap '' :w !pbcopy<CR><CR>

nnoremap <silent> <Leader>w :%s/\s\+$//e<CR>

" map leader key
let mapleader = '\'

" difference between insert and normal mode with no delay
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set timeoutlen=1000 ttimeoutlen=0

"Setting the highlight colors
hi Search ctermfg=Yellow ctermbg=Red cterm=bold,underline

" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    Plugin 'gmarik/vundle'
    "Add your bundles here
    " from github

    "color schemes
    Plugin 'ovisan/vividchalk-custom'

    "other
    Plugin 'scrooloose/nerdtree'
    Plugin 'bronson/vim-trailing-whitespace'
    Plugin 'ajh17/VimCompletesMe'
    Plugin 'ervandew/supertab'
    Plugin 'ludovicchabant/vim-gutentags'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'nsf/gocode', {'rtp': 'vim/'}
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-speeddating' "Enhances the default vim increment
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-commentary'
    Plugin 'tpope/vim-jdaddy' " JSON
    " Plugin 'gabrielelana/vim-markdown'
    Plugin 'suan/vim-instant-markdown'
    Plugin 'scrooloose/syntastic'
    Plugin 'mbbill/undotree'
    Plugin 'bling/vim-airline'
    Plugin 'godlygeek/tabular.git' "Alignment plugin
    Plugin 'Raimondi/delimitMate'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'haya14busa/incsearch.vim' "Better incsearch
    Plugin 'pearofducks/ansible-vim'
    Plugin 'hashivim/vim-terraform'
    Plugin 'Vimjas/vim-python-pep8-indent'
    Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plugin 'junegunn/fzf.vim' ", {'rtp': '~/.fzf'}
    Plugin 'rust-lang/rust.vim'
    Plugin 'racer-rust/vim-racer'


    " github mirrors for vim scripts
    Plugin 'vim-scripts/netrw.vim' "Remote editing
    Plugin 'vim-scripts/vimcommander'
    Plugin 'vim-scripts/ScrollColors'
    Plugin 'vim-scripts/taglist.vim'


    if iCanHazVundle == 0
        echo "Installing Plugin, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

" Variable for vundle to handle git
let $GIT_SSL_NO_VERIFY = 'true'

" let Vundle manage Vundle
" required!

""""""""""""""""""""""""""""""""""""
" Set the PATH variable internally to point to gocode binary, and that is
" installed in the $GOPATH/bin by go get. This way gocode will be sure to run
" from go installed anywhere in the system.
let $PATH .= ":".$GOPATH."/bin"

" allows incsearch highlighting for range commands
cnoremap /c <CR>:t''<CR>
cnoremap /C <CR>:T''<CR>
cnoremap /m <CR>:m''<CR>
cnoremap /M <CR>:M''<CR>
cnoremap /d <CR>:d<CR>``

" General Vim
if has("gui_running")
  if has("gui_gtk2")
    set guifont=DejaVu\ \Sans\ Mono\ 10
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

"favorite colorscheme
colorscheme vividchalk-custom

"display indent guides (the space is needed after the line to work properly)
set list lcs=tab:\|\

"setting cursor properties
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=a:blinkon0

"GUI browser opens in current directory
set browsedir=buffer

set wildmenu
set hlsearch
set incsearch
set ignorecase smartcase

set autoindent
set smartindent

syntax on
set encoding=utf-8
set number
set linespace=0
silent !mkdir ~/tmp > /dev/null 2>&1
set backupdir=~/tmp
set autoread
set completeopt-=preview
set completeopt+=longest
set wildmode=longest,list

"speed up matching
set matchtime=3
"selection colors for dark background
set background=dark

" Use system's clipboard
set clipboard=unnamed

" Edit anyway if there is a swap file
autocmd SwapExists * :let v:swapchoice='e'

" Function to save the cursor position after formatting the c/c++ code
function! ClangFormat()
	let l:winview = winsaveview()
	:%!clang-format
	call winrestview(l:winview)
endfunction


"Automatically changes directory to that of the current file
autocmd BufEnter * silent! lcd %:p:h

"QuickFix and Location list window toggle
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <expr> . !empty(filter(tabpagebuflist(), 'getbufvar(v:val,"&buftype")==# "quickfix"')) > 0  ? "\:cnext<CR>" : '.'
nnoremap <expr> , !empty(filter(tabpagebuflist(), 'getbufvar(v:val,"&buftype")==# "quickfix"')) > 0 ?  "\:cprevious<CR>" : ','
set wildignore+=tags,*.tmp,test.c,*.hpi

" Auto source vimrc
autocmd! bufwritepost .vimrc source %

" ignore list
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tmp

"folding settings
set foldcolumn=0
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" Mapping keys

" Enable repeat in visual mode
vnoremap . :norm.<CR>

" open Godoc under cursor
nnoremap <Leader>h :GoDoc <C-r><C-w> <CR>

" Mapping to rename word under cursor in go
if &ft=='go'
    nnoremap <Leader>r :silent !gofmt -r '<C-r><C-w> -> ' -w % <Left><Left><Left><Left><Left><Left>
else
    nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
endif


nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F4> :TlistToggle <CR>
nnoremap <F5> :UndotreeToggle<CR>

" nerdtree
let NERDTreeShowBookmarks=1
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F4> :TlistToggle <CR>
nnoremap <silent> <Leader>u :UndotreeToggle<CR>
noremap <silent> <Leader>z :NERDTreeToggle<CR>

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

noremap <silent> <Leader>x :call ToggleVExplorer()<CR>

" rust racer
set hidden
let g:racer_cmd = "/usr/local/bin/racer"
let $RUST_SRC_PATH="/usr/local/share/rust/rust_src"
let g:racer_experimental_completer = 1
let g:raceer_insert_paren = 1

" FZF
nnoremap <C-o> :FZF ~<Cr>
nnoremap <leader>f :Rg<Cr>
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :Files<cr>
imap <c-x><c-l> <plug>(fzf-complete-line)

" Terraform
let g:terraform_align=1
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'

" Go mapping for test and code files
autocmd BufNewFile,BufRead *_test.go map <buffer> <F8> :!go test -file %<CR>
nnoremap <Leader>v :cal VimCommanderToggle()<CR>
nnoremap <Tab> <C-W><C-W>

" Scripts config

" GuttenTags
set statusline+=%{gutentags#statusline()}
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*"]

" Notes

let g:notes_directories = ['~/Documents/Notes', '~/Dropbox/Shared Notes']

" Incsearch settings

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"Taglist golang definition {
" let s:tlist_def_go_settings = 'go;s:struct;f:func;v:var'
" go language
let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;' .
                           \ 'v:variable;f:function'
let Tlist_Inc_Winwidth = 0
"}

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11'
let g:clang_auto = 0
let g:clang_c_completeopt = 'longest,menuone'
let g:clang_cpp_completeopt = 'longest,menuone'
let g:clang_diagsopt = ''

"delimitMate settings
let g:delimitMate_expand_cr=2
let g:delimitMate_expand_space = 1
let g:delimitMate_autoclose = 1
let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
let g:delimitMate_jump_expansion = 1
let g:delimitMate_expand_inside_quotes = 1

" Colors config for EasyMotion {
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
"}

" Taglist {
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
let Tlist_Use_Right_Window   = 1
"}

" Supertab {
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:<c-x><c-o>"]
" Problem with load order (vimrc is evaluated before latex-box setting of omnifunc)
" \ verbose set omnifunc? | " is empty
" added this autocommand to after/ftplugin/tex.vim
" :do FileType solves also the problem
autocmd FileType *
      \ if &omnifunc != '' |
      \ call SuperTabChain(&omnifunc, "<c-p>") |
      \ call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
      \ endif
"}

" Syntastic options {
let g:syntastic_always_populate_loc_list=1
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
let g:syntastic_quiet_messages = { "type": "style" }

" configuration airline bar {
let g:airline#extensions#syntastic#enable=1
let g:airline#extensions#branch#enable=1
let g:airline#extensions#modified#enable=1
let g:airline#extensions#paste#enable=1
let g:airline#extensions#whitespace#enable=1
function! RefreshUI()
  if exists(':AirlineRefresh')
    AirlineRefresh
  else
    " Clear & redraw the screen, then redraw all statuslines.
    redraw!
    redrawstatus!
  endif
endfunction

au BufWritePost .vimrc source $MYVIMRC | :call RefreshUI()
augroup reload_vimrc  {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
    autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END }

" tabularize {
" For normal mode, with Vim movement (e.g. <Leader>aip)
nmap <Leader>ga <Plug>(Tabularize)
" }
