-- nvim-treesitter `main` branch (rewrite for Neovim 0.12+)
-- Old API: require("nvim-treesitter.configs").setup(...)  -- removed
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main

local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Plugin does not support lazy-loading
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        -- parsers/queries install location (prepended to runtimepath)
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install missing parsers asynchronously (no-op if already present)
      ts.install(ensure_installed)

      -- Enable highlight / indent per buffer (not automatic on main)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
        callback = function(event)
          local buf = event.buf
          -- Highlight (built into Neovim)
          pcall(vim.treesitter.start, buf)

          -- Experimental treesitter indent
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Folds (options.lua already sets foldmethod/foldexpr globally;
          -- reinforce per-window when a TS buffer opens)
          local win = vim.api.nvim_get_current_win()
          pcall(function()
            vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[win][0].foldmethod = "expr"
          end)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for lhs, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "TS select " .. query })
      end

      -- Move
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Prev function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Prev class start" })
    end,
  },
}
