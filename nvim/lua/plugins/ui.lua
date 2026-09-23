-- Look and feel.
return {
  -- Moonfly, a dark theme. Note the scheme is named "moonfly" (from
  -- colors/moonfly.vim), not after the repo. To go back to oxocarbon, swap the
  -- repo to "nyoom-engineering/oxocarbon.nvim" and the scheme to "oxocarbon".
  {
    "bluz71/vim-moonfly-colors",
    lazy = false,
    priority = 1000, -- load before everything else so highlights are right
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("moonfly")
    end,
  },

  -- The old vim colorschemes (Tomorrow-Night-Bright, ir_black, ...) are still
  -- available via :colorscheme, they just lack Treesitter/LSP highlight groups.
  { "flazz/vim-colorschemes", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "auto", globalstatus = true },
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },

  -- Pops up the available keys after a pause, e.g. after pressing <leader>.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>a", group = "Claude" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
      },
    },
  },

  -- Highlight other uses of the word under the cursor (LSP/Treesitter aware).
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({ delay = 200 })
    end,
  },

  -- Shared dependency of claudecode.nvim; only the bits we use are enabled.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true }, -- disable heavy features on huge files
      input = { enabled = true },
      notifier = { enabled = true },
      terminal = { enabled = true },
    },
  },
}
