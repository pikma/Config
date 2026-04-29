return {
  -- 1. The Package Manager (Mason)
  {
    "williamboman/mason.nvim",
    lazy = false, -- Load this early
    config = function()
      require("mason").setup()
    end,
  },

  -- 2. The Auto-Installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "tree-sitter-cli", -- This solves your "not found" error
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

  -- 3. Treesitter Configuration
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   build = ":TSUpdate",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       -- Add the languages you use here
  --       ensure_installed = {
  --         "lua", "vim", "vimdoc", "query", "bash", "python", "c", "cpp", "sql",
  --         "latex", "r", "rust", "haskell", "gnuplot"
  --       },
  --       highlight = { enable = true },
  --       indent = { enable = true },
  --     })
  --   end,
  -- },
}

