-- Bootstrap lazy.nvim, then load every spec under lua/plugins/.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  -- Colorscheme to use while plugins are still being installed on first run.
  install = { colorscheme = { "oxocarbon", "habamax" } },
  -- lazy-lock.json is committed to the dotfiles repo; run :Lazy update to
  -- bump versions and :Lazy restore to go back to the pinned ones.
  checker = { enabled = false },
  change_detection = { notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
