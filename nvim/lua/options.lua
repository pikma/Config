-- Persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Folding defaults (treesitter.lua overrides foldmethod/foldexpr globally)
vim.opt.foldlevel = 99
vim.opt.foldenable = true

vim.opt.showcmd = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"
vim.opt.wildignore = "*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.class,*.pyc"

vim.opt.spelllang = "en"
vim.opt.spell = false

vim.opt.mouse = "n"
vim.opt.backspace = "indent,eol,start"
vim.opt.number = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.hidden = false

vim.opt.formatoptions = "croq"
vim.opt.textwidth = 80

vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.termguicolors = true
vim.opt.background = "light"

vim.opt.colorcolumn = "+1"
vim.opt.scrolloff = 3
vim.opt.showmatch = true

vim.opt.shada = "'1000,<50,s10,h"
vim.opt.backupcopy = "yes"

-- Disable matchparen highlighting
vim.g.loaded_matchparen = 1

local autocmd = vim.api.nvim_create_autocmd
local ft = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

-- Remove trailing whitespace on save (restores cursor position)
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.opt.binary:get() then
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[silent! %s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

-- Jump to last cursor position when opening a file
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 1 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Python
autocmd("FileType", {
  group = ft,
  pattern = "python",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.textwidth = 100
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.fileformat = "unix"
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

autocmd("FileType", {
  group = ft,
  pattern = "conf",
  callback = function() vim.opt_local.foldmethod = "indent" end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.go",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 0
    vim.opt_local.tabstop = 2
    vim.opt_local.textwidth = 100
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.proto",
  callback = function() vim.opt_local.foldmethod = "indent" end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.tex",
  callback = function()
    vim.opt_local.formatoptions = "tcoq"
    vim.opt_local.spell = true
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.txt",
  callback = function() vim.opt_local.formatoptions = "tcoq" end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
    vim.opt_local.textwidth = 100
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.py",
  callback = function() vim.opt_local.textwidth = 100 end,
})

-- Filetype overrides
autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.sage",
  callback = function() vim.bo.filetype = "python" end,
})
autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = "*.hrf",
  callback = function() vim.bo.filetype = "prolog" end,
})
autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = { "*.owl", "*.xul", "*.rdf" },
  callback = function() vim.bo.filetype = "xml" end,
})
autocmd({ "BufRead", "BufNewFile" }, {
  group = ft,
  pattern = { "*.plot", "*.plt" },
  callback = function() vim.bo.filetype = "gnuplot" end,
})

-- Help: follow links with Enter
autocmd("FileType", {
  group = ft,
  pattern = "help",
  callback = function()
    vim.keymap.set("n", "<CR>", "<C-]>", { buffer = true })
  end,
})

-- Custom comment strings for Comment.nvim
autocmd("FileType", {
  group = ft,
  pattern = "textpb",
  callback = function() vim.opt_local.commentstring = "# %s" end,
})
autocmd("FileType", {
  group = ft,
  pattern = "gcl",
  callback = function() vim.opt_local.commentstring = "// %s" end,
})

-- Large file handling (>10MB): disable heavy features
local large_file_size = 1024 * 1024 * 10
autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args)
    local size = vim.fn.getfsize(args.match)
    if size > large_file_size or size == -2 then
      vim.opt.eventignore:append("FileType")
      vim.opt_local.bufhidden = "unload"
      vim.opt_local.buftype = "nowrite"
      vim.opt_local.undolevels = -1
      vim.notify("File >10MB: syntax and undo disabled", vim.log.levels.WARN)
    end
  end,
})
