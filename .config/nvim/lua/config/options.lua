local opt = vim.opt
local g = vim.g

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3 -- global statusline
opt.pumheight = 12
opt.pumblend = 10
opt.winblend = 0
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldsep = " ", foldclose = "▸" }
opt.conceallevel = 0
opt.colorcolumn = "100"
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.smoothscroll = true

-- Editing
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true
opt.wrap = false
opt.linebreak = true
opt.virtualedit = "block"
opt.formatoptions = "jcroqlnt"
opt.iskeyword:append("-")
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append({ c = true, I = true, W = true, C = true })

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- Files / buffers
opt.hidden = true
opt.confirm = true
opt.autowrite = true
opt.autoread = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(vim.o.undodir, "p")

-- Timing
opt.updatetime = 200
opt.timeoutlen = 400
opt.ttimeoutlen = 10

-- Wildmenu
opt.wildmode = "longest:full,full"
opt.wildignore:append({
  "*/.git/*",
  "*/node_modules/*",
  "*/target/*",
  "*/dist/*",
  "*/build/*",
  "*.o",
  "*.obj",
  "*.pyc",
  "*.swp",
  "*.zip",
})

-- History / marks
opt.history = 10000
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Folding (treesitter-aware when available)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Neovide (no-op in terminal nvim)
g.neovide_input_macos_alt_is_meta = true
opt.guifont = "FiraCode Nerd Font:h15"

-- Disable providers we don't use
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

-- Prefer ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git'"
  opt.grepformat = "%f:%l:%c:%m"
end
