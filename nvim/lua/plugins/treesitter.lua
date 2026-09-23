-- Treesitter: accurate syntax highlighting and indentation.
-- Parsers are compiled locally with gcc on first use.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The `main` branch rewrite needs the tree-sitter CLI; `master` is
    -- feature-frozen but stable on Neovim 0.11 and only needs a C compiler.
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "c", "cmake", "cpp", "css", "d", "diff", "dockerfile", "fish",
        "gitcommit", "go", "gomod", "gosum", "html", "javascript", "json", "lua",
        "make", "markdown", "markdown_inline", "nim", "proto", "python", "query",
        "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true, -- install missing parsers when opening a new filetype
      highlight = {
        enable = true,
        -- Skip very large files, where regex highlighting is faster.
        disable = function(_, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 1024 * 1024
        end,
      },
      -- Keep the vimrc's cindent/cinoptions for C and C++.
      indent = { enable = true, disable = { "c", "cpp" } },
    },
  },
}
