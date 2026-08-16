" .vimrc — stock Vim over SSH first; plugins install on startup when online.
if &compatible
  set nocompatible
endif

if has('multi_byte')
  set encoding=utf-8
  set fileencoding=utf-8
endif

let mapleader = ' '
let maplocalleader = ' '

" ---------------------------------------------------------------------------
" Directories (no shell mkdir on every start)
" ---------------------------------------------------------------------------
let s:vimdir = expand('~/.vim')
let s:vim_writable = 1
for s:subdir in ['history', 'swap', 'backup']
  let s:path = s:vimdir . '/' . s:subdir
  if !isdirectory(s:path)
    try
      call mkdir(s:path, 'p', 0700)
    catch
      let s:vim_writable = 0
    endtry
  endif
endfor
if s:vim_writable
  set undofile
  let &undodir = s:vimdir . '/history//'
  let &directory = s:vimdir . '/swap//'
  let &backupdir = s:vimdir . '/backup//'
else
  set noundofile
  set noswapfile
endif
set nobackup
set nowritebackup

" ---------------------------------------------------------------------------
" Core options
" ---------------------------------------------------------------------------
set hidden
set autoread
set backspace=indent,eol,start
set ruler
set number
set cursorline
set showcmd
set noshowmode
set laststatus=2
set showtabline=1
set cmdheight=1
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tmp,tags,*.o,*.pyc,__pycache__
set path+=**
set hlsearch
set incsearch
set ignorecase
set smartcase
set nowrap
set linebreak
set scrolloff=3
set sidescrolloff=5
set display+=lastline
set splitbelow
set splitright
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab
set smarttab
set autoindent
set smartindent
set iskeyword+=-
set conceallevel=0
set pumheight=10
set nomore
set report=9999
silent! set shortmess+=aoOTIFcw
silent! set belloff=all
set visualbell
set t_vb=
set history=1000
set tabpagemax=50
set nrformats-=octal
set complete-=i
set complete+=kspell
set spellcapcheck=
set updatetime=400
set timeout
set timeoutlen=800
set ttimeout
set ttimeoutlen=50
set lazyredraw
set synmaxcol=300
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set foldcolumn=0
set matchtime=3
set background=dark

if exists('+ttyfast')
  set ttyfast
endif

if exists('+signcolumn')
  set signcolumn=yes
endif

if exists('+inccommand')
  set inccommand=split
endif

" formatoptions is reset by filetypes; keep the override sticky
augroup vimrc_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" SSH: do not steal terminal selection or talk to X11 (unnamedplus hangs).
if $SSH_CONNECTION !=# ''
  set mouse=
  if exists('+clipboard')
    set clipboard=
  endif
elseif has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  endif
  if exists('+clipboard')
    if has('unnamedplus')
      set clipboard=unnamedplus
    elseif has('clipboard')
      set clipboard=unnamed
    endif
  endif
endif

if &term =~# '256color'
  set t_ut=
endif

if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  set termguicolors
endif

" t_ut= and the colorscheme paint the terminal; put it back on exit.
let s:term_reset = "\<Esc>[0m\<Esc>[39m\<Esc>[49m\<Esc>[?25h"
      \ . "\<Esc>]104\x07\<Esc>]110\x07\<Esc>]111\x07"
if &t_te !~# "\<Esc>\[0m"
  let &t_te .= s:term_reset
endif

function! s:RestoreTerminal() abort
  if &term ==# '' || &term ==# 'dumb'
    return
  endif
  if exists('*echoraw')
    call echoraw(s:term_reset)
  else
    silent! execute 'set t_te=' . &t_te
  endif
endfunction

augroup vimrc_term_restore
  autocmd!
  autocmd VimLeave * call s:RestoreTerminal()
augroup END

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif

augroup vimrc_gotmpl
  autocmd!
  autocmd BufNewFile,BufRead *.gotmpl setfiletype yaml
augroup END

augroup vimrc_whitespace
  autocmd!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd BufWinLeave * silent! call clearmatches()
augroup END

" Skip syntax/folds on huge files so vim stays usable on remote logs.
augroup vimrc_largefile
  autocmd!
  autocmd BufReadPre * call s:LargeFile()
