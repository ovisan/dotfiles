set nocompatible
filetype off
set bg=dark
set t_Co=256
" disable stupid beeping
set vb t_vb=
set expandtab
set tabstop=2
set shiftwidth=2
set nopaste

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
    Plugin 'vim-ruby/vim-ruby'
    Plugin 'ntpeters/vim-better-whitespace'
    Plugin 'ervandew/supertab'
    Plugin 'Shougo/neocomplcache.vim'
    Plugin 'fatih/vim-go'
    Plugin 'scrooloose/nerdtree'
    Plugin 'SirVer/ultisnips'
    Plugin 'Lokaltog/vim-easymotion'
    Plugin 'nsf/gocode', {'rtp': 'vim/'}
    Plugin 'majutsushi/tagbar'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-speeddating'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-commentary'
    Plugin 'simmel/vim-pastie'
    Plugin 'scrooloose/syntastic'
    Plugin 'mattn/webapi-vim'
    Plugin 'Rykka/easydigraph.vim'
    Plugin 'sjl/gundo.vim'
    Plugin 'tomtom/vimtlib'
    Plugin 'kien/ctrlp.vim'
    Plugin 'tacahiroy/ctrlp-funky'
    Plugin 'ivalkeen/vim-ctrlp-tjump'
    Plugin 'sgur/ctrlp-extensions.vim'
    Plugin 'bling/vim-airline'
    Plugin 'wesQ3/vim-windowswap'
    Plugin 'Keithbsmiley/investigate.vim'
    Plugin 'junegunn/vim-easy-align'
    Plugin 'gavinbeatty/dragvisuals.vim'
    Plugin 'godlygeek/tabular.git'
    Plugin 'Raimondi/delimitMate'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'Shougo/unite.vim'
    Plugin 'Shougo/vimproc.vim'
    Plugin 'ggreer/the_silver_searcher'
    Plugin 'benmills/vimux'
    Plugin 'tpope/vim-jdaddy'
    Plugin 'Yggdroot/indentLine'
    Plugin 'tpope/vim-vinegar'
    Plugin 'mattn/emmet-vim'
    Plugin 'klen/python-mode'
    Plugin 'ekalinin/Dockerfile.vim'

    " github mirrors for vim scripts
    Plugin 'vim-scripts/linediff.vim'
    Plugin 'vim-scripts/Align'
    Plugin 'vim-scripts/Clam'
    Plugin 'vim-scripts/dbext.vim'
    Plugin 'vim-scripts/EasyGrep'
    Plugin 'vim-scripts/netrw.vim'
    Plugin 'vim-scripts/camelcasemotion'
    Plugin 'vim-scripts/vimcommander'
    Plugin 'vim-scripts/L9'
    Plugin 'vim-scripts/sessionman.vim'
    Plugin 'vim-scripts/restart.vim'
    Plugin 'vim-scripts/matchit.zip'
    Plugin 'vim-scripts/sudo.vim'
    Plugin 'vim-scripts/c.vim'
    Plugin 'vim-scripts/SQLComplete.vim'
    Plugin 'vim-scripts/python.vim'
    Plugin 'vim-scripts/pythoncomplete'
    Plugin 'vim-scripts/TaskList.vim'
    Plugin 'vim-scripts/VisIncr'
    Plugin 'vim-scripts/ScrollColors'
    Plugin 'vim-scripts/OmniCppComplete'
    Plugin 'vim-scripts/CRefVim'
    Plugin 'vim-scripts/notes.vim'
    Plugin 'vim-scripts/vim-misc'
    Plugin 'vim-scripts/quilt'

    "color schemes
    Plugin 'cschlueter/vim-wombat'
    Plugin 'tomasr/molokai'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'tpope/vim-vividchalk'

    if iCanHazVundle == 0
        echo "Installing Plugin, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif
" Setting up Vundle - the vim plugin bundler end

" Syntax highlight for JSON
autocmd BufNewFile,BufRead *.json set ft=javascript

" Variable for vundle to handle git
let $GIT_SSL_NO_VERIFY = 'true'

" let Vundle manage Vundle
" required!
let g:neocomplete#sources#omni#functions = {'go': 'go#complete#Complete'}
" let g:neocomplete#sources#omni#functions = {'c': 'c#complete#Complete'}
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" autocmd FileType c setlocal omnifunc=ccomplete#CompleteTags
autocmd FileType go setlocal omnifunc=gocomplete#CompleteTags
" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
" let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'


""""""""""""""""""""""""""""""""""""
" Set the PATH variable internally to point to gocode binary, and that is
" installed in the $GOPATH/bin by go get. This way gocode will be sure to run
" from go installed anywhere in the system.
let $PATH .= ":".$GOPATH."/bin"
""""""""""""""""""""""""""""""""""""

function! IndentationHeatMap()
    set conceallevel=1
    for i in range(1,9)
        let indentation = repeat(" ", &sts * i)
        exe 'syntax match NonText "^' . indentation . '" conceal cchar=' . i
    endfor
endfunction


" General Vim
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 10
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

