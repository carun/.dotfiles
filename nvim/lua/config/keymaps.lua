-- Keymaps ported from ~/.vimrc. `map` in vim covers normal, visual and
-- operator-pending modes, which is mode "" here. Plugin-specific maps
-- (tt, tr, F4/F5 build) live with their plugin specs under lua/plugins/.
local map = vim.keymap.set

-- Save / quit
map({ "", "i" }, "<C-Space>", "<Esc>:x<cr>", { desc = "Save and quit" })
map({ "", "i" }, "<C-@>", "<Esc>:x<cr>", { desc = "Save and quit" })
map({ "", "i" }, "<C-s>", "<Esc>:wa<cr>", { desc = "Save all" })

-- Tabs
map("n", "<C-i>", "gt", { desc = "Next tab" })
map("n", "<S-Tab>", "gT", { desc = "Previous tab" })
map("", "<F6>", ":tabe ", { desc = "Open file in new tab" })

-- Diff
map("", "<C-d>", ":diffthis<cr>", { desc = "diffthis" })
map("", "<C-q>", ":diffoff!<cr>", { desc = "diffoff!" })

-- Formatting / editing
map("", "Y", "gqgq", { desc = "Format line" })
map("", "Q", "i<cr><esc>l", { desc = "Split line at cursor" })
map("", "<F2>", ":wn<cr>", { desc = "Write and edit next file" })
map("", "<F7>", ":se nu!<cr>", { desc = "Toggle line numbers" })
map("", "<F8>", ":se paste!<cr>", { desc = "Toggle paste" })
map("", "<F9>", [[:%s,\s\+$,,<cr>]], { desc = "Strip trailing whitespace" })
map("", "<F10>", ":se wrap!<cr>", { desc = "Toggle wrap" })
map("", "<F11>", ":%!xxd<cr>", { desc = "Hex dump" })
map("", "<F12>", ":%!xxd -r<cr>", { desc = "Undo hex dump" })

-- Quickfix
map("", "cn", ":cnext<cr>", { desc = "Next quickfix" })
map("", "cp", ":cprev<cr>", { desc = "Previous quickfix" })
map("", "co", ":cope<cr><c-w>J", { desc = "Open quickfix" })
map("", "cc", ":ccl<cr>", { desc = "Close quickfix" })

-- Jump to tag under cursor in a new tab
map("", "<C-\\>", ':tab split<CR>:exec("tag ".expand("<cword>"))<CR>', { desc = "Tag in new tab" })

-- Window navigation with Alt+hjkl (vim needed <Esc>h; Neovim sees <M-h>).
-- Also works from terminal mode, so you can hop out of the Claude window.
for _, k in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<M-" .. k .. ">", "<C-w>" .. k, { desc = "Window " .. k })
  map("t", "<M-" .. k .. ">", "<C-\\><C-n><C-w>" .. k, { desc = "Window " .. k })
end

-- Emacs-style insert mode editing
map("i", "<C-a>", "<C-o>I")
map("i", "<C-e>", "<C-o>A")
map("i", "<C-k>", "<C-o>D")
map("i", "<C-y>", "<C-o>p")
map("i", "<M-b>", "<C-o>b")
map("i", "<M-f>", "<C-o>w")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Diagnostics (LSP errors/warnings)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Print the name of the enclosing function, as in the vimrc.
vim.cmd([[
fun! ShowFuncName()
    let lnum = line(".")
    let col = col(".")
    echohl ModeMsg
    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
    echohl None
    call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
nmap \ :call ShowFuncName()<cr>

ab cO Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab FIXME FIXME: Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab TODO TODO: Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab aU @author Arun Chandrasekaran <arun@cotanlabs.com>
cnoreabbrev W w
cnoreabbrev m make
cnoreabbrev qm !qmake mode=debug
]])
