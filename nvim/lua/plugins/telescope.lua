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
			{ "<leader>e" },
			{ "<leader>E" },
			{ "<leader>,h" },
			{ "<leader>,d" },
			{ "<leader>,/" },
			{ "<leader>,?" },
			{ "<leader>,g" },
			{ "<leader>,c" },
			{ "<leader>,j" },
			{ "<leader>,J" },
			{ "<leader>,m" },
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

			vim.keymap.set("n", "<leader>e", builtin.find_files, { desc = "[E]dit file" })

			vim.keymap.set("n", "<leader>E", function()
        builtin.find_files({ no_ignore = true })
      end, { desc = "[E]dit file (including .gitignore)" })

			vim.keymap.set("n", "<leader>,h", builtin.oldfiles, { desc = "Find within [H]istory" })

			vim.keymap.set("n", "<leader>,d", function()
				builtin.find_files({ cwd = vim.fn.expand("%:p:h"), no_ignore = true })
			end, { desc = "Find files in same [D]irectory" })

      vim.keymap.set(
        "n",
        "<leader>/", builtin.current_buffer_fuzzy_find,
        { desc = "[/] Fuzzily search in current buffer]" }
      )

      vim.keymap.set("n", "<leader>,?", builtin.help_tags, { desc = "[S]earch [H]elp" })
      -- vim.keymap.set("n", "<leader>,w", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>,g", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set('n', '<leader>,j', function()
        builtin.find_files({
          prompt_title = "JJ Changed Files in current commit",
          find_command = { "jj", "diff", "--name-only" }
        })
      end, { desc = "[J]j changed files" })
      vim.keymap.set('n', '<leader>,J', function()
        builtin.find_files({
          prompt_title = "JJ Changed Files since main",
          find_command = { "jj", "diff", "--from", "main", "--name-only" }
        })
      end, { desc = "[J]j [C]hanged files" })
      vim.keymap.set("n", "<leader>,m", builtin.keymaps, { desc = "Search key [M]amppings" })
    end,
  },
}
