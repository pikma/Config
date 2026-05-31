return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI is installed by Mason.
    config = function()
      require("tree-sitter-manager").setup({
        auto_install = true, -- if enabled, install missing parsers when editing a new file
        highlight = true, -- treesitter highlighting is enabled by default

        -- Other Default Optionsk
        ensure_installed = {"rust", "rust_with_rstml"}, -- list of parsers to install at the start of a neovim session
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        languages = {
          -- Define the custom rstml source details for the manager
          rust_with_rstml = {
            install_info = {
              url = "https://github.com/rayliwell/tree-sitter-rstml",
              location = "rust_with_rstml",
              use_repo_queries = true,
            },
          },
        },
        -- rust_with_rstml is not a real filetype; we route 'rust' to it via language.register below
        nohighlight = { "rust_with_rstml" },
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })

      -- Use the rstml parser (which understands Leptos view! macros) for all Rust files
      vim.treesitter.language.register("rust_with_rstml", "rust")

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- Do not fold everything by default when opening a file
      vim.opt.foldenable = true
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end
  }
  ,
}

