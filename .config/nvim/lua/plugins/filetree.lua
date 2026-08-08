return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File explorer" },
      { "<leader>o", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Reveal file in explorer" },
    },
    opts = {
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 35,
        relativenumber = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          git_placement = "after",
          show = { file = true, folder = true, folder_arrow = true, git = true },
        },
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      -- Open tree on startup for real files / empty buffers
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local real_file = vim.fn.filereadable(data.file) == 1
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
          if real_file then
            require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
          elseif no_name then
            require("nvim-tree.api").tree.toggle({ focus = true, find_file = true })
          end
        end,
      })

      -- Quit when nvim-tree is the last window
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}