augroup END

function! s:LargeFile() abort
  if getfsize(expand('<afile>')) > 2 * 1024 * 1024
    setlocal noswapfile noundofile nowrap nofoldenable
    syntax off
  endif
endfunction

" Prefer ripgrep when present (no plugin required).
if executable('rg')
  let &grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git'"
  set grepformat=%f:%l:%c:%m
endif

" ---------------------------------------------------------------------------
" Keymaps (no plugins)
" ---------------------------------------------------------------------------
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <Leader>n :setlocal number!<CR>
nnoremap <silent> <Leader>w :%s/\s\+$//e<CR>
nnoremap <Leader>s :.,$s/\<<C-r><C-w>\>/
nnoremap <Leader>c *<C-O>:%s///gn<CR>
nnoremap <silent> <Leader>r :source $MYVIMRC<CR>
nnoremap <silent> <Leader>v :edit $MYVIMRC<CR>

nnoremap <Leader>d "_d
xnoremap <Leader>d "_d

nnoremap <silent> gn :bnext<CR>
nnoremap <silent> gp :bprevious<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-Left> <C-w>h
nnoremap <C-Right> <C-w>l

vnoremap < <gv
vnoremap > >gv
vnoremap . :normal .<CR>

xnoremap @ :<C-u>call <SID>ExecuteMacroOverVisualRange()<CR>

function! s:ExecuteMacroOverVisualRange() abort
  echo '@' . getcmdline()
  execute ":'<,'>normal @" . nr2char(getchar())
endfunction

if has('terminal')
  tnoremap <Esc> <C-\><C-n>
  nnoremap <C-t> :botright 12split +terminal<CR>
endif

" ---------------------------------------------------------------------------
" Quickfix / location / jumplist
" ---------------------------------------------------------------------------
function! s:GetBufferList() abort
  redir => l:buflist
  silent! ls!
  redir END
  return l:buflist
endfunction

