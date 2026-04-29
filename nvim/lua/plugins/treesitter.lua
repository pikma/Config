return {
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      -- Add Mason's bin directory to PATH so this plugin can find tree-sitter-cli
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

      require("tree-sitter-manager").setup({
        auto_install = true, -- if enabled, install missing parsers when editing a new file
        highlight = true, -- treesitter highlighting is enabled by default

        -- Other Default Optionsk
        -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        -- languages = {}, -- override or add new parser sources
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })
    end
  }
  ,
}

