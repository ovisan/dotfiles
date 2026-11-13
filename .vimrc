" Portable Vim config for laptops and remote servers.
" Single file, no plugins, no network. Works on Vim 7.4+ and Vim 9.
"
"   scp ~/.vimrc user@host:~/.vimrc
"   curl -fsSL is not required.

if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8

" Ghostty/kitty/wezterm TERM has no terminfo on RHEL → arrows become A/B/C/D.
if !has('nvim') && !has('gui_running') && &term =~# 'ghostty\|kitty\|wezterm\|alacritty\|foot\|unknown'
  silent! set term=xterm-256color
endif

let mapleader = ' '
let maplocalleader = ' '

" -----------------------------------------------------------------------------
" UI
" -----------------------------------------------------------------------------
syntax enable
filetype plugin indent on

set number
set ruler
set showcmd
set noshowmode
set laststatus=2
set cmdheight=1
if exists('+signcolumn')
  set signcolumn=auto
endif
set cursorline
set scrolloff=8
set sidescrolloff=8
set display=lastline
set lazyredraw
set ttyfast
set title
set splitbelow
set splitright
set pumheight=12
set conceallevel=0
set colorcolumn=100
set list
set listchars=tab:»\ ,trail:·,nbsp:␣,extends:›,precedes:‹
if has('nvim')
  set fillchars=vert:\│,fold:\ ,eob:\ 
else
  set fillchars=vert:\│,fold:\ 
endif 
set shortmess+=cI
set belloff=all
set visualbell t_vb=
set background=dark

" 256-color GNU screen / tmux: disable Background Color Erase
if &term =~# '256color'
  set t_ut=
endif

if has('termguicolors') && empty($SSH_CONNECTION) && &t_Co >= 256
  " Leave termguicolors off over SSH; many jump hosts break truecolor.
endif

