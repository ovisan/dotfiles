filetype plugin on
set nocompatible
filetype off
set backspace=indent,eol,start
set bg=dark
set t_Co=256
set updatetime=100
" disable beeping
set vb t_vb=
" disable capitalize spell checking
set spellcapcheck=
" spelling on autocomplete
set complete+=kspell

" tabs and spaces
set tabstop=2 expandtab shiftwidth=2 softtabstop=2

" ignore list
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tmp,tags,*.hpi

" move between splits
map <C-left> <C-W>h
map <C-right> <C-W>l

" persistent history
silent !mkdir ~/.vim/history > /dev/null 2>&1
set undodir=~/.vim/history
set undofile

" source $MYVIMRC reloads the saved $MYVIMRC
:nmap <Leader>s :source $MYVIMRC

" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
:nmap <Leader>v :e $MYVIMRC

" <Leader> is \ by default, so those commands can be invoked by doing \v and \s
" vim way to strip whitespace
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
    Plugin 'nanotech/jellybeans.vim'

    "other
    Plugin 'airblade/vim-gitgutter'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-speeddating' "Enhances the default vim increment
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-commentary'
    Plugin 'suan/vim-instant-markdown'
    Plugin 'scrooloose/syntastic'
    Plugin 'mbbill/undotree'
    Plugin 'itchyny/lightline.vim'
    Plugin 'junegunn/vim-easy-align' "Alignment plugin
    Plugin 'pearofducks/ansible-vim'
    Plugin 'davidhalter/jedi-vim'
    Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plugin 'junegunn/fzf.vim'
    Plugin 'rust-lang/rust.vim'
    Plugin 'racer-rust/vim-racer'
    Plugin 'lifepillar/vim-mucomplete'
    Plugin 'stephpy/vim-yaml'
    Plugin 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
    Plugin 'craigemery/vim-autotag'

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

"favorite colorscheme
colorscheme jellybeans


"display indent guides (the space is needed after the line to work properly)
set list
set listchars=tab:\|\ 

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
set autoread
set wildmode=longest,list

"speed up matching
set matchtime=3
"selection colors for dark background
set background=dark

" Use system's clipboard
set clipboard=unnamed

" Edit anyway if there is a swap file
autocmd SwapExists * :let v:swapchoice='e'

" Macros
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


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

"Jump list
function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction

nmap <Leader>j :call GotoJump()<CR>

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <expr> . !empty(filter(tabpagebuflist(), 'getbufvar(v:val,"&buftype")==# "quickfix"')) > 0  ? "\:cnext<CR>" : '.'
nnoremap <expr> , !empty(filter(tabpagebuflist(), 'getbufvar(v:val,"&buftype")==# "quickfix"')) > 0 ?  "\:cprevious<CR>" : ','

" auto source vimrc
autocmd! bufwritepost .vimrc source %


" mappings
nnoremap <silent> <Leader>t :TagbarToggle <CR>
nnoremap <silent> <Leader>n :set nonumber!<CR>:set foldcolumn=0<CR>

"folding settings
set foldcolumn=0
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" enable repeat in visual mode
vnoremap . :norm.<CR>


" undotree
nnoremap <silent> <Leader>u :UndotreeToggle<CR>

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

" rust
set hidden
let g:racer_cmd                    = "/usr/local/bin/racer"
let $RUST_SRC_PATH                 = "/usr/local/share/rust/rust_src"
let g:racer_experimental_completer = 1
let g:racer_insert_paren           = 1
augroup Racer
    autocmd!
    autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
augroup END


" fzf
nnoremap <leader>f :Rg<Cr>
nmap <leader>; :Buffers<CR>
nmap <leader><leader>o :ProjectFiles<CR>
nmap <leader>t :Tags<CR>
nmap <leader>o :GFiles<CR>
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

let g:fzf_tags_command = 'ctags -R'


imap <c-x><c-l> <plug>(fzf-complete-line)
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_python_checkers          = ['flake8']
let g:syntastic_python_flake8_args       = '--ignore=E501,E128,E221,E722,E201,E202,E251,E225,E226,W391,W605,E126,E123,E241,E305,E302'

" lightline
set laststatus=2

" mucomplete options
set completeopt-=preview
set completeopt+=menuone,noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay       = 1
let g:mucomplete#always_use_completeopt = 1
let g:mucomplete#can_complete = {
  \ 'rust': {
  \    'omni': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\.\|::\)$' }
  \    },
  \ 'default': {
  \    'omni': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\|\.\)$'}
  \    }
  \  }
let g:mucomplete#chains = {
	    \ 'default' : ['path', 'omni', 'keyn', 'dict', 'uspl'],
	    \ 'vim'     : ['path', 'cmd', 'keyn'],
	    \ 'rust'     : ['omni', 'keyn'],
	    \ 'go'     : ['omni']
	    \ }

" jedi
let g:jedi#popup_on_dot           = 1  " It may be 1 as well
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#popup_select_first     = 0
let g:jedi#show_call_signatures   = "1"

