-- Insert mode escape
vim.keymap.set("i", "jk", "<Esc>")

-- Terminal mode escape
vim.keymap.set("t", "JK", "<C-\\><C-n>")

-- Non-breaking space → regular space (Mac alt-space and UTF-8 0xC2 0xA0)
vim.cmd([[noremap  <Char-160> <Space>]])
vim.cmd([[inoremap <Char-160> <Space>]])

-- Disable mouse click (keeps scrolling)
vim.keymap.set({ "n", "i" }, "<LeftMouse>", "<Nop>")

-- Edit/source init.lua
vim.keymap.set("n", "<leader>ve", ":e $MYVIMRC<CR>G")
vim.keymap.set("n", "<leader>vs", ":source $MYVIMRC<CR>")

-- Wrap word in quotes
vim.keymap.set("n", '<leader>"', 'viw<esc>a"<esc>hbi"<esc>lel')
vim.keymap.set("n", "<leader>'", "viw<esc>a'<esc>hbi'<esc>lel")
vim.keymap.set("v", '<leader>"', [[<esc>a"<esc>`<i"<esc>lel]])
vim.keymap.set("v", "<leader>'", [[<esc>a'<esc>`<i'<esc>lel]])

-- Save from insert mode (type :w + Enter while in insert mode)
vim.keymap.set("i", ":w<CR>", "<Esc>:w<CR>")

-- Misc code formatting (insert closing brace comment)
vim.keymap.set("n", "<leader>n", "I}  // <esc>f{xj")

-- Redraw
vim.keymap.set("n", "<leader>!", ":redraw!<CR>")

-- Sort paragraph or visual selection
vim.keymap.set("n", "<leader>sp", "vip!LC_ALL=C sort -u<CR>")
vim.keymap.set("v", "<leader>sp", "!LC_ALL=C sort -u<CR>")

-- Insert proto #include for current file
vim.cmd([[nnoremap <leader>i I<cr><esc>ki#include "<c-r>=substitute(substitute(expand("%:p"), ".*google3/", "", ""), "\.proto$", ".proto.h", "")<cr>"<esc>yyu]])

-- Fold level
vim.keymap.set("n", "zC", ":set foldlevel=2<CR>")

-- Quickfix window spanning all panes
vim.keymap.set("n", "<leader>ge", ":botright cwindow<CR>")

-- Align next line's first non-space under cursor (uses ù as a temp marker)
vim.keymap.set("n", "<leader>j", "iù<esc>j^0d^kvtùyj^Pv0r kfùxj")

-- Vimux
vim.keymap.set("n", "<leader>sh", ":VimuxPromptCommand<CR>")
vim.keymap.set("n", "<leader>sl", ":VimuxRunLastCommand<CR>")
vim.keymap.set("n", "<leader>sz", ":VimuxZoomRunner<CR>")

-- Show diagnostics in location list
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setqflist, { desc = 'Open diagnostics list' })

-- Search within quickfix / location list files
vim.cmd([[command! -nargs=1 Qgrep execute 'vimgrep /' . <q-args> . '/ `[v:val.fname for v:val in getqflist()]`' | copen]])
vim.cmd([[command! -nargs=1 Lgrep execute 'lvimgrep /' . <q-args> . '/ `[v:val.fname for v:val in getloclist(0)]`' | lopen]])

-- List files in current file's directory in quickfix / location list
vim.cmd([[command! Qdir call setqflist(map(glob(expand('%:p:h') . '/*', 0, 1), '{ "filename": v:val }')) | copen]])
vim.cmd([[command! Ldir call setloclist(0, map(glob(expand('%:p:h') . '/*', 0, 1), '{ "filename": v:val }')) | lopen]])