" Dim ANSI colors (DarkCyan, Brown, DarkBlue) vanish on a black SSH
" terminal. These are the bright row from :help cterm-colors:
"   10 green, 11 cyan, 12 red, 13 magenta, 14 yellow, 15 white.
function! s:ReadableColors() abort
  if &t_Co == 0
    return
  endif
  hi Normal ctermfg=15 ctermbg=0 guifg=#eeeeee guibg=#000000
  hi Comment ctermfg=11 cterm=NONE guifg=#5fffff
  hi Constant ctermfg=14 guifg=#ffff5f
  hi String ctermfg=14 guifg=#ffff5f
  hi Character ctermfg=14 guifg=#ffff5f
  hi Number ctermfg=14 guifg=#ffff5f
  hi Boolean ctermfg=14 guifg=#ffff5f
  hi Float ctermfg=14 guifg=#ffff5f
  hi Identifier ctermfg=15 guifg=#eeeeee
  hi Function ctermfg=11 guifg=#5fffff
  hi Statement ctermfg=13 cterm=NONE guifg=#ff5fff
  hi Conditional ctermfg=13 guifg=#ff5fff
  hi Repeat ctermfg=13 guifg=#ff5fff
  hi Label ctermfg=13 guifg=#ff5fff
  hi Operator ctermfg=15 guifg=#eeeeee
  hi Keyword ctermfg=13 guifg=#ff5fff
  hi Exception ctermfg=13 guifg=#ff5fff
  hi PreProc ctermfg=13 guifg=#ff5fff
  hi Include ctermfg=13 guifg=#ff5fff
  hi Define ctermfg=13 guifg=#ff5fff
  hi Macro ctermfg=13 guifg=#ff5fff
  hi PreCondit ctermfg=13 guifg=#ff5fff
  hi Type ctermfg=10 guifg=#5fff5f
  hi StorageClass ctermfg=10 guifg=#5fff5f
  hi Structure ctermfg=10 guifg=#5fff5f
  hi Typedef ctermfg=10 guifg=#5fff5f
  hi Special ctermfg=14 guifg=#ffff5f
  hi SpecialChar ctermfg=14 guifg=#ffff5f
  hi Tag ctermfg=11 guifg=#5fffff
  hi Delimiter ctermfg=15 guifg=#eeeeee
  hi SpecialComment ctermfg=11 guifg=#5fffff
  hi Debug ctermfg=14 guifg=#ffff5f
  hi Underlined ctermfg=11 cterm=underline guifg=#5fffff
  hi Ignore ctermfg=11 guifg=#5fffff
  hi Error ctermfg=15 ctermbg=12 guifg=#ffffff guibg=#ff5f5f
  hi Todo ctermfg=0 ctermbg=14 cterm=bold guifg=#000000 guibg=#ffff5f
  hi LineNr ctermfg=11 ctermbg=0 guifg=#5fffff guibg=#000000
  hi CursorLineNr ctermfg=15 ctermbg=0 cterm=bold guifg=#ffffff guibg=#000000
  hi CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
  hi ColorColumn ctermbg=0 guibg=#000000
  hi NonText ctermfg=11 guifg=#5fffff
  hi SpecialKey ctermfg=11 guifg=#5fffff
  hi EndOfBuffer ctermfg=11 guifg=#5fffff
  hi Whitespace ctermfg=11 guifg=#5fffff
  hi StatusLine ctermfg=0 ctermbg=11 cterm=bold guifg=#000000 guibg=#5fffff
  hi StatusLineNC ctermfg=0 ctermbg=15 guifg=#000000 guibg=#eeeeee
  hi StatusLineTerm ctermfg=0 ctermbg=11 cterm=bold guifg=#000000 guibg=#5fffff
  hi StatusLineTermNC ctermfg=0 ctermbg=15 guifg=#000000 guibg=#eeeeee
  hi VertSplit ctermfg=11 ctermbg=0 guifg=#5fffff guibg=#000000
  hi Pmenu ctermfg=15 ctermbg=0 guifg=#eeeeee guibg=#000000
  hi PmenuSel ctermfg=0 ctermbg=11 guifg=#000000 guibg=#5fffff
  hi PmenuSbar ctermbg=15 guibg=#eeeeee
  hi PmenuThumb ctermbg=11 guibg=#5fffff
  hi Visual ctermfg=0 ctermbg=11 guifg=#000000 guibg=#5fffff
  hi Search ctermfg=0 ctermbg=14 guifg=#000000 guibg=#ffff5f
  hi IncSearch ctermfg=0 ctermbg=11 guifg=#000000 guibg=#5fffff
  hi MatchParen ctermfg=0 ctermbg=14 cterm=bold guifg=#000000 guibg=#ffff5f
  hi Folded ctermfg=15 ctermbg=0 guifg=#eeeeee guibg=#000000
  hi FoldColumn ctermfg=11 ctermbg=0 guifg=#5fffff guibg=#000000
  hi DiffAdd ctermfg=0 ctermbg=10 guifg=#000000 guibg=#5fff5f
  hi DiffChange ctermfg=0 ctermbg=14 guifg=#000000 guibg=#ffff5f
  hi DiffDelete ctermfg=0 ctermbg=12 guifg=#000000 guibg=#ff5f5f
  hi DiffText ctermfg=0 ctermbg=11 guifg=#000000 guibg=#5fffff
  hi SpellBad ctermfg=15 ctermbg=12 guifg=#ffffff guibg=#ff5f5f
  hi SpellCap ctermfg=0 ctermbg=14 guifg=#000000 guibg=#ffff5f
  hi ErrorMsg ctermfg=15 ctermbg=12 guifg=#ffffff guibg=#ff5f5f
  hi WarningMsg ctermfg=14 guifg=#ffff5f
  hi ModeMsg ctermfg=15 cterm=bold guifg=#ffffff
  hi MoreMsg ctermfg=10 guifg=#5fff5f
  hi Question ctermfg=10 guifg=#5fff5f
  hi Title ctermfg=15 cterm=bold guifg=#ffffff
  hi Directory ctermfg=11 guifg=#5fffff
  hi TabLine ctermfg=15 ctermbg=0 guifg=#eeeeee guibg=#000000
  hi TabLineSel ctermfg=0 ctermbg=11 cterm=bold guifg=#000000 guibg=#5fffff
  hi TabLineFill ctermfg=15 ctermbg=0 guifg=#eeeeee guibg=#000000
  hi WildMenu ctermfg=0 ctermbg=14 guifg=#000000 guibg=#ffff5f
  hi SignColumn ctermfg=11 ctermbg=0 guifg=#5fffff guibg=#000000
  hi QuickFixLine ctermfg=0 ctermbg=14 guifg=#000000 guibg=#ffff5f
  hi ExtraWhitespace ctermbg=12 guibg=#ff5f5f
