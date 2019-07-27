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
set tabstop=8 expandtab shiftwidth=4 softtabstop=4

" ignore list
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tmp,tags,*.hpi

" move between splits
map <C-left> <C-W>h
map <C-right> <C-W>l

" yank to clipboard
vmap '' :w !pbcopy<CR><CR>

" remove whitespace
" nnoremap <silent> <Leader>w :%s/\s\+$//e<CR>

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
    Plugin 'airblade/vim-gitgutter'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-speeddating' "Enhances the default vim increment
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-commentary'
    Plugin 'tpope/vim-jdaddy' " JSON
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
    Plugin 'junegunn/fzf.vim'
    Plugin 'rust-lang/rust.vim'
    Plugin 'racer-rust/vim-racer'
    Plugin 'juliosueiras/vim-terraform-completion'
    Plugin 'lifepillar/vim-mucomplete'
    Plugin 'majutsushi/tagbar'
    Plugin 'stephpy/vim-yaml'

    " github mirrors for vim scripts
    Plugin 'vim-scripts/netrw.vim' "Remote editing
    Plugin 'vim-scripts/vimcommander'


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

"favorite colorscheme
colorscheme vividchalk-custom

"display indent guides (the space is needed after the line to work properly)
set list lcs=tab:\|\

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

" Auto source vimrc
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

" Enable repeat in visual mode
vnoremap . :norm.<CR>


" nerdtree
let NERDTreeShowBookmarks=1
nnoremap <silent> <Leader>u :UndotreeToggle<CR>
noremap <silent> <Leader>z :NERDTreeToggle<CR>

" multiple cursors
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<C-a>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<C-a>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

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

" rust
set hidden
let g:racer_cmd = "/usr/local/bin/racer"
let $RUST_SRC_PATH="/usr/local/share/rust/rust_src"
let g:racer_experimental_completer = 1
let g:raceer_insert_paren = 1

" fzf
nnoremap <C-o> :FZF ~<Cr>
nnoremap <leader>f :Rg<Cr>
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
imap <c-x><c-l> <plug>(fzf-complete-line)

" terraform
let g:terraform_align=1
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'

" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" delimitmate
let g:delimitMate_expand_cr=2
let g:delimitMate_expand_space = 1
let g:delimitMate_autoclose = 1
let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
let g:delimitMate_jump_expansion = 1
let g:delimitMate_expand_inside_quotes = 1

" easymotion
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

" tabular
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
endif

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args='--ignore=E501,E128'

" airline bar
let g:airline#extensions#syntastic#enable  = 1
let g:airline#extensions#branch#enable     = 1
let g:airline#extensions#modified#enable   = 1
let g:airline#extensions#paste#enable      = 1
let g:airline#extensions#whitespace#enable = 1

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

" mucomplete options
set completeopt+=menuone,noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 1
let g:mucomplete#always_use_completeopt = 1
