# Setup

```
git clone https://github.com/carun/.dotfiles && cd .dotfiles && ./install.sh
```

# Misc

## Map copilot key to right control on Asus Vivobook14

```
$ sudo apt install keyd
$ sudo cat /etc/keyd/default.conf
[ids]
0001:0001:09b4e68d

[main]
leftmeta+leftshift+f23 = rightcontrol
```


# Neovim

`nvim/` is linked to `~/.config/nvim`. Plugins are managed by
[lazy.nvim](https://github.com/folke/lazy.nvim) and pinned in `nvim/lazy-lock.json`
(`:Lazy update` to bump, `:Lazy restore` to return to the pins). Language servers
live in `:Mason`. Options and keymaps from `.vimrc` are ported in `nvim/lua/config/`.

Recommended: `sudo apt install ripgrep fd-find` for fast grep and file search.

| Keys | Action |
|---|---|
| `<Space>` | Leader; pause after it for a which-key menu |
| `<C-p>`, `:Files`, `:Rg`, `:Buffers` | fzf-lua (fzf.vim compatible commands) |
| `<leader>fg` / `<leader>fw` | Live grep / grep word under cursor |
| `tr` / `tt` | File tree / symbol outline (NERDTree / Tagbar replacements) |
| `gd`, `K`, `grr`, `grn`, `gra` | Definition, hover, references, rename, code action |
| `<leader>lf` | Format (`:FormatOnSave` toggles format on save) |
| `:A` | Switch header/source (clangd) |
| `]h` `[h` `<leader>gs` `<leader>gb` | Git hunks: next, prev, stage, blame |
| `<M-h/j/k/l>` | Move between windows, including out of the terminal |

## Claude Code ([claudecode.nvim](https://github.com/coder/claudecode.nvim))

| Keys | Action |
|---|---|
| `<leader>ac` | Toggle Claude in a right split |
| `<leader>ar` / `<leader>aC` | Resume a session / continue the last one |
| `<leader>as` (visual) | Send selection to Claude |
| `<leader>ab` | Add current file to Claude's context |
| `<leader>aa` / `<leader>ad` | Accept / reject a proposed diff (or `:w` / `:q`) |

Claude can also run in a separate tmux pane: start `claude` there and run `/ide`
to connect it to this Neovim.