endfunction

" ~/.vimrc.local is the per-machine override. To use a colorscheme instead
" of the bright palette, put this in that file:
"   let g:dotfiles_colorscheme = 'habamax'
if filereadable(expand('~/.vimrc.local'))
  execute 'source' fnameescape(expand('~/.vimrc.local'))
endif
if !exists('g:dotfiles_colorscheme')
  let g:dotfiles_colorscheme = ''
endif

if g:dotfiles_colorscheme !=# ''
  execute 'silent! colorscheme' fnameescape(g:dotfiles_colorscheme)
endif
" Empty name, or a scheme that is not installed: keep the bright palette.
if g:dotfiles_colorscheme ==# '' || !exists('g:colors_name')
  augroup dotfiles_readable
    autocmd!
    autocmd ColorScheme * call s:ReadableColors()
  augroup END
  call s:ReadableColors()
endif

" Mouse helps locally; on SSH it steals terminal copy/paste.
if $SSH_CONNECTION ==# ''
  set mouse=a
else
  set mouse=
endif
nnoremap <silent> <leader>m :call <SID>ToggleMouse()<CR>

" -----------------------------------------------------------------------------
" Editing
" -----------------------------------------------------------------------------
set backspace=indent,eol,start
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set smarttab
set autoindent
set smartindent
set wrap
set linebreak
set nojoinspaces
set virtualedit=block
set formatoptions=jcroql
set iskeyword+=-
set complete-=i
set complete+=kspell
set completeopt=menu,menuone,longest
set timeoutlen=400
set ttimeout
" 50ms is too tight over SSH; Esc-prefixed CSI arrows then leak as A/B/C/D.
set ttimeoutlen=100
if !has('nvim')
  set esckeys
endif
set updatetime=300
set nrformats-=octal

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
if exists('+inccommand')
  set inccommand=split
endif

" -----------------------------------------------------------------------------
" Files / buffers
" -----------------------------------------------------------------------------
set hidden
set confirm
set autoread
set noswapfile
set nobackup
set nowritebackup
set history=10000
set sessionoptions=buffers,curdir,folds,help,tabpages,winsize

if !isdirectory(expand('~/.vim'))
  call mkdir(expand('~/.vim'), 'p', 0700)
endif

if has('persistent_undo')
  let s:undo_dir = expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
  endif
  let &undodir = s:undo_dir
  set undofile
  set undolevels=10000
endif

if !has('nvim')
  set viminfo='200,<100,s32,h,n~/.vim/viminfo
endif

if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m
elseif executable('grep')
  set grepprg=grep\ -nH\ --exclude-dir=.git\ --exclude-dir=node_modules\ --exclude-dir=target
endif

