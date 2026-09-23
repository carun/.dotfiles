-- Options ported from ~/.vimrc. Neovim already defaults to nocompatible,
-- hlsearch, incsearch, autoread, backspace=indent,eol,start, utf-8, ruler,
-- showcmd, syntax on and filetype plugin indent on, so those are left out.
local o = vim.opt

o.mouse = "n"
o.autoindent = true
o.cindent = true
o.cinoptions = ":0,p0,t0,(0,g0,N-s"
o.cinwords = "if,else,while,do,for,switch,case"
o.confirm = true
o.formatoptions = "tcqr"
o.keymodel = "startsel"
o.smartcase = true
o.ignorecase = false -- smartcase only takes effect with ignorecase; kept as in vimrc
o.wildmode = "longest,full"
o.textwidth = 0
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.scrolloff = 1
o.wrap = true
o.tags = "tags"
o.foldlevel = 1
o.tabpagemax = 100
o.sessionoptions:remove("options")
o.fileencoding = "utf-8"
o.background = "dark"
o.completeopt = "menuone,menu,longest"

-- Neovim additions.
o.number = false -- <F7> toggles, as in vim
o.signcolumn = "yes" -- stops the text shifting when git/LSP signs appear
o.undofile = true -- persistent undo in ~/.local/state/nvim/undo
o.updatetime = 300 -- faster CursorHold for highlights and gitsigns
o.splitright = true
o.inccommand = "split" -- live preview of :s substitutions
o.termguicolors = true
o.laststatus = 3 -- one statusline across splits

if vim.o.diff then
  o.readonly = false
end
