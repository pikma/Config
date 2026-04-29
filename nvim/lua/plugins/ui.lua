return {
  -- Colorscheme (replaces tango-morning)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "latte" })
      vim.cmd.colorscheme("catppuccin-latte")
    end,
  },

  -- Status line (replaces vim-airline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
      })
    end,
  },

  -- Git signs in the gutter (replaces vim-signify)
  { "lewis6991/gitsigns.nvim", config = true },

  -- Comments (replaces nerdcommenter)
  -- padding=true mirrors NERDSpaceDelims=1; left-align is the default
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<leader>c", mode = { "n", "x" } },
    },
    config = function()
      require("Comment").setup({ padding = true })
      -- Normal mode: toggle comment on current line, then move down (mirrors original j suffix)
      vim.keymap.set("n", "<leader>c", function()
        require("Comment.api").toggle.linewise.current()
        vim.cmd("normal! j")
      end)
      -- Visual mode: toggle comment on selection
      vim.keymap.set("x", "<leader>c", function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false
        )
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
      end)
    end,
  },

  -- Motion (replaces easymotion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader><leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "<leader>vi", mode = { "n", "x", "o" }, function() require("flash").treesitter({
          actions = {
            ["<cr>"] = "next",
            ["<BS>"] = "prev"
          }
        }) end, desc = "Flash Treesitter" },
    },
  },

  -- Tmux pane navigation (unchanged from vim)
  "christoomey/vim-tmux-navigator",
}