"favorite colorscheme
colorscheme vividchalk

"setting cursor properties
"highlight Cursor guifg=white guibg=red
"highlight iCursor guifg=white guibg=steelblue
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=a:blinkon0

"GUI browser opens in current directory
set browsedir=buffer
set wildmenu
set hlsearch
set incsearch
set ignorecase smartcase
" IMPORTANT for ftdetect
filetype indent on
filetype plugin on
syntax on
set encoding=utf-8
set number
set linespace=0
set backupdir=~/tmp
set mouse=a
set autoread
set completeopt-=preview
set completeopt+=longest
set wildmode=longest,list

"speed up matching
set matchtime=3
"selection colors for dark background
set background=dark

" Use system's clipboard
set clipboard^=unnamed

" Edit anyway if there is a swap file
autocmd SwapExists * :let v:swapchoice='e'

autocmd FileType c autocmd BufWritePre <buffer> !astyle %

autocmd BufRead,BufNewFile *.go syntax on
autocmd BufRead,BufNewFile *.go set ai
" autocmd FileType go runtime! autoload/gocomplete.vim
au BufRead,BufNewFile *.go set filetype=go
" set the autocomplete when loading a go file
autocmd FileType go set omnifunc=gocomplete#Complete

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

" " Auto closing braces, quotes..
" inoremap {      {}<Left>
" inoremap {<CR>  {<CR>}<Esc>O
" inoremap {{     {
" inoremap {}     {}

" inoremap (      ()<Left>
" inoremap (<CR>  (<CR>)<Esc>O
" inoremap ((     (
" inoremap ()     ()

" inoremap [      []<Left>
" inoremap [<CR>  [<CR>]<Esc>O
" inoremap [[     [
" inoremap []     []

" inoremap "      ""<Left>
" inoremap "<CR>  "<CR>"<Esc>O
" inoremap ""     "

" inoremap '      ''<Left>
" inoremap '<CR>  '<CR>'<Esc>O
" inoremap ''     '

" inoremap `      ``<Left>
" inoremap `<CR>  `<CR>`<Esc>O
" inoremap ``     `"

" open Godoc under cursor
nnoremap <Leader>h :GoDoc <C-r><C-w> <CR>

" Mapping to rename word under cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Maping to rename in golang source file (!!IMPORTANT!!)
nnoremap <Leader>r :silent !gofmt -r '<C-r><C-w> -> ' -w % <Left><Left><Left><Left><Left><Left>

let NERDTreeShowBookmarks=1
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F4> :TagbarToggle <CR>
nnoremap <F5> :GundoToggle <CR>

" Go mapping for test and code files
autocmd BufNewFile,BufRead *_test.go map <buffer> <F8> :!go test -file %<CR>
nnoremap <F11> :cal VimCommanderToggle()<CR>
nnoremap <Tab> <C-W><C-W>

" Scripts config

" Notes

let g:notes_directories = ['~/Documents/Notes', '~/Dropbox/Shared Notes']



"Taglist golang definition {
let s:tlist_def_go_settings = 'go;s:struct;f:func;v:var'
"}

" CTRLP Funky
let g:ctrlp_extensions = ['funky']
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" Ctrlp settings {
let g:ctrlp_map = '<c-o>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr|svn)($|[/\\])|__init__\.py'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_by_filename = 0
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

" Neocomplcache config {
	" Launches neocomplcache automatically on vim startup.
	let g:neocomplcache_enable_at_startup = 1
	" Use smartcase.
	let g:neocomplcache_enable_smart_case = 1
	" Use camel case completion.
	let g:neocomplcache_enable_camel_case_completion = 0
	" Use underscore completion.
	let g:neocomplcache_enable_underbar_completion = 2
	" Sets minimum char length of syntax keyword.
	let g:neocomplcache_min_syntax_length = 3
	" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
	let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
	" AutoComplPop like behavior.
	let g:neocomplcache_enable_auto_select = 1
"}

"UltiSnips split vertical and snippets directory {
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories= ['bundle/ultisnips/UltiSnips']
"}

" Colors config for EasyMotion {
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
"}

" Taglist {
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
"}

" Taglist {
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
"}

" Conque config {
let g:ConqueTerm_ReadUnfocused = 1
"}

" Supertab {
let g:SuperTabDefaultCompletionType = "context"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
"}

" Private pastes in pastie {
let pastie_private=1
"}

" Syntastic options {
let g:syntastic_always_populate_loc_list=1
"}

" configuration airline bar {
let g:airline#extensions#syntastic#enable=1
let g:airline#extensions#branch#enable=1
let g:airline#extensions#modified#enable=1
let g:airline#extensions#paste#enable=1
let g:airline#extensions#whitespace#enable=1
"}

" Minibuf {
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 0
"}

" Tagbar Go {
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
"}

" vim-easy-align {
" For visual mode (e.g. vip<Enter>)
vmap <Enter>   <Plug>(EasyAlign)

" For normal mode, with Vim movement (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" Repeat alignment in visual mode with . key
vmap . <Plug>(EasyAlignRepeat)
" }
