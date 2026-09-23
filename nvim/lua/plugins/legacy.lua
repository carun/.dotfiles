-- Plugins carried over from the vimrc that still earn their place in Neovim.
return {
  -- <F4> build, <F5> build check, as in the vimrc.
  {
    "johnsyweb/vim-makeshift",
    lazy = false,
    keys = {
      { "<F4>", ":<C-U>MakeshiftBuild<CR>", desc = "Build" },
      { "<F5>", ":<C-U>MakeshiftBuild check<CR>", desc = "Build check" },
    },
  },

  {
    "will133/vim-dirdiff",
    cmd = "DirDiff",
    init = function()
      vim.g.DirDiffExcludes = "*.git,*.class,*.exe,.*.swp,*.hg,*.o,*.so"
      vim.g.DirDiffIgnore = "Id:,Revision:,Date:"
      vim.g.DirDiffSort = 1
      vim.g.DirDiffWindowSize = 7
      vim.g.DirDiffIgnoreCase = 0
    end,
  },

  -- `syntax=log` for *.log files.
  { "mtdl9/vim-log-highlighting", lazy = false },

  { "habamax/vim-asciidoctor", lazy = false },
}
