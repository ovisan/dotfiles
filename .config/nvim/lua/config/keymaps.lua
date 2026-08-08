local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Keep cursor centered while scrolling / searching
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Better paste (don't replace register when pasting over selection)
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Delete without yanking
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Strip trailing whitespace
map("n", "<leader>w", [[:%s/\s\+$//e<CR>]], { desc = "Strip trailing whitespace" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "gn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "gp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Left>", "<C-w>h", opts)
map("n", "<C-Right>", "<C-w>l", opts)
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Resize
map("n", "<A-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<A-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<A-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<A-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Save / quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>", { desc = "Save file" })

-- Config
map("n", "<leader>r", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })
map("n", "<leader>v", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit config" })

-- Terminal escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- macOS / GUI paste in insert mode
map("i", "<D-v>", "<C-r>+", opts)
map("i", "<S-Insert>", "<C-r>+", opts)

-- Diagnostic navigation (global; LSP buffer maps added on attach)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
