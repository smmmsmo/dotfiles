-- ============================================================================
-- Neovim Options Configuration
-- ============================================================================
-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- ============================================================================
-- UI
-- ============================================================================
opt.number = true                   -- Show line numbers
opt.relativenumber = false          -- Relative line numbers off (change to true if preferred)
opt.cursorline = true               -- Highlight current line
opt.signcolumn = "yes"              -- Always show sign column
opt.colorcolumn = "100"             -- Show column guide at 100 chars
opt.termguicolors = true            -- True color support
opt.showmode = false                -- Don't show mode (lualine shows it)
opt.showcmd = true                  -- Show command in status line
opt.cmdheight = 1                   -- Command line height
opt.laststatus = 3                  -- Global statusline
opt.pumheight = 10                  -- Popup menu height
opt.pumblend = 10                   -- Popup menu transparency
opt.winblend = 0                    -- Window transparency
opt.splitbelow = true               -- Horizontal splits below
opt.splitright = true               -- Vertical splits right
opt.splitkeep = "screen"            -- Keep text on screen when splitting
opt.scrolloff = 8                   -- Lines to keep above/below cursor
opt.sidescrolloff = 8               -- Columns to keep left/right of cursor
opt.wrap = false                    -- Don't wrap lines
opt.linebreak = true                -- Wrap at word boundaries (when wrap is on)
opt.list = true                     -- Show invisible characters
opt.listchars = {                   -- Invisible character display
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "→",
  precedes = "←",
}
opt.fillchars = {
  foldopen = "▼",
  foldclose = "▶",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- ============================================================================
-- Editing
-- ============================================================================
opt.expandtab = true                -- Use spaces instead of tabs
opt.tabstop = 2                     -- Tab = 2 spaces
opt.shiftwidth = 2                  -- Indent = 2 spaces
opt.softtabstop = 2                 -- Tab key = 2 spaces
opt.smartindent = true              -- Smart auto-indenting
opt.shiftround = true               -- Round indent to multiple of shiftwidth
opt.autoindent = true               -- Copy indent from current line
opt.breakindent = true              -- Indent wrapped lines
opt.virtualedit = "block"           -- Allow cursor beyond end of line in visual block
opt.formatoptions = "jcroqlnt"      -- Format options

-- ============================================================================
-- Search
-- ============================================================================
opt.ignorecase = true               -- Ignore case in search
opt.smartcase = true                -- Override ignorecase if uppercase
opt.hlsearch = true                 -- Highlight search results
opt.incsearch = true                -- Incremental search
opt.inccommand = "nosplit"          -- Preview substitutions

-- ============================================================================
-- Completion
-- ============================================================================
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"  -- Command-line completion mode
opt.wildignorecase = true           -- Ignore case in wildmenu

-- ============================================================================
-- Files & Backup
-- ============================================================================
opt.undofile = true                 -- Persistent undo
opt.undolevels = 10000              -- Maximum undo levels
opt.backup = false                  -- No backup files
opt.writebackup = false             -- No backup before overwriting
opt.swapfile = false                -- No swap files
opt.autowrite = true                -- Auto save before commands like :next
opt.autoread = true                 -- Auto reload files changed outside vim
opt.confirm = true                  -- Confirm before closing unsaved files
opt.hidden = true                   -- Allow hidden buffers

-- ============================================================================
-- Performance
-- ============================================================================
opt.updatetime = 200                -- Faster completion (default 4000ms)
opt.timeoutlen = 300                -- Faster key sequence completion
opt.ttimeoutlen = 10                -- Faster escape key
opt.redrawtime = 1500               -- Time for redrawing
opt.lazyredraw = false              -- Don't redraw during macros (can cause issues)

-- ============================================================================
-- Clipboard
-- ============================================================================
opt.clipboard = "unnamedplus"       -- Use system clipboard

-- ============================================================================
-- Mouse
-- ============================================================================
opt.mouse = "a"                     -- Enable mouse in all modes
opt.mousemoveevent = true           -- Enable mouse move events

-- ============================================================================
-- Folding
-- ============================================================================
opt.foldlevel = 99                  -- Start with all folds open
opt.foldlevelstart = 99             -- Start with all folds open
opt.foldenable = true               -- Enable folding
opt.foldcolumn = "1"                -- Show fold column
opt.foldmethod = "expr"             -- Use treesitter for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ============================================================================
-- Spelling
-- ============================================================================
opt.spell = false                   -- Disable spell checking by default
opt.spelllang = { "en_us" }         -- Spell check language

-- ============================================================================
-- Session
-- ============================================================================
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- ============================================================================
-- Grep
-- ============================================================================
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"        -- Use ripgrep for grep

-- ============================================================================
-- Providers
-- ============================================================================
-- Disable unused providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- ============================================================================
-- Leader Key
-- ============================================================================
vim.g.mapleader = " "               -- Space as leader
vim.g.maplocalleader = "\\"         -- Backslash as local leader

-- ============================================================================
-- Netrw (File Explorer - disabled since we use neo-tree)
-- ============================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================================================
-- Markdown
-- ============================================================================
vim.g.markdown_recommended_style = 0

-- ============================================================================
-- Root Detection
-- ============================================================================
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
