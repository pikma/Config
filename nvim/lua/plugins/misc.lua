return {
  -- Tmux command runner
  {
    "preservim/vimux",
    init = function()
      vim.g.VimuxOrientation = "h"
    end,
  },

  -- Highlight word under cursor (spacebar)
  "pikma/space-macro",

  -- Editable quickfix list
  "stefandtw/quickfix-reflector.vim",

  -- Directory diff
  "will133/vim-dirdiff",

  -- Rust utilities (:RustFmt etc); syntax handled by treesitter
  {
    "rust-lang/rust.vim",
    init = function()
      -- Disable rust.vim auto-format on save; use LSP format (<leader>=) instead
      vim.g.rustfmt_autosave = 0
    end,
  },
}
