-- Completion and formatting.
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt fuzzy matcher binary
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- Vim-style: <C-n>/<C-p> to move, <C-y> to accept, <C-e> to cancel,
      -- <Tab>/<S-Tab> to jump through snippet placeholders.
      keymap = {
        preset = "default",
        -- Keep the vimrc's insert-mode <C-k> (delete to end of line).
        ["<C-k>"] = { "fallback" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  -- Formatting with external tools. Nothing formats on save by default
  -- (the vimrc had that commented out); use <leader>lf or :FormatOnSave.
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo", "FormatOnSave" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer/selection",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        go = { "gofmt" },
        python = { "ruff_format" },
        sh = { "shfmt" },
      },
      format_on_save = function()
        if vim.g.format_on_save then
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
      end,
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_create_user_command("FormatOnSave", function()
        vim.g.format_on_save = not vim.g.format_on_save
        vim.notify("Format on save: " .. (vim.g.format_on_save and "on" or "off"))
      end, { desc = "Toggle format on save" })
    end,
  },
}
