return {
  -- 1. The Package Manager (Mason)
  {
    "mason-org/mason.nvim",
    opts = {}
},

  -- 2. The Auto-Installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "tree-sitter-cli",
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

}

