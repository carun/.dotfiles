-- Filetype detection and autocmds ported from ~/.vimrc.
vim.filetype.add({
  extension = {
    ad = "asciidoctor",
    di = "d",
    val = "valgrind",
    st = "strace",
    jelly = "html",
    proto = "proto",
  },
  pattern = {
    [".*gdb.*"] = { "gdb", { priority = -10 } },
  },
})

local group = vim.api.nvim_create_augroup("dotfiles", { clear = true })
local au = function(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend("force", { group = group }, opts))
end

au({ "BufRead", "BufNewFile" }, { pattern = "*.log", command = "set syntax=log" })
au({ "BufRead", "BufNewFile" }, { pattern = "*.md", command = "setlocal textwidth=120" })
au({ "BufRead", "BufNewFile" }, { pattern = "*.ad", command = "setlocal textwidth=100" })
au("FileType", { pattern = "gitcommit", command = "setlocal textwidth=80 spell" })

-- Return to the last cursor position when reopening a file.
au("BufReadPost", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "gitcommit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Briefly highlight yanked text.
au("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})
