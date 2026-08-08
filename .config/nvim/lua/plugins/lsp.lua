return {
  -- Install LSP servers / tools
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      -- rust_analyzer is managed by rustaceanvim (exclude from auto-enable)
      ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
        "bashls",
        "jsonls",
        "yamlls",
        "taplo",
        "marksman",
        "ts_ls",
        "clangd",
      },
      automatic_enable = {
        exclude = { "rust_analyzer" },
      },
    },
    config = function(_, opts)
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup(opts)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
      end

      local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "ga", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")
      end

      -- Defaults for all LSPs (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = { keyOrdering = false },
        },
      })

      vim.diagnostic.config({
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        float = { border = "rounded", source = true },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostics popup on hover
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
        end,
      })
    end,
  },

  -- Rust: prefer rustaceanvim over bare rust_analyzer
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end
            map("n", "gd", vim.lsp.buf.definition, "Goto definition")
            map("n", "K", vim.lsp.buf.hover, "Hover")
            map("n", "gr", vim.lsp.buf.references, "References")
            map("n", "ga", vim.lsp.buf.code_action, "Code action")
            map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
            map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
            map("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, "Rust runnables")
            map("n", "<leader>re", function()
              vim.cmd.RustLsp("explainError")
            end, "Explain error")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
              procMacro = { enable = true },
            },
          },
        },
      }
    end,
  },
}
