local google_options_file = vim.fn.expand("~/.myConfig/vim_custom_google.vim")
local is_google = vim.fn.filereadable(google_options_file) == 1

local toggle_diagnostic_virtual_text = function(min_severity)
  local config = vim.diagnostic.config();
  if config.virtual_text == false
    -- Higher severities have lower numerical values, so the comparison is the
    -- opposite of what you'd expect.
    or config.virtual_text.severity.min < min_severity then
    vim.diagnostic.config({
      virtual_text = {
        -- source = "if_many",
        severity = { min = min_severity },
      },
    })
  else
    vim.diagnostic.config({
      virtual_text = false
    })
  end
end

local toggle_diagnostic_virtual_lines = function()
  local config = vim.diagnostic.config();
  local new_value = not config.virtual_lines;
  vim.diagnostic.config({ virtual_lines = new_value });
end

return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup()

      if is_google then
        vim.lsp.enable("ciderlsp")
      end

      -- Diagnostics: signs on, no virtual text, echo under cursor
      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN]  = '▲',
            [vim.diagnostic.severity.HINT]  = '⚑',
            [vim.diagnostic.severity.INFO]  = '»',
          },
        },
        underline = true,
        severity_sort = true,
      })

      vim.keymap.set('n', '<leader>sw', function()
        toggle_diagnostic_virtual_text(vim.diagnostic.severity.WARN);
        end)
      vim.keymap.set('n', '<leader>se', function()
        toggle_diagnostic_virtual_text(vim.diagnostic.severity.ERROR);
        end)
      vim.keymap.set('n', '<leader>sd', toggle_diagnostic_virtual_lines);

      -- vim.api.nvim_create_autocmd("CursorHold", {
      --   callback = function()
      --     vim.diagnostic.open_float(nil, { focus = false })
      --   end,
      -- })

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
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    -- dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
        ['<tab>'] = { 'accept', 'show', 'fallback' },
        ['<S-tab>'] = { function(cmp) cmp.show({ providers = { 'lsp' } }) end, 'fallback' },
        ['<cr>'] = { 'select_and_accept', 'fallback' },
      },

      signature = {
        enabled = true,
      },

      cmdline = {
        keymap = {
          preset = 'cmdline',
          ['<tab>'] = { 'accept', 'show', 'fallback' },
          ['<S-tab>'] = { function(cmp) cmp.show({ providers = { 'lsp' } }) end, 'fallback' },
          ['<cr>'] = { 'select_and_accept', 'fallback' },
        },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },
        trigger = {
          -- Disable automatic popup when typing keywords
          show_on_keyword = false,
        }
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" },

  },
  }
