vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("options")
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" }, {
  change_detection = { notify = false },
})

local google_options_file = vim.fn.expand("~/.myConfig/vim_custom_google.vim")
-- if vim.fn.filereadable(google_options_file) == 1 then
--   vim.cmd("source " .. google_options_file)
-- end
