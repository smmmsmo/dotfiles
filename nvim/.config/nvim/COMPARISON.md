# Neovim Configuration Comparison
## TypeCraft-Dev vs Your LazyVim Setup

---

## KEY DIFFERENCES

### 1. **Base Framework**
- **TypeCraft-Dev**: Bare-bones Lazy.nvim setup (manual configuration)
- **Your Setup**: LazyVim distribution (pre-configured framework with defaults)

**Winner**: Your setup is more feature-rich out of the box. LazyVim includes many modern features TypeCraft doesn't have.

---

## WHAT YOU'RE MISSING (Worth Adding)

### 🔧 **1. Oil.nvim - File Explorer**
TypeCraft uses Oil.nvim for file navigation (press `-` to browse files like a buffer)

**Status**: ❌ You don't have this
**Should you add it?**: ⚠️ Optional - LazyVim already has Neo-tree which is more feature-rich

```lua
-- TypeCraft's Oil setup
return {
  "stevearc/oil.nvim",
  dependencies = {
    { "echasnovski/mini.icons", lazy = false },
    { "nvim-tree/nvim-web-devicons" }
  },
  config = function()
    local oil = require("oil")
    oil.setup()
    vim.keymap.set("n", "-", oil.toggle_float, {})
  end,
  lazy = false,
}
```

---

### 🧪 **2. Vim-Test - Test Runner**
Run tests directly from Neovim with tmux integration

**Status**: ❌ You don't have this
**Should you add it?**: ✅ YES if you write tests regularly

```lua
-- TypeCraft's vim-test setup
return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
    vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
    vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
    vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
    vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
    vim.cmd("let test#strategy = 'vimux'")
  end,
}
```

**Keybindings**:
- `<leader>t` - Run test nearest to cursor
- `<leader>T` - Run entire test file
- `<leader>a` - Run entire test suite
- `<leader>l` - Re-run last test
- `<leader>g` - Visit last test file

---

### ⚙️ **3. Custom Vim Options**
TypeCraft has specific editor settings you might want

**Status**: ⚠️ Partially different
**Your setup**: Uses LazyVim defaults (which are good)

```lua
-- TypeCraft's vim-options.lua
vim.cmd("set expandtab")       -- Use spaces instead of tabs
vim.cmd("set tabstop=2")       -- Tab = 2 spaces
vim.cmd("set softtabstop=2")   -- Soft tab = 2 spaces
vim.cmd("set shiftwidth=2")    -- Indent = 2 spaces
vim.g.mapleader = " "          -- Space as leader key

vim.opt.swapfile = false       -- Disable swap files
vim.wo.number = true           -- Show line numbers

-- Clear search highlighting
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
```

**Should you add it?**: ⚠️ Optional - LazyVim already sets sensible defaults

---

### 🎨 **4. Transparent Background**
TypeCraft uses Catppuccin with transparent background

**Your setup**: Has multiple themes but no transparency configured

```lua
-- TypeCraft's catppuccin setup
return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        transparent_background = true,  -- This is the key difference
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
```

---

## WHAT YOU HAVE THAT TYPECRAFT DOESN'T

### ✨ **LazyVim Advantages**

1. **Better UI Components**
   - Which-key integration (keyboard shortcut hints)
   - Better statusline (lualine pre-configured)
   - Dashboard/starter screen
   - Better notifications (snacks.nvim)

2. **More Built-in Features**
   - Telescope fuzzy finder (better than basic search)
   - Git integration (gitsigns, fugitive)
   - Advanced LSP features
   - Neo-tree file explorer
   - Better terminal integration (snacks terminal)
   - Flash.nvim for quick navigation

3. **Better Plugin Management**
   - Automatic lazy loading
   - Health checks
   - Plugin update notifications
   - Better error handling

4. **Modern Keybindings**
   - More intuitive defaults
   - Better organized with which-key
   - More features mapped by default

---

## CONFIGURATION STYLE DIFFERENCES

### TypeCraft Setup:
```
nvim/
├── init.lua                    (bootstraps lazy.nvim)
├── lua/
│   ├── vim-options.lua        (editor settings)
│   ├── plugins.lua            (empty - returns {})
│   └── plugins/               (individual plugin configs)
│       ├── catppuccin.lua
│       ├── completions.lua
│       ├── lsp-config.lua
│       └── ...
```

### Your LazyVim Setup:
```
nvim/
├── init.lua                    (loads config.lazy)
├── lua/
│   ├── config/
│   │   ├── lazy.lua           (bootstrap + LazyVim setup)
│   │   ├── options.lua        (custom options)
│   │   ├── keymaps.lua        (custom keymaps)
│   │   └── autocmds.lua       (autocommands)
│   └── plugins/               (plugin overrides/additions)
│       ├── tmux-navigation.lua
│       ├── theme.lua
│       └── ...
```

---

## RECOMMENDATIONS

### ✅ **ADD THESE** (High Value):

1. **vim-test + vimux** - If you run tests frequently
2. **Custom keybinding**: `<leader>h` to clear search highlights (LazyVim doesn't have this by default)

### ⚠️ **CONSIDER THESE** (Medium Value):

1. **Oil.nvim** - If you prefer buffer-like file navigation (but Neo-tree is already great)
2. **Transparent background** - Personal preference for aesthetics

### ❌ **DON'T ADD THESE** (Already have better):

1. Manual LSP config - LazyVim handles this better
2. Manual completion setup - LazyVim's is more advanced
3. Basic treesitter setup - LazyVim's is more comprehensive

---

## SUMMARY

**Your LazyVim setup is BETTER than TypeCraft's** for most users because:
- More features out of the box
- Better organized
- Easier to maintain
- Modern best practices
- Better documentation

**What you should steal from TypeCraft**:
1. ✅ Tmux navigation (already added)
2. ✅ vim-test setup (if you write tests)
3. ⚠️ Clear search highlight keybinding (`<leader>h`)

**What to keep from LazyVim**:
- Everything else! It's more feature-complete and well-maintained.
