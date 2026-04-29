return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>e" },
      { "<leader>,e" },
      { "<leader>,d" },
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
      vim.keymap.set("n", "<leader>e", builtin.find_files)
      vim.keymap.set("n", "<leader>,e", builtin.oldfiles)
      -- Find files in the same directory as the current file (replaces FzfSameDirectory)
      vim.keymap.set("n", "<leader>,d", function()
        builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
      end)
    end,
  },
}
