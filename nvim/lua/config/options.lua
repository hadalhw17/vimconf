-- Editor options. Visual options (colorscheme, borders, signs) live in
-- config/ui.lua; plugin options live in their lazy.nvim specs.

local o = vim.o
local opt = vim.opt

vim.g.mapleader = " "

-- Files
o.swapfile = false
o.undofile = true -- persistent undo across sessions
o.autoread = true
o.confirm = true
o.hidden = true
opt.wildignore:append({ "*.pyc", "*.swp" })

-- UI basics
o.title = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.laststatus = 3 -- single global status line (lualine)
o.showmode = true
o.showcmd = true
o.errorbells = false
o.visualbell = true
o.mouse = "a"
o.guifont = "FiraCode Nerd Font:h10"

-- Wrapping and text rendering
o.textwidth = 80
o.wrap = true
o.smoothscroll = true -- scroll by screen line so tall wrapped lines display partially
o.linebreak = true
o.scrolloff = 5
o.sidescrolloff = 5
o.listchars = "tab:»·,trail:·,extends:→,precedes:←,nbsp:+,space:·"

-- Indentation: hard tabs, width 4
o.expandtab = false
o.shiftwidth = 4
o.tabstop = 4
o.shiftround = true
o.autoindent = true
o.smartindent = true
o.cindent = true
o.copyindent = true
o.joinspaces = false

-- Search
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true
o.showmatch = true
opt.matchpairs:append("<:>")

-- Splits
o.splitright = true
o.splitbelow = true

-- Clipboard
o.clipboard = "unnamed"

-- Folding: buffers with a treesitter parser get structural expr folds (see
-- the nvim-treesitter spec in plugins.lua); everything else stays manual.
-- Fold summary lines use Neovim's native syntax-highlighted foldtext.
o.foldmethod = "manual"
o.foldlevelstart = 99
