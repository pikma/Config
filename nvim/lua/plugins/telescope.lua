local google_options_file = vim.fn.expand("~/.myConfig/vim_custom_google.vim")
local is_google = vim.fn.filereadable(google_options_file) == 1

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      is_google and {
        "vintharas/telescope-codesearch.nvim",
        url = "sso://user/vintharas/telescope-codesearch.nvim",
        -- lazy.nvim relies on a declarative api (LazySpec) to configure your
        -- plugins. See https://github.com/folke/lazy.nvim#-plugin-spec for
        -- more information about the available options.
        keys = {
          {
            "<leader>,c",
            "<cmd>Telescope codesearch find_files<cr>",
            desc = "Find codesearch files",
          },
          -- {
          --   "<leader>,q",
          --   "<cmd>Telescope codesearch find_query<cr>",
          --   desc = "Find codesearch query",
          -- },
        },
        config = function()
          -- This asks telescope to load the codesearch extension and makes
          -- the 'codesearch' picker available through the `Telescope` command.
          require("telescope").load_extension("codesearch")
        end,
      } or {},
		},
		keys = {
			{ "<leader>,e" },
			{ "<leader>,E" },
			{ "<leader>,h" },
			{ "<leader>,d" },
			{ "<leader>,/" },
			{ "<leader>,?" },
			{ "<leader>,g" },
			{ "<leader>,c" },
			{ "<leader>,j" },
			{ "<leader>,J" },
			{ "<leader>,m" },
			{ "<leader>ve" },
			{ "<leader>vE" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules/", ".git/" },
				},
			})
			telescope.load_extension("fzf")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>,e", builtin.find_files,
        { desc = "Find Files" })

	local title1 = "Find Files (including .gitignore)"
	vim.keymap.set("n", "<leader>,E", function()
		builtin.find_files({ no_ignore = true, prompt_title = title1 })
	end, { desc = title1 })

	local oldfiles_func = builtin.oldfiles
	if is_google then
		local ok, google_utils = pcall(require, "google_utils")
		if ok and google_utils.citc_oldfiles then
			oldfiles_func = google_utils.citc_oldfiles
		end
	end
	vim.keymap.set("n", "<leader>,h", oldfiles_func, { desc = "Find within [H]istory" })

	local title2 = "Find files in same [D]irectory"
	vim.keymap.set("n", "<leader>,d", function()
		builtin.find_files({
			cwd = vim.fn.expand("%:p:h"),
			no_ignore = true,
			prompt_title = title2,
		})
	end, { desc = title2 })

	vim.keymap.set(
		"n",
		"<leader>/",
		builtin.current_buffer_fuzzy_find,
		{ desc = "[/] Fuzzily search in current buffer]" }
	)

	vim.keymap.set("n", "<leader>,?", builtin.help_tags,
  { desc = "[S]earch [H]elp" })

	-- vim.keymap.set("n", "<leader>,w", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	--
	vim.keymap.set("n", "<leader>,g", builtin.live_grep,
  { desc = "[S]earch by [G]rep" })

	vim.keymap.set("n", "<leader>,j", function()
		builtin.find_files({
			prompt_title = "JJ Changed Files in current commit",
			find_command = { "jj", "diff", "--name-only" },
		})
	end, { desc = "J[j] changed files" })

	vim.keymap.set("n", "<leader>,J", function()
		builtin.find_files({
			prompt_title = "JJ Changed Files since main",
			find_command = { "jj", "diff", "--from", "main", "--name-only" },
		})
	end, { desc = "[J]j changed files" })

	vim.keymap.set("n", "<leader>,m", builtin.keymaps,
  { desc = "Search key [M]amppings" })

	local title3 = "Find Nvim config files"
	vim.keymap.set("n", "<leader>ve", function()
		builtin.find_files({
			cwd = "~/.myConfig/nvim",
			no_ignore = true,
			prompt_title = title3,
		})
	end, { desc = title3 })

	local title4 = "Find config files"
	vim.keymap.set("n", "<leader>vE", function()
		builtin.find_files({
			cwd = "~/.myConfig",
			no_ignore = true,
			prompt_title = title4,
		})
	end, { desc = title4 })
    end,
  },
}
