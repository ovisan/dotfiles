-- Set font
vim.o.guifont = "FiraCode Nerd Font:h15"

-- Set MacOS keys
vim.g.neovide_input_macos_alt_is_meta = true

-- yank copies to clipboard
vim.opt.clipboard = "unnamedplus"

local opts = { noremap = true, silent = true }

vim.opt.hidden = true
vim.opt.ruler = true

--  set pwd to the opened file
vim.opt.autochdir = true

-- Do not show current vim mode since it is already shown by Lualine
vim.o.showmode = false

-- enable autowriteall
vim.o.autowriteall = true

-- Show the line numbers
vim.wo.number = true

-- Show chars at the end of line
vim.opt.list = true

-- Enable break indent
vim.o.breakindent = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Shows signs by Autocompletion plugin
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- define the Leader key
vim.g.mapleader = " "

-- define paste
vim.keymap.set('i', '<D-v>', '<MiddleMouse>')
vim.keymap.set('i', '<S-Insert>', '<MiddleMouse>')

-- disable hightliting on escape
vim.keymap.set('n', '<esc>', ':noh<CR>')

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("v", "J", ":m .+1<CR>==", opts)
vim.keymap.set("v", "K", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Delete whitespaces
vim.keymap.set('n', '<Leader>w', ':%s/\\s\\+$//e<CR>', opts)

-- Highlight on yank
vim.cmd [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]

-- file backup - history
vim.cmd('silent !mkdir ~/.vim/history > /dev/null 2>&1')
vim.o.undodir = "~/.vim/history"
vim.o.undofile = true

local options = {
  termguicolors = true
}

-- highlight whitespaces https://vim.fandom.com/wiki/Highlight_unwanted_spaces
-- vim.cmd [[
--   augroup Whitespaces
--     autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
--     autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
--     autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
--     autocmd InsertLeave * match ExtraWhitespace /\s\+$/
--     autocmd BufWinLeave * call clearmatches()
--   augroup end
-- ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.termguicolors = true

-- Colorscheme
vim.cmd([[colorscheme habamax]])

require("lazy").setup({
  "neovim/nvim-lspconfig",
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    opts = {
      -- options
    },
  },
  "nvim-treesitter/nvim-treesitter",
  "HiPhish/rainbow-delimiters.nvim",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  -- Autocompletion plugin
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },
  -- snippets
  {
    "hrsh7th/cmp-vsnip",
    dependencies = {
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
  },

  {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = { 
        "nvim-treesitter/nvim-treesitter",
      },
  },

  "windwp/nvim-autopairs",
  {
     "nvim-tree/nvim-tree.lua",
     dependencies = {
       'nvim-tree/nvim-web-devicons',
     },
  },
  {
     "nvim-telescope/telescope.nvim",                 -- fuzzy finder
     dependencies = {
       "nvim-lua/plenary.nvim",
      },
  },
  {
      "nvim-lualine/lualine.nvim",                     -- statusline
      depenencies = {
        "kyazdani42/nvim-web-devicons",
      },
  },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim", 
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },


  -- Adds extra functionality over rust analyzer
  "simrat39/rust-tools.nvim",

  -- Optional
  "nvim-lua/popup.nvim",
  "tomtom/tcomment_vim",
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-surround",
  "mbbill/undotree",
  "itchyny/lightline.vim",
  "godlygeek/tabular",
  "sheerun/vim-polyglot",
  "aklt/plantuml-syntax",
  "tyru/open-browser.vim",
  "weirongxu/plantuml-previewer.vim",
  "rust-lang/rust.vim"
})


-- Plugin configuration

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {"python", "rust", "c", "cpp", "bash", "awk", "cmake", "diff", "jq", "go", "html", "yaml", "json", "toml", "markdown", "lua"},
  highlight = {
    enable = true, -- false will disable the whole extension
  },
}

-- nvim-treesitter-textobjects
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
  },
}
-- rainbow_delimiters
-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

-- indent_blankline
require("ibl").setup()

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- open lazygit
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
function _lazygit_toggle()
  -- current working directory and active buffer
  lazygit.dir = vim.fn.expand("%:p:h")
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<M-g>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})


-- open ToggleTerm
local terminalinstance = require("toggleterm").setup{open_mapping = [[<leader>tt]]}

-- nvim-tree
require('nvim-tree').setup({
    view = {
      width = 35,
    },
  })

local function open_nvim_tree(data)

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
  local no_buf = vim.bo[data.buf].buftype == ""

  if real_file then
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
  end

  if no_name then
    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = true, find_file = true, })
  end

end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')


-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- lualine
require('lualine').setup{}
-- nvim-autopairs
require('nvim-autopairs').setup{}

-- Plugin config end

local function on_attach(client, buffer)
    local keymap_opts = { buffer = buffer }
    -- Code navigation and shortcuts
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
    vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
    vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)

    -- Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end,
      group = diag_float_grp,
    })

    -- Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
end

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require("rust-tools").setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
-- set updatetime=300
vim.opt.updatetime = 100