" :find walks the tree (use ** sparingly on huge repos)
set path+=**
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/.git/*,*/node_modules/*,*/target/*,*/dist/*,*/build/*
set wildignore+=*.o,*.obj,*.pyc,*.so,*.swp,*.zip,tags

" -----------------------------------------------------------------------------
" Statusline
" -----------------------------------------------------------------------------
function! s:GitBranch() abort
  if exists('b:git_branch')
    return b:git_branch
  endif
  let b:git_branch = ''
  if !executable('git')
    return ''
  endif
  let l:dir = expand('%:p:h')
  if l:dir ==# '' || !isdirectory(l:dir)
    return ''
  endif
  let l:out = system('git -C ' . shellescape(l:dir) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  if !v:shell_error
    let b:git_branch = '  ' . substitute(l:out, '\n\+$', '', '')
  endif
  return b:git_branch
endfunction

function! s:StatusMode() abort
  return get({'n':'N','i':'I','R':'R','v':'V','V':'VL',"\<C-v>":'VB','c':'C','t':'T'}, mode(), mode())
endfunction

" <SID> inside %{...} is evaluated later, outside script context (E120).
" Bake the SNR prefix in now so the statusline calls <SNR>NN_Func().
let &statusline = '%#StatusLineTerm# %{' . expand('<SID>') . 'StatusMode()} %*'
      \ . ' %f'
      \ . '%{' . expand('<SID>') . 'GitBranch()}'
      \ . ' %h%m%r%w'
      \ . '%='
      \ . '%y %{&fileencoding} %{&fileformat}'
      \ . ' %l:%c %p%% ' 

" -----------------------------------------------------------------------------
" Netrw (built-in file tree)
" -----------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
let g:netrw_winsize = 28
let g:netrw_dirhistmax = 0

nnoremap <silent> <leader>e :Lexplore<CR>
nnoremap <silent> <leader>o :Lexplore %:p:h<CR>

" -----------------------------------------------------------------------------
" Keymaps (aligned with the nvim config where it is safe)
" -----------------------------------------------------------------------------
" Do not map bare <Esc> in Vim: arrow keys are Esc [ A/B/C/D (and Esc O A).
" Neovim maps <Esc> for this; <C-l> is already window-right below.
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <silent> <leader>w :%s/\s\+$//e<CR>
nnoremap <leader>p "_dP
xnoremap <leader>p "_dP
nnoremap <leader>d "_d
xnoremap <leader>d "_d

nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> gn :bnext<CR>
nnoremap <silent> gp :bprevious<CR>
nnoremap <silent> <leader>bd :bdelete<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-Left> <C-w>h
nnoremap <C-Right> <C-w>l
nnoremap <silent> <leader>sv :vsplit<CR>
nnoremap <silent> <leader>sh :split<CR>
nnoremap <silent> <leader>se <C-w>=
nnoremap <silent> <leader>sx :close<CR>

nnoremap <silent> <A-Up> :resize +2<CR>
nnoremap <silent> <A-Down> :resize -2<CR>
nnoremap <silent> <A-Left> :vertical resize -2<CR>
nnoremap <silent> <A-Right> :vertical resize +2<CR>

nnoremap <silent> <leader>qq :qa<CR>
nnoremap <silent> <C-s> :write<CR>
inoremap <silent> <C-s> <C-o>:write<CR>

nnoremap <silent> <leader>r :source $MYVIMRC<CR>
nnoremap <silent> <leader>v :edit $MYVIMRC<CR>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

vnoremap < <gv
vnoremap > >gv
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv
vnoremap . :normal .<CR>

nnoremap <leader>ff :find<Space>
nnoremap <leader>fb :buffers<CR>:buffer<Space>
nnoremap <leader>fg :grep<Space>
nnoremap <leader>fw :grep -w <C-r><C-w><CR>
nnoremap <silent> <leader>q :call <SID>ToggleQuickfix()<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" Count / rename word under cursor
nnoremap <leader>c *<C-O>:%s///gn<CR>
nnoremap <leader>s :.,$s/\<<C-r><C-w>\>/

if has('terminal')
  tnoremap <Esc><Esc> <C-\><C-n>
  nnoremap <silent> <leader>tt :below terminal ++rows=15<CR>
endif

" -----------------------------------------------------------------------------
" Comment toggle (gcc / gc) — uses 'commentstring'
" -----------------------------------------------------------------------------
function! s:ToggleComment() range abort
  let l:cs = substitute(&commentstring, '\s*%s.*', '', '')
  if l:cs ==# ''
    let l:cs = '#'
  endif
  let l:pat = '^\(\s*\)' . escape(l:cs, '\/^$.*~[]') . '\s\?'
  let l:all_commented = 1
  for l:lnum in range(a:firstline, a:lastline)
    let l:line = getline(l:lnum)
    if l:line =~# '^\s*$'
      continue
    endif
    if l:line !~# l:pat
      let l:all_commented = 0
      break
    endif
  endfor
  for l:lnum in range(a:firstline, a:lastline)
    let l:line = getline(l:lnum)
    if l:line =~# '^\s*$'
      continue
    endif
    if l:all_commented
      call setline(l:lnum, substitute(l:line, l:pat, '\1', ''))
    else
      call setline(l:lnum, substitute(l:line, '^\s*', '\0' . l:cs . ' ', ''))
    endif
  endfor
endfunction

nnoremap <silent> gcc :call <SID>ToggleComment()<CR>
xnoremap <silent> gc :call <SID>ToggleComment()<CR>

" -----------------------------------------------------------------------------
" Helpers
" -----------------------------------------------------------------------------
function! s:ToggleMouse() abort
  if &mouse ==# ''
    set mouse=a
    echo 'mouse=a'
  else
    set mouse=
    echo 'mouse off'
  endif
endfunction

function! s:ToggleQuickfix() abort
  if exists('*getwininfo')
    for l:win in getwininfo()
      if l:win.quickfix && !get(l:win, 'loclist', 0)
        cclose
        return
      endif
    endfor
  endif
  copen
endfunction

function! s:AutoMkdir() abort
  let l:dir = expand('<afile>:p:h')
  if l:dir !=# '' && !isdirectory(l:dir) && l:dir !~# '^\w\+://'
    call mkdir(l:dir, 'p')
  endif
endfunction

function! s:RestoreCursor() abort
  if &filetype =~# 'gitcommit\|gitrebase'
    return
  endif
  if line("'\"") > 0 && line("'\"") <= line('$')
    execute 'normal! g`"'
  endif
endfunction

function! s:ExecuteMacroOverVisualRange() abort
  echo '@' . getcmdline()
  execute ":'<,'>normal @" . nr2char(getchar())
endfunction

xnoremap @ :<C-u>call <SID>ExecuteMacroOverVisualRange()<CR>

" Bracketed paste: use Vim 8+ termcap. Do not inoremap <Esc>[... on Vim 7 —
" that mapping prefix makes insert-mode arrows leak as A/B/C/D.
if !has('nvim') && exists('&t_BE') && &t_BE ==# ''
  let &t_BE = "\<Esc>[?2004h"
  let &t_BD = "\<Esc>[?2004l"
  if exists('&t_PS')
    let &t_PS = "\<Esc>[200~"
    let &t_PE = "\<Esc>[201~"
  endif
endif

" Teach Vim CSI + SS3 cursor keys when host terminfo is incomplete (RHEL).
if !has('nvim') && !has('gui_running')
  silent! execute "set <Up>=\<Esc>[A"
  silent! execute "set <Down>=\<Esc>[B"
  silent! execute "set <Right>=\<Esc>[C"
  silent! execute "set <Left>=\<Esc>[D"
  silent! execute "set <xUp>=\<Esc>OA"
  silent! execute "set <xDown>=\<Esc>OB"
  silent! execute "set <xRight>=\<Esc>OC"
  silent! execute "set <xLeft>=\<Esc>OD"
endif

" -----------------------------------------------------------------------------
" Autocommands
" -----------------------------------------------------------------------------
augroup vimrc
  autocmd!
  autocmd BufWritePre * call <SID>AutoMkdir()
  autocmd BufEnter,BufWritePost * unlet! b:git_branch
  autocmd BufReadPost * call <SID>RestoreCursor()
  autocmd FocusGained,BufEnter * checktime
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd SwapExists * let v:swapchoice = 'e'
  autocmd BufNewFile,BufRead *.gotmpl setfiletype yaml
  autocmd FileType python,rust,go setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType go setlocal noexpandtab
  autocmd FileType qf,help,netrw nnoremap <buffer> <silent> q :close<CR>
  autocmd FileType netrw setlocal bufhidden=wipe
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=DarkRed guibg=#5f0000
  autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
augroup END

highlight ExtraWhitespace ctermbg=DarkRed guibg=#5f0000
