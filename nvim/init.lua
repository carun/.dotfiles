-- Neovim entry point. ~/.config/nvim is a symlink to ~/.dotfiles/nvim.
--
--   lua/config/  options, keymaps and autocmds ported from ~/.vimrc
--   lua/plugins/ one file per area, each returning lazy.nvim specs

-- Leader must be set before lazy.nvim loads any plugin mappings.
-- Space rather than the default backslash, which the vimrc uses for ShowFuncName.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
