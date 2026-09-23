-- Navigation: fuzzy finding, file tree, symbol outline.
return {
  -- fzf-lua with the "fzf-vim" profile, so the fzf.vim commands you know
  -- (:Files, :GFiles, :Buffers, :Rg, :Lines, :BLines, :History, ...) still work.
  -- Install ripgrep and fd-find for much faster :Rg and :Files.
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua", "Files", "GFiles", "Buffers", "Rg", "RG", "Lines", "BLines", "History", "Commits", "BCommits", "Tags", "BTags", "Helptags", "Commands" },
    opts = { "fzf-vim" },
    keys = {
      { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader><leader>", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>f.", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },
    },
  },

  -- NERDTree replacement, same `tr` toggle.
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = { { "tr", "<cmd>NvimTreeToggle<cr>", desc = "File tree" } },
    opts = {
      view = { width = 35 },
      renderer = { group_empty = true },
      update_focused_file = { enable = true }, -- highlight the current buffer's file
    },
  },

  -- Tagbar replacement, same `tt` toggle. Uses LSP/Treesitter, no ctags needed.
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    cmd = { "AerialToggle" },
    keys = { { "tt", "<cmd>AerialToggle! right<cr>", desc = "Symbol outline" } },
    opts = {},
  },
}
