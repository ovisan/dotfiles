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
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" ignore list
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tmp,tags,*.hpi

" set cursor as line when insert and block in normal mode
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

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
" count word under cursor
map <Leader>c *<C-O>:%s///gn<CR>
" rename word under cursor from current line to EOF
nnoremap <Leader>s :.,$s/\<<C-r><C-w>\>/


" map leader key
let mapleader = '\'

" closing matching characters and skipping over the closing characters
" inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
" inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
" inoremap ( ()<Left>
" inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
" inoremap [ []<Left>
" inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
" inoremap { {}<Left>
" inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

" automatic paste toggle function
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
    set paste
      return ""
      endfunction


"Setting the highlight colors
hi Search ctermfg=Yellow ctermbg=Red cterm=bold,underline

" Try to load minpac.
packadd minpac

function! InstallPackages()
  call minpac#add('nanotech/jellybeans.vim', {'do': 'colorscheme jellybeans'})
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-speeddating') "Enhances the default vim increment
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('suan/vim-instant-markdown')
  call minpac#add('dense-analysis/ale')
  call minpac#add('mbbill/undotree')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('junegunn/vim-easy-align') "Alignment plugin
  call minpac#add('junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' })
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('racer-rust/vim-racer')
  call minpac#add('lifepillar/vim-mucomplete')
  call minpac#add('pearofducks/ansible-vim')
  call minpac#add('rust-lang/rust.vim')
  call minpac#add('fatih/vim-go', { 'do': ':GoInstallBinaries' })
  call minpac#add('davidhalter/jedi-vim')
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
endfunction

let minpac_readme=expand('~/.vim/pack/minpac/opt/minpac/README.md')
if !filereadable(minpac_readme)
  " set packpath for all OS
  set packpath^=~/.vim

  silent !mkdir -p ~/.vim/pack/minpack/opt
  silent !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac

  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call InstallPackages()
  call minpac#update()
  packloadall
  silent! helptags ALL

else
  call minpac#init()
  call InstallPackages()
  silent! helptags ALL

endif

" Variable for vundle to handle git
let $GIT_SSL_NO_VERIFY = 'true'


""""""""""""""""""""""""""""""""""""
" Set the PATH variable internally to point to gocode binary, and that is
" installed in the $GOPATH/bin by go get. This way gocode will be sure to run
" from go installed anywhere in the system.
let $PATH .= ":".$GOPATH."/bin"

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

" set colorscheme
colorscheme jellybeans

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
let g:racer_cmd = "/Users/ovidiuvisan/.cargo/bin/racer"
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

" ale
let g:liteline#extensions#ale#enabled = 1

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'never'

let g:ale_linters = {'python': ['flake8'], 'rust': ['rls']}
let g:ale_python_flake8_options       = '--ignore=E501,E128,E221,E722,E201,E202,E251,E225,E226,W391,W605,E126,E123,E241,E305,E302'

let g:ale_rust_rls_executable = 'rust-analyzer'
let g:ale_fixers = {'rust': ['rustfmt'], 'python': ['yapf', 'autopep8']}
let g:ale_rust_cargo_use_check = 1

let b:ale_fix_on_save                 = 1

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'


function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   "%dW %dE",
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

" lightline
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'linter' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'linter': 'LinterStatus'
      \ }
      \ }

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
	    \ 'default': ['path', 'omni', 'keyn', 'dict', 'uspl'],
	    \ 'vim':     ['path', 'cmd', 'keyn'],
	    \ 'rust':    ['omni', 'keyn'],
	    \ 'go':      ['omni']
	    \ }

" jedi
let g:jedi#popup_on_dot           = 1  " It may be 1 as well
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#popup_select_first     = 0
let g:jedi#show_call_signatures   = "1"

