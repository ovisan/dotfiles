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
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Live preview: moving in the tree shows the file in the right window.
        -- Preview buffers are discarded unless you <CR> or start editing.
        -- P toggles this so you can browse without replacing the current file.
        local auto_preview = true
        local timer = vim.uv.new_timer()
        local delay_ms = 80
        local max_bytes = 1024 * 1024

        local function is_previewable(node)
          if not node or node.name == ".." or node.type == "directory" then
            return false
          end
          local path = node.absolute_path
          if not path or vim.fn.filereadable(path) ~= 1 then
            return false
          end
          local stat = vim.uv.fs_stat(path)
          if not stat or stat.size > max_bytes then
            return false
          end
          local fd = vim.uv.fs_open(path, "r", 438)
          if not fd then
            return false
          end
          local data = vim.uv.fs_read(fd, 512, 0)
          vim.uv.fs_close(fd)
          if data and data:find("\0", 1, true) then
            return false
          end
          return true
        end

        local function target_is_modified()
          local ok, lib = pcall(require, "nvim-tree.lib")
          local winid = ok and lib.target_winid or nil
          if not winid or not vim.api.nvim_win_is_valid(winid) then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local buf = vim.api.nvim_win_get_buf(win)
              local cfg = vim.api.nvim_win_get_config(win)
              if vim.bo[buf].filetype ~= "NvimTree" and cfg.relative == "" then
                winid = win
                break
              end
            end
          end
          if not winid or not vim.api.nvim_win_is_valid(winid) then
            return false
          end
          return vim.bo[vim.api.nvim_win_get_buf(winid)].modified
        end

        local function preview_under_cursor()
          if not auto_preview or vim.api.nvim_get_current_buf() ~= bufnr then
            return
          end
          if target_is_modified() then
            return
          end
          local ok, node = pcall(api.tree.get_node_under_cursor)
          if not ok or not is_previewable(node) then
            return
          end
          api.node.open.preview_no_picker()
        end

        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = bufnr,
          callback = function()
            timer:stop()
            timer:start(delay_ms, 0, vim.schedule_wrap(preview_under_cursor))
          end,
        })

        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = bufnr,
          once = true,
          callback = function()
            timer:stop()
            timer:close()
          end,
        })

        vim.keymap.set("n", "P", function()
          auto_preview = not auto_preview
          vim.notify("File preview " .. (auto_preview and "on" or "off"))
          if auto_preview then
            preview_under_cursor()
          end
        end, opts("Toggle auto preview"))

        vim.keymap.set("n", "<Right>", api.node.expand, opts("Expand Directory"))
        vim.keymap.set("n", "<Left>", api.node.collapse, opts("Collapse Directory"))

        -- :q / :quit from the tree should leave Neovim, not just hide the sidebar
        vim.cmd("cabbrev <buffer> <expr> q (getcmdtype() == ':' && getcmdline() ==# 'q') ? 'qa' : 'q'")
        vim.cmd("cabbrev <buffer> <expr> q! (getcmdtype() == ':' && getcmdline() ==# 'q!') ? 'qa!' : 'q!'")
        vim.cmd("cabbrev <buffer> <expr> quit (getcmdtype() == ':' && getcmdline() ==# 'quit') ? 'qa' : 'quit'")
      end,
    },
    config = function(_, opts)
      -- nvim-tree clears the FileExplorer augroup; create it first so
      -- `autocmd! FileExplorer *` does not emit E216 when netrw is disabled.
      vim.api.nvim_create_augroup("FileExplorer", { clear = true })
      require("nvim-tree").setup(opts)

      local function is_float(win)
        return vim.api.nvim_win_get_config(win).relative ~= ""
      end

      local function split_normal_wins()
        local tree_wins, file_wins = {}, {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if not is_float(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NvimTree" then
              table.insert(tree_wins, win)
            else
              table.insert(file_wins, win)
            end
          end
        end
        return tree_wins, file_wins
      end

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

      -- Tree + one file (the usual preview layout): :q closes the other pane
      -- so Neovim actually exits instead of leaving a leftover window.
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local tree_wins, file_wins = split_normal_wins()
          if #tree_wins == 0 or #file_wins > 1 then
            return
          end
          local current = vim.api.nvim_get_current_win()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if win ~= current and vim.api.nvim_win_is_valid(win) and not is_float(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              if not vim.bo[buf].modified then
                pcall(vim.api.nvim_win_close, win, false)
              end
            end
          end
        end,
      })

      -- Quit when nvim-tree is the last real window (ignore floats)
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          local tree_wins, file_wins = split_normal_wins()
          if #file_wins == 0 and #tree_wins > 0 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}
