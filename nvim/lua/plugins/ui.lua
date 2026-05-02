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
  (vim.fn.executable('jj') == 1) and {
    'evanphx/jjsigns.nvim',
    config = function()
      require('jjsigns').setup()
    end
  } or {},

	-- Comments
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
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", false)
				require("Comment.api").toggle.linewise(vim.fn.visualmode())
			end)
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
    opts = {
      modes = {
        char = {
          highlight = {
            backdrop = false,
          },
        },
      },
    },
		keys = {
			{
				"<leader><leader>f",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash jump",
			},
			{
				"<leader>vi",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter({
						actions = {
							["<cr>"] = "next",
							["<BS>"] = "prev",
						},
					})
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	"christoomey/vim-tmux-navigator",

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>=",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = true,
						timeout_ms = 500,
					})
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500 },
      -- Customize formatters
      formatters = {
        shfmt = {
          append_args = { "-i", "2" },
        },
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
