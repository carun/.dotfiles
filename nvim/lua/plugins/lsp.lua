-- Language servers. Neovim 0.11 has LSP built in; nvim-lspconfig supplies
-- the per-server defaults and mason installs servers under
-- ~/.local/share/nvim/mason (no sudo, nothing system-wide).
--
-- Built-in 0.11 maps, active once a server attaches:
--   K hover, grn rename, gra code action, grr references, gri implementation,
--   gO document symbols, <C-]> definition (via tagfunc), [d / ]d diagnostics.

-- Installed by mason on first start. Add more with :Mason.
local mason_servers = {
  "bashls", -- bash
  "clangd", -- C/C++ (needs compile_commands.json, e.g. cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON)
  "lua_ls", -- Lua, for editing this config
  "pyright", -- Python
  "serve_d", -- D
  "ts_ls", -- TypeScript/JavaScript
}

-- Already on this machine, so enabled directly rather than installed by mason.
local system_servers = {
  gopls = "gopls",
  ruff = "ruff",
}

return {
  -- Lua completion/types for the Neovim API while editing this config.
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
        signs = true,
      })

      -- Advertise blink.cmp's completion capabilities to every server.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
      })

      -- Installs mason_servers and enables every mason-installed server.
      require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
        automatic_enable = true,
      })

      for server, bin in pairs(system_servers) do
        if vim.fn.executable(bin) == 1 then
          vim.lsp.enable(server)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("dotfiles-lsp", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lR", "<cmd>FzfLua lsp_references<cr>", "References")
          map("<leader>li", "<cmd>FzfLua lsp_implementations<cr>", "Implementations")
          map("<leader>lt", vim.lsp.buf.type_definition, "Type definition")
          map("<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
          end, "Toggle inlay hints")

          -- :A switches between header and source, like a.vim did.
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "clangd" then
            vim.api.nvim_buf_create_user_command(buf, "A", "LspClangdSwitchSourceHeader", {})
          end
        end,
      })
    end,
  },
}
