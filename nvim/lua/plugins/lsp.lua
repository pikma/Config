local google_options_file = vim.fn.expand("~/.myConfig/vim_custom_google.vim")
local is_google = vim.fn.filereadable(google_options_file) == 1

return {
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Skip auto-install in Google environment (handled by vim_custom_google.vim)
        ensure_installed = is_google and {} or { "pylsp", "ts_ls", "gopls", "rust_analyzer" },
      })

      if is_google then
        vim.lsp.enable("ciderlsp")
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      if not is_google then
        -- vim.lsp.config merges with the base server config provided by nvim-lspconfig's lsp/*.lua files
        vim.lsp.config("pylsp", {
          capabilities = capabilities,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { indentSize = 2, maxLineLength = 100 },
              },
            },
          },
        })

        vim.lsp.config("ts_ls", {
          capabilities = capabilities,
          settings = {
            diagnosticOptions = { enableExperimentalDiagnostics = true },
          },
        })

        vim.lsp.config("gopls",        { capabilities = capabilities })
        vim.lsp.config("rust_analyzer", { capabilities = capabilities })

        vim.lsp.enable({ "pylsp", "ts_ls", "gopls", "rust_analyzer" })
      end

      -- Diagnostics: signs on, no virtual text, echo under cursor (mirrors original)
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      })

      -- LSP keymaps active only when an LSP is attached to the buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          -- vim.keymap.set("n", "<leader>=", function()
            -- vim.lsp.buf.format({ async = true })
          -- end, opts)
          vim.keymap.set("v", "<leader>=", function()
            vim.lsp.buf.format({
              async = false,
              range = {
                ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                ["end"]   = vim.api.nvim_buf_get_mark(0, ">"),
              },
            })
          end, opts)

          -- The "gq" command should use nvim's built-in formatter.
          vim.bo[ev.buf].formatexpr = nil
        end,
      })

      if is_google then
        -- Disable backups. Neovim backups by default, deleting the original file
        -- and copying the backup over it when saving (:help backupcopy). This
        -- messes with iblaze and CiderLSP diagnostics. Another way to address
        -- this is setting backupdir to a folder outside CitC, combined with
        -- `vim.o.backupcopy = "yes"`.
        vim.o.backup = false
        vim.o.writebackup = false
        vim.o.updatetime = 2000 -- Wait 2s to trigger CursorHold (highlighting).
      end
    end,
  },
}
