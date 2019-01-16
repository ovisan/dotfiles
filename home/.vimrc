filetype plugin on
set nocompatible
filetype off
set bg=dark
set t_Co=256
set updatetime=100
" disable stupid beeping
set vb t_vb=

" map leader key
let mapleader = '\'

autocmd BufRead,BufNewFile *.c,*.h set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufRead,BufNewFile *.go set tabstop=2 shiftwidth=2 expandtab

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" difference between insert and normal mode with no delay
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set timeoutlen=1000 ttimeoutlen=0

" adding a line from normal mode
nmap <S-Enter> O<Esc>

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
    "Plugin 'tpope/vim-vividchalk'
    Plugin 'ovisan/vividchalk-custom'
    "temporary
    Plugin 'vim-ruby/vim-ruby'

    "other
    Plugin 'mileszs/ack.vim'
    Plugin 'ajh17/VimCompletesMe'
    Plugin 'ludovicchabant/vim-gutentags'
    Plugin 'ntpeters/vim-better-whitespace'
    Plugin 'ervandew/supertab'
    Plugin 'justmao945/vim-clang'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'fatih/vim-go'
    Plugin 'scrooloose/nerdtree'
    Plugin 'nsf/gocode', {'rtp': 'vim/'}
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-speeddating' "Enhances the default vim increment
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-commentary'
    Plugin 'tpope/vim-jdaddy'
    Plugin 'gabrielelana/vim-markdown'
    Plugin 'scrooloose/syntastic'
    Plugin 'mbbill/undotree'
    Plugin 'kien/ctrlp.vim'
    Plugin 'bling/vim-airline'
    Plugin 'godlygeek/tabular.git' "Alignment plugin
    Plugin 'Raimondi/delimitMate'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'xolox/vim-notes'
    Plugin 'xolox/vim-misc'
    Plugin 'haya14busa/incsearch.vim' "Better incsearch
    Plugin 'suan/vim-instant-markdown'
    Plugin 'chase/vim-ansible-yaml'


    " github mirrors for vim scripts
    Plugin 'vim-scripts/netrw.vim' "Remote editing
    Plugin 'vim-scripts/vimcommander'
    Plugin 'vim-scripts/c.vim'
    Plugin 'vim-scripts/ScrollColors'
    Plugin 'vim-scripts/OmniCppComplete'
    Plugin 'vim-scripts/CRefVim'
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

"fix remapping
cmap Q q
cmap W w

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
" disable global autoindent


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
set clipboard=unnamedplus

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

"Go to first line when git commit
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" Auto source vimrc
autocmd! bufwritepost .vimrc source %

" ignore list
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"A mapping to make a backup of the current file.
function! WriteBackup()
  let l:fname = expand('%:p') . '__' . strftime('%Y_%m_%d_%H.%M.%S')
  silent execute 'write' l:fname
  echomsg 'Wrote' l:fname
endfunction
nnoremap <Leader>ba :<C-U>call WriteBackup()<CR>

"folding settings
set foldcolumn=0
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" Mapping keys

" diable arrow keys for vim motion learning
"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>

" Enable repeat in visual mode
vnoremap . :norm.<CR>

" open Godoc under cursor
nnoremap <Leader>h :GoDoc <C-r><C-w> <CR>

" Mapping to rename word under cursor
if &ft=='go'
    nnoremap <Leader>r :silent !gofmt -r '<C-r><C-w> -> ' -w % <Left><Left><Left><Left><Left><Left>
else
    nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
endif

let NERDTreeShowBookmarks=1
let g:NERDTreeNodeDelimiter = "\u00a0"
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F4> :TlistToggle <CR>
nnoremap <F5> :UndotreeToggle<CR>

" Go mapping for test and code files
autocmd BufNewFile,BufRead *_test.go map <buffer> <F8> :!go test -file %<CR>
nnoremap <F11> :cal VimCommanderToggle()<CR>
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

" CTRLP Funky
let g:ctrlp_extensions = ['funky']
nnoremap <Leader>fu :CtrlPFunky<CR>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<CR>

" Ctrlp settings {
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_by_filename = 0
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11'
let g:clang_auto = 0
let g:clang_c_completeopt = 'longest,menuone'
let g:clang_cpp_completeopt = 'longest,menuone'
let g:clang_diagsopt = ''

"delimitMate settings
let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space=1

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
let g:SuperTabDefaultCompletionType = "<c-x><c-n>"
"}

" Private pastes in pastie {
let pastie_private=1
"}

" Syntastic options {
let g:syntastic_always_populate_loc_list=1
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
" Needed for vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }
"}

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
"}
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
    autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END " }

" vim-easy-align {
" For visual mode (e.g. vip<Enter>)
vmap <Enter>   <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" For normal mode, with Vim movement (e.g. <Leader>aip)
nmap <Leader>ga <Plug>(EasyAlign)

" Repeat alignment in visual mode with . key
vmap . <Plug>(EasyAlignRepeat)
" }