function! s:ToggleList(bufname, pfx) abort
  let l:buflist = s:GetBufferList()
  for l:bufnum in map(filter(split(l:buflist, '\n'), 'v:val =~ a:bufname'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(l:bufnum) != -1
      execute a:pfx . 'close'
      return
    endif
  endfor
  if a:pfx ==# 'l' && empty(getloclist(0))
    echohl ErrorMsg
    echo 'Location List is Empty.'
    echohl None
    return
  endif
  let l:winnr = winnr()
  execute a:pfx . 'open'
  if winnr() != l:winnr
    wincmd p
  endif
endfunction

function! s:GotoJump() abort
  jumps
  let l:j = input('Please select your jump: ')
  if l:j ==# ''
    return
  endif
  if l:j =~# '\v^\+'
    let l:j = substitute(l:j, '\v^\+', '', '')
    execute 'normal ' . l:j . "\<C-i>"
  else
    execute 'normal ' . l:j . "\<C-o>"
  endif
endfunction

nnoremap <silent> <Leader>j :call <SID>GotoJump()<CR>
nnoremap <silent> <Leader>l :call <SID>ToggleList('Location List', 'l')<CR>
nnoremap <silent> <Leader>q :call <SID>ToggleList('Quickfix List', 'c')<CR>

function! s:FindFiles(filename) abort
  let l:files = split(globpath('.', '**/' . a:filename, 1), "\n")
  call filter(l:files, 'v:val !=# ""')
  if empty(l:files)
    echo 'No files matching ' . a:filename
    return
  endif
  let l:qflist = []
  for l:f in l:files
    call add(l:qflist, {'filename': l:f, 'lnum': 1, 'text': l:f})
  endfor
  call setqflist(l:qflist)
  copen
endfunction
command! -nargs=1 FindFile call s:FindFiles(<q-args>)

" ---------------------------------------------------------------------------
" Plugins — download only when something is missing AND the network is up
" ---------------------------------------------------------------------------
let s:plug = expand('~/.vim/autoload/plug.vim')

function! s:HasDownloader() abort
  return executable('git') || executable('curl') || executable('wget')
endfunction

function! s:WarnInstallTools(...) abort
  if exists('s:warned_tools')
    return
  endif
  let s:warned_tools = 1
  let l:msg = [
        \ 'vimrc: cannot download plugins.',
        \ 'git, curl and wget are not installed.',
        \ '',
        \ 'Install one of them, then restart Vim:',
        \ '  Debian/Ubuntu:  apt-get update && apt-get install -y git curl ca-certificates',
        \ '  RHEL/Fedora:    dnf install -y git curl ca-certificates',
        \ '  Alpine:         apk add git curl ca-certificates',
        \ ]
  silent! call writefile(l:msg, '/dev/stderr')
  silent! cquit!
endfunction

function! s:HasInternet() abort
  if exists('s:online')
    return s:online
  endif
  if $VIMRC_OFFLINE !=# ''
    let s:online = 0
    return 0
  endif
  if !s:HasDownloader()
    let s:online = 0
    return 0
  endif
  let s:online = 0
  if executable('curl')
    call system('curl -fsS --connect-timeout 2 --max-time 3 -o /dev/null https://github.com')
    let s:online = v:shell_error == 0
  elseif executable('wget')
    call system('wget -q --timeout=3 --tries=1 -O /dev/null https://github.com')
    let s:online = v:shell_error == 0
  elseif executable('git')
    " git can fetch plugins; treat as online and let clone fail if not
    let s:online = 1
  endif
  return s:online
endfunction

function! s:EnsurePlug() abort
  if filereadable(s:plug)
    return 1
  endif
  if !s:HasDownloader()
    call s:WarnInstallTools()
    return 0
  endif
  if !s:HasInternet()
    echom 'vimrc: offline, skipping vim-plug download'
    return 0
  endif
  if !isdirectory(s:vimdir . '/autoload')
    call mkdir(s:vimdir . '/autoload', 'p', 0700)
  endif
  let l:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  call s:InstallProgress('vimrc: installing vim-plug')
  if executable('curl')
    call system('curl -fLo ' . shellescape(s:plug) . ' --connect-timeout 5 --max-time 30 ' . shellescape(l:url))
  elseif executable('wget')
    call system('wget -q --timeout=30 --tries=1 -O ' . shellescape(s:plug) . ' ' . shellescape(l:url))
  elseif executable('git')
    let l:tmp = tempname()
    call system('git clone --depth 1 --quiet https://github.com/junegunn/vim-plug ' . shellescape(l:tmp))
    if filereadable(l:tmp . '/plug.vim')
      call system('cp ' . shellescape(l:tmp . '/plug.vim') . ' ' . shellescape(s:plug))
    endif
    call system('rm -rf ' . shellescape(l:tmp))
  endif
  if !filereadable(s:plug)
    echom 'vimrc: failed to download vim-plug'
    return 0
  endif
  return 1
endfunction

function! s:PluginsMissing() abort
  if !exists('g:plugs')
    return 1
  endif
  for l:spec in values(g:plugs)
    if !isdirectory(expand(l:spec.dir))
      return 1
    endif
  endfor
  return 0
endfunction

function! s:InstallProgress(msg) abort
  try
    call writefile([a:msg], '/dev/tty')
  catch
    echo a:msg
    redraw
  endtry
endfunction

function! s:ClonePlugin(name, spec) abort
  let l:dir = expand(a:spec.dir)
  if isdirectory(l:dir)
    return 1
  endif
  let l:uri = get(a:spec, 'uri', '')
  if l:uri ==# ''
    return 0
  endif
  let l:uri = substitute(l:uri, '^https://git::@github\.com', 'https://github.com', '')
  if executable('git')
    let $GIT_TERMINAL_PROMPT = 0
    call system('git clone --depth 1 --single-branch --quiet ' . shellescape(l:uri) . ' ' . shellescape(l:dir))
    return v:shell_error == 0 && isdirectory(l:dir)
  endif
  if !executable('curl') || !executable('tar')
    echom 'vimrc: need git or curl+tar to install ' . a:name
    return 0
  endif
  let l:repo = substitute(l:uri, '\.git$', '', '')
  let l:tmp = tempname()
  let l:tgz = l:tmp . '.tgz'
  let l:ok = 0
  for l:ref in ['master', 'main']
    call system('curl -fsSL --connect-timeout 5 --max-time 60 -o ' . shellescape(l:tgz) . ' ' . shellescape(l:repo . '/archive/refs/heads/' . l:ref . '.tar.gz'))
    if v:shell_error != 0
      continue
    endif
    call mkdir(l:dir, 'p', 0700)
    call system('tar -xzf ' . shellescape(l:tgz) . ' -C ' . shellescape(l:dir) . ' --strip-components=1')
    if v:shell_error == 0 && isdirectory(l:dir)
      let l:ok = 1
      break
    endif
    call system('rm -rf ' . shellescape(l:dir))
  endfor
  call delete(l:tgz)
  return l:ok
endfunction

function! s:InstallMissingPlugins() abort
  if exists('s:installing') || !s:PluginsMissing()
    return
  endif
  if !s:HasDownloader()
    call s:WarnInstallTools()
    return
  endif
  if !s:HasInternet()
    echom 'vimrc: offline, skipping plugin install'
    return
  endif
  let s:installing = 1
  let l:home = exists('g:plug_home') ? g:plug_home : (s:vimdir . '/plugged')
  if !isdirectory(l:home)
    call mkdir(l:home, 'p', 0700)
  endif
  let l:todo = []
  for [l:name, l:spec] in items(g:plugs)
    if !isdirectory(expand(l:spec.dir))
      call add(l:todo, l:name)
    endif
  endfor
  let l:total = len(l:todo)
  let l:i = 0
  let l:old_ch = &cmdheight
  let &cmdheight = min([l:total + 2, 16])
  for l:name in l:todo
    let l:i += 1
    call s:InstallProgress(printf('vimrc: installing %s (%d/%d)', l:name, l:i, l:total))
    call s:ClonePlugin(l:name, g:plugs[l:name])
  endfor
  call s:InstallProgress('vimrc: plugin install done')
  let &cmdheight = l:old_ch
  unlet! s:installing
  let s:reloaded_after_install = 1
  execute 'silent! source' fnameescape($MYVIMRC)
  silent! redraw!
endfunction

if s:EnsurePlug()
  try
    silent! call plug#begin(s:vimdir . '/plugged')
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'mbbill/undotree'
    Plug 'itchyny/lightline.vim'
    Plug 'godlygeek/tabular'
    Plug 'justinmk/vim-sneak'
    Plug 'sheerun/vim-polyglot'
    Plug 'preservim/nerdtree'
    Plug 'aklt/plantuml-syntax'
    Plug 'rust-lang/rust.vim'
    if executable('git')
      Plug 'airblade/vim-gitgutter'
    endif

    if executable('fzf')
      Plug 'junegunn/fzf'
      Plug 'junegunn/fzf.vim'
    endif

    " CoC needs node; skip on hosts without it.
    if executable('node')
      Plug 'neoclide/coc.nvim', {'branch': 'release'}
    endif
    silent! call plug#end()
    if !exists('s:reloaded_after_install')
      call s:InstallMissingPlugins()
    endif
  catch
    filetype plugin indent on
    if !exists('g:syntax_on')
      syntax enable
    endif
  endtry
endif

function! s:HasPlug(name) abort
  return exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(expand(g:plugs[a:name].dir))
endfunction

silent! colorscheme koehler

" ---------------------------------------------------------------------------
" File explorer: NERDTree if installed, else built-in netrw
" ---------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeRespectWildIgnore = 1

let g:netrw_altv = 1
let g:netrw_preview = 1
let g:vimrc_auto_preview = 1
let s:preview_bufnr = -1
let s:preview_path = ''
let s:preview_timer = 0

function! s:ToggleExplorer() abort
  if s:HasPlug('nerdtree')
    NERDTreeToggle
  else
    Lexplore
    if winnr('$') > 1 && (&filetype ==# 'netrw')
      execute 'vertical resize 30'
    endif
  endif
endfunction
nnoremap <silent> <Leader>e :call <SID>ToggleExplorer()<CR>

" :q / :quit leave Vim entirely (tree + preview would otherwise stay behind).
cnoreabbrev <expr> q (getcmdtype() ==# ':' && getcmdline() ==# 'q') ? 'qa' : 'q'
cnoreabbrev <expr> q! (getcmdtype() ==# ':' && getcmdline() ==# 'q!') ? 'qa!' : 'q!'
cnoreabbrev <expr> quit (getcmdtype() ==# ':' && getcmdline() ==# 'quit') ? 'qa' : 'quit'

" Finder-style arrows (same as nvim-tree):
"   Right: expand a closed folder only; files are a no-op
"   Left:  collapse an open folder; otherwise jump to parent
function! s:NetrwTreeDepth(line) abort
  return strlen(matchstr(a:line, '^[|[:space:]]*'))
endfunction

function! s:NetrwIsDir(line) abort
  return a:line =~# '/\s*$'
endfunction

function! s:NetrwIsOpenDir(lnum) abort
  let l:line = getline(a:lnum)
  if !s:NetrwIsDir(l:line)
    return 0
  endif
  let l:next = getline(a:lnum + 1)
  return l:next !=# '' && s:NetrwTreeDepth(l:next) > s:NetrwTreeDepth(l:line)
endfunction

function! s:NetrwNodeName(line) abort
  let l:name = substitute(a:line, '^[|[:space:]]*', '', '')
  let l:name = substitute(l:name, '\s*@\s*-->.*$', '', '')
  let l:name = substitute(l:name, '@\s*$', '', '')
  let l:name = substitute(l:name, '/\s*$', '', '')
  return l:name
endfunction

function! s:NetrwPath() abort
  let l:line = getline('.')
  let l:name = s:NetrwNodeName(l:line)
  if l:name ==# '' || l:name ==# '.' || l:name ==# '..'
    return ''
  endif
  let l:parts = [l:name]
  let l:depth = s:NetrwTreeDepth(l:line)
  let l:lnum = line('.') - 1
  while l:lnum >= 1 && l:depth > 0
    let l:pline = getline(l:lnum)
    if s:NetrwIsDir(l:pline) && s:NetrwTreeDepth(l:pline) < l:depth
      call insert(l:parts, s:NetrwNodeName(l:pline))
      let l:depth = s:NetrwTreeDepth(l:pline)
    endif
    let l:lnum -= 1
  endwhile
  let l:root = exists('b:netrw_curdir') && b:netrw_curdir !=# '' ? b:netrw_curdir : getcwd()
  let l:root = substitute(l:root, '/\+$', '', '')
  if !empty(l:parts) && l:parts[0] ==# fnamemodify(l:root, ':t')
    call remove(l:parts, 0)
  endif
  return simplify(l:root . '/' . join(l:parts, '/'))
endfunction

function! s:NetrwDefaultCR() abort
  if exists('b:vimrc_netrw_cr') && b:vimrc_netrw_cr !=# ''
    execute b:vimrc_netrw_cr
  endif
endfunction

function! s:NetrwRight() abort
  let l:line = getline('.')
  let l:name = s:NetrwNodeName(l:line)
  if l:name ==# '.' || l:name ==# '..'
    return
  endif
  if s:NetrwIsDir(l:line) && !s:NetrwIsOpenDir(line('.'))
    call s:NetrwDefaultCR()
  endif
endfunction

function! s:NetrwLeft() abort
  let l:line = getline('.')
  if s:NetrwIsDir(l:line) && s:NetrwIsOpenDir(line('.'))
    call s:NetrwDefaultCR()
    return
  endif
  let l:depth = s:NetrwTreeDepth(l:line)
  if l:depth == 0
    if line('.') > 1
      call cursor(1, 1)
    endif
    return
  endif
  let l:lnum = line('.') - 1
  while l:lnum >= 1
    let l:parent = getline(l:lnum)
    if s:NetrwIsDir(l:parent) && s:NetrwTreeDepth(l:parent) < l:depth
      call cursor(l:lnum, 1)
      return
    endif
    let l:lnum -= 1
  endwhile
endfunction

function! s:IsExplorerWin(winnr) abort
  let l:ft = getwinvar(a:winnr, '&filetype')
  return l:ft ==# 'netrw' || l:ft ==# 'nerdtree'
endfunction

function! s:FileWindow() abort
  for l:w in range(1, winnr('$'))
    if l:w == winnr()
      continue
    endif
    let l:bt = getwinvar(l:w, '&buftype')
    if s:IsExplorerWin(l:w) || l:bt ==# 'quickfix' || l:bt ==# 'help'
      continue
    endif
    return l:w
  endfor
  return 0
endfunction

function! s:TargetIsModified() abort
  let l:w = s:FileWindow()
  if l:w == 0
    return 0
  endif
  return getbufvar(winbufnr(l:w), '&modified')
endfunction

function! s:IsPreviewable(path) abort
  if a:path ==# '' || !filereadable(a:path) || isdirectory(a:path)
    return 0
  endif
  let l:size = getfsize(a:path)
  if l:size < 0 || l:size > 1024 * 1024
    return 0
  endif
  if l:size == 0
    return 1
  endif
  silent! let l:bytes = readfile(a:path, 'b', 32)
  if type(l:bytes) != type([])
    return 0
  endif
  return join(l:bytes, '') !~# '\%x00'
endfunction

function! s:WipePreview() abort
  if s:preview_bufnr > 0 && bufexists(s:preview_bufnr)
    if !getbufvar(s:preview_bufnr, '&modified') && !getbufvar(s:preview_bufnr, '&buflisted')
      execute 'silent! bwipeout' s:preview_bufnr
    endif
  endif
  let s:preview_bufnr = -1
  let s:preview_path = ''
endfunction

function! s:KeepPreview() abort
  if s:preview_bufnr > 0 && bufexists(s:preview_bufnr)
    call setbufvar(s:preview_bufnr, '&bufhidden', 'hide')
    call setbufvar(s:preview_bufnr, '&buflisted', 1)
    call setbufvar(s:preview_bufnr, '&readonly', 0)
    call setbufvar(s:preview_bufnr, '&modifiable', 1)
  endif
  let s:preview_bufnr = -1
endfunction

function! s:OpenInFileWindow(path, preview) abort
  if a:path ==# ''
    return
  endif
  let l:tree = winnr()
  let l:target = s:FileWindow()
  if l:target == 0
    rightbelow vsplit
    let l:target = winnr()
    execute l:tree . 'wincmd w'
  endif
  if a:preview && a:path ==# s:preview_path && winbufnr(l:target) == bufnr(a:path)
    return
  endif
  execute l:target . 'wincmd w'
  if a:preview
    if buflisted(bufnr(a:path))
      execute 'silent keepalt buffer' bufnr(a:path)
    else
      call s:WipePreview()
      execute 'silent keepalt noswapfile view' fnameescape(a:path)
      setlocal bufhidden=wipe nobuflisted
      let s:preview_bufnr = bufnr('%')
      let s:preview_path = a:path
    endif
  else
    execute 'silent keepalt edit' fnameescape(a:path)
    setlocal bufhidden=hide buflisted
    if bufnr('%') == s:preview_bufnr
      let s:preview_bufnr = -1
      let s:preview_path = ''
    endif
  endif
  execute l:tree . 'wincmd w'
endfunction

function! s:CursorPath() abort
  if &filetype ==# 'nerdtree'
    let l:node = s:NERDTreeSelected()
    if type(l:node) == type({}) && !empty(l:node) && !l:node.path.isDirectory
      return l:node.path.str()
    endif
    return ''
  endif
  if &filetype ==# 'netrw'
    return s:NetrwPath()
  endif
  return ''
endfunction

function! s:PreviewUnderCursor() abort
  if !g:vimrc_auto_preview
    return
  endif
  if &filetype !=# 'netrw' && &filetype !=# 'nerdtree'
    return
  endif
  if s:TargetIsModified()
    return
  endif
  let l:path = s:CursorPath()
  if s:IsPreviewable(l:path)
    call s:OpenInFileWindow(l:path, 1)
  endif
endfunction

function! s:PreviewTimerCb(_id) abort
  let s:preview_timer = 0
  call s:PreviewUnderCursor()
endfunction

function! s:SchedulePreview() abort
  if has('timers')
    if s:preview_timer > 0
      call timer_stop(s:preview_timer)
    endif
    let s:preview_timer = timer_start(80, function('s:PreviewTimerCb'))
  else
    call s:PreviewUnderCursor()
  endif
endfunction

function! s:TogglePreview() abort
  let g:vimrc_auto_preview = !g:vimrc_auto_preview
  echo 'File preview ' . (g:vimrc_auto_preview ? 'on' : 'off')
  if g:vimrc_auto_preview
    call s:PreviewUnderCursor()
  endif
endfunction

function! s:NetrwCR() abort
  let l:path = s:NetrwPath()
  if l:path !=# '' && filereadable(l:path) && !isdirectory(l:path)
    call s:KeepPreview()
    call s:OpenInFileWindow(l:path, 0)
    return
  endif
  call s:NetrwDefaultCR()
endfunction

function! s:MapNetrwKeys() abort
  if !exists('b:vimrc_netrw_cr')
    let b:vimrc_netrw_cr = maparg('<CR>', 'n')
  endif
  nnoremap <buffer> <silent> <nowait> <Right> :call <SID>NetrwRight()<CR>
  nnoremap <buffer> <silent> <nowait> <Left>  :call <SID>NetrwLeft()<CR>
  nnoremap <buffer> <silent> <CR> :call <SID>NetrwCR()<CR>
  nnoremap <buffer> <silent> P :call <SID>TogglePreview()<CR>
  autocmd CursorMoved <buffer> call s:SchedulePreview()
endfunction

function! s:NERDTreeSelected() abort
  if !exists('g:NERDTreeFileNode')
    return {}
  endif
  try
    return g:NERDTreeFileNode.GetSelected()
  catch
    return {}
  endtry
endfunction

function! s:NERDTreeRight() abort
  let l:node = s:NERDTreeSelected()
  if type(l:node) != type({}) || empty(l:node)
    return
  endif
  if l:node.path.isDirectory && !l:node.isOpen
    if exists('*nerdtree#ui_glue#invokeKeyMap')
      call nerdtree#ui_glue#invokeKeyMap('o')
    else
      execute 'normal o'
    endif
  endif
endfunction

function! s:NERDTreeLeft() abort
  let l:node = s:NERDTreeSelected()
  if type(l:node) != type({}) || empty(l:node)
    return
  endif
  if l:node.path.isDirectory && l:node.isOpen
    if exists('*nerdtree#ui_glue#invokeKeyMap')
      call nerdtree#ui_glue#invokeKeyMap('o')
    else
      execute 'normal o'
    endif
  else
    if exists('*nerdtree#ui_glue#invokeKeyMap')
      call nerdtree#ui_glue#invokeKeyMap('p')
    else
      execute 'normal p'
    endif
  endif
endfunction

function! s:NERDTreeCR() abort
  let l:node = s:NERDTreeSelected()
  if type(l:node) == type({}) && !empty(l:node) && !l:node.path.isDirectory
    call s:KeepPreview()
    call s:OpenInFileWindow(l:node.path.str(), 0)
    return
  endif
  if exists('*nerdtree#ui_glue#invokeKeyMap')
    call nerdtree#ui_glue#invokeKeyMap('o')
  else
    execute 'normal o'
  endif
endfunction

function! s:MapNERDTreeKeys() abort
  nnoremap <buffer> <silent> <nowait> <Right> :call <SID>NERDTreeRight()<CR>
  nnoremap <buffer> <silent> <nowait> <Left>  :call <SID>NERDTreeLeft()<CR>
  nnoremap <buffer> <silent> <CR> :call <SID>NERDTreeCR()<CR>
  nnoremap <buffer> <silent> P :call <SID>TogglePreview()<CR>
  autocmd CursorMoved <buffer> call s:SchedulePreview()
endfunction

function! s:OpenExplorerOnEnter(...) abort
  if exists('s:stdin') || &diff || exists('s:explorer_opened')
    return
  endif
  let s:explorer_opened = 1
  if argc() > 0 && filereadable(expand(argv(0)))
    let l:dir = fnamemodify(expand(argv(0)), ':p:h')
    if s:HasPlug('nerdtree')
      execute 'silent! NERDTree' fnameescape(l:dir)
      silent! NERDTreeFind
      wincmd p
    else
      execute 'silent! Lexplore' fnameescape(l:dir)
      wincmd p
    endif
  else
    if s:HasPlug('nerdtree')
      silent! NERDTree
    else
      silent! Lexplore
    endif
  endif
  silent! redraw!
endfunction

augroup vimrc_explorer_keys
  autocmd!
  autocmd StdinReadPre * let s:stdin = 1
  autocmd FileType netrw call s:MapNetrwKeys()
  autocmd FileType nerdtree call s:MapNERDTreeKeys()
  autocmd VimEnter * nested call s:ScheduleExplorerOnEnter()
  autocmd InsertEnter * if bufnr('%') == s:preview_bufnr | call s:KeepPreview() | endif
  autocmd BufEnter * if winnr('$') == 1 && s:IsExplorerWin(1) | quit | endif
  autocmd QuitPre * call s:QuitCloseCompanion()
augroup END

function! s:QuitCloseCompanion() abort
  let l:expl = 0
  let l:files = 0
  for l:w in range(1, winnr('$'))
    if s:IsExplorerWin(l:w)
      let l:expl += 1
    else
      let l:files += 1
    endif
  endfor
  if l:expl == 0 || l:files > 1
    return
  endif
  let l:cur = winnr()
  for l:w in range(winnr('$'), 1, -1)
    if l:w != l:cur && !getbufvar(winbufnr(l:w), '&modified')
      execute l:w . 'close!'
    endif
  endfor
endfunction

function! s:ScheduleExplorerOnEnter() abort
  if exists('s:explorer_scheduled')
    return
  endif
  let s:explorer_scheduled = 1
  if has('timers')
    call timer_start(20, function('s:OpenExplorerOnEnter'))
  else
    call s:OpenExplorerOnEnter()
  endif
endfunction

" Start the tree even if VimEnter already fired (e.g. -u / late source).
call s:ScheduleExplorerOnEnter()

" ---------------------------------------------------------------------------
" Light plugins
" ---------------------------------------------------------------------------
if s:HasPlug('undotree')
  nnoremap <silent> <Leader>u :UndotreeToggle<CR>
endif

if s:HasPlug('vim-sneak')
  let g:sneak#s_next = 1
  let g:sneak#label = 1
  map f <Plug>Sneak_f
  map F <Plug>Sneak_F
  map t <Plug>Sneak_t
  map T <Plug>Sneak_T
endif

if s:HasPlug('vim-gitgutter')
  let g:gitgutter_max_signs = 500
  let g:gitgutter_map_keys = 0
endif

function! VimrcGitBranch() abort
  return exists('*FugitiveHead') ? FugitiveHead() : ''
endfunction

if s:HasPlug('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'VimrcGitBranch'
        \ }
        \ }
endif

if s:HasPlug('fzf.vim')
  nnoremap <silent> <Leader>o :Files<CR>
  nnoremap <silent> <Leader>f :Rg<CR>
  let g:fzf_action = {
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit'
        \ }
else
  nnoremap <Leader>o :find<Space>
  nnoremap <Leader>f :grep<Space>
endif

" ---------------------------------------------------------------------------
" CoC — only when the plugin actually loaded (needs node)
" ---------------------------------------------------------------------------
if s:HasPlug('coc.nvim')
  " Do not auto-install language servers on remote hosts.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <leader>rn <Plug>(coc-rename)
  xmap <leader>a <Plug>(coc-codeaction-selected)
  nmap <leader>a <Plug>(coc-codeaction-selected)
  nmap <leader>ac <Plug>(coc-codeaction-cursor)
  nmap <leader>qf <Plug>(coc-fix-current)

  nnoremap <silent> K :call <SID>ShowDocumentation()<CR>
  function! s:ShowDocumentation() abort
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ <SID>CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! s:CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction

  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  highlight CocFloating ctermfg=White ctermbg=Black guifg=White guibg=Black
  highlight CocMenuSel ctermfg=Black ctermbg=LightGreen guifg=Black guibg=LightGreen
endif

augroup vimrc_autosource
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
