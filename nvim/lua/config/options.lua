local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.background = "dark"

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitright = true
opt.splitbelow = true

opt.updatetime = 250
opt.timeoutlen = 400
opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12
opt.winblend = 0
opt.pumblend = 0

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.fillchars = { eob = " ", fold = " ", foldsep = " " }
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

opt.shortmess:append("I")
opt.laststatus = 3

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable some built-in providers we don't use.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
