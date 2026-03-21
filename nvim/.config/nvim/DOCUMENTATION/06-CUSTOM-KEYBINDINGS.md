# Custom Keybindings

**Quality-of-life keybindings that enhance your Neovim experience.**

---

## 📖 Overview

This file contains custom keybindings that improve daily workflows. These are carefully chosen shortcuts that don't conflict with LazyVim defaults but add useful functionality.

**Config File:** `~/.config/nvim/lua/plugins/custom-keybindings.lua`

---

## ✅ Installation Status

**Status:** ✅ Installed  
**Active Keybindings:** 1 (with 15+ optional ones available)

---

## 🔑 Active Keybindings

### Clear Search Highlights

| Key | Action | Mode |
|-----|--------|------|
| `<leader>h` | Clear search highlights | Normal |

**Why this is useful:**

When you search with `/` or `?`, Neovim highlights all matches. These highlights persist after your search is done, which can be visually distracting.

**Example:**
```
1. Search for "function": /function
2. All instances light up (yellow highlighting)
3. Press Space + h
4. Highlights disappear
5. Clean, readable code again!
```

---

## 📚 Usage Guide

### Clear Search Highlights

**The Problem:**
```vim
" After searching
/TODO

" Your file now looks like:
# TODO: Fix this     ← highlighted
# TODO: Add tests    ← highlighted
# TODO: Refactor     ← highlighted

" Hard to focus on what you're doing!
```

**The Solution:**
```vim
" Press: Space + h
" Now it looks like:
# TODO: Fix this     ← clean
# TODO: Add tests    ← clean
# TODO: Refactor     ← clean

" Much better!
```

**When to use:**
- After searching for something
- When highlights are distracting
- Before taking a screenshot (clean view!)
- When presenting code to others

---

## 💡 Optional Keybindings

The config file includes **15+ additional keybindings** that are commented out. You can enable any of them by editing the file and uncommenting the lines.

### Available Optional Keybindings

**File Operations:**
- `<leader>w` - Quick save (`:w`)
- `<leader>q` - Quick quit (`:q`)
- `<leader>x` - Save and quit (`:x`)

**Selection:**
- `<C-a>` - Select all text in buffer

**Visual Mode Enhancements:**
- `J` - Move selected lines down
- `K` - Move selected lines up
- `<` - Indent left (keeps selection)
- `>` - Indent right (keeps selection)

**Scrolling Enhancements:**
- `<C-d>` - Scroll down (keep cursor centered)
- `<C-u>` - Scroll up (keep cursor centered)
- `n` - Next search result (centered)
- `N` - Previous search result (centered)

**Clipboard:**
- `<leader>y` - Copy to system clipboard
- `<leader>p` - Paste from system clipboard
- `p` (visual) - Paste without yanking

**Buffer Navigation:**
- `<Tab>` - Next buffer
- `<S-Tab>` - Previous buffer

---

## 🎯 How to Enable Optional Keybindings

**Step 1:** Open the config file
```bash
nvim ~/.config/nvim/lua/plugins/custom-keybindings.lua
```

**Step 2:** Find the keybinding you want

Look for the "ADDITIONAL USEFUL KEYBINDINGS" section. You'll see commented code like:
```lua
-- Quick save with <leader>w
-- vim.keymap.set('n', '<leader>w', ':w<CR>', { 
--   desc = "Quick Save",
--   silent = true 
-- })
```

**Step 3:** Uncomment the lines

Remove the `--` from the beginning of each line:
```lua
-- Quick save with <leader>w
vim.keymap.set('n', '<leader>w', ':w<CR>', { 
  desc = "Quick Save",
  silent = true 
})
```

**Step 4:** Save and reload
```vim
:w          " Save the file
:source %   " Reload config
" Or restart Neovim
```

**Step 5:** Test the keybinding
```
Space + w    " Should save the file
```

---

## 🔥 Recommended Optional Keybindings

If you're unsure which to enable, here are my recommendations:

### For Beginners (Enable These First)

**1. Quick Save**
```lua
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = "Quick Save", silent = true })
```
**Why:** Faster than `:w<Enter>`

**2. Move Lines in Visual Mode**
```lua
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move Down", silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move Up", silent = true })
```
**Why:** Super useful for reorganizing code

**3. Better Indenting (Keep Selection)**
```lua
vim.keymap.set('v', '<', '<gv', { desc = "Indent Left", silent = true })
vim.keymap.set('v', '>', '>gv', { desc = "Indent Right", silent = true })
```
**Why:** Don't lose your selection when indenting

---

### For Intermediate Users

**4. Centered Scrolling**
```lua
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Scroll Down (Centered)", silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Scroll Up (Centered)", silent = true })
```
**Why:** Cursor stays in middle of screen (easier on eyes)

**5. System Clipboard**
```lua
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = "Copy to Clipboard", silent = true })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = "Paste from Clipboard", silent = true })
```
**Why:** Easy sharing between Neovim and other apps

**6. Paste Without Yanking**
```lua
vim.keymap.set('v', 'p', '"_dP', { desc = "Paste Without Yanking", silent = true })
```
**Why:** When you paste over text, don't copy what you replaced

---

## 💡 Pro Tips

### Tip 1: Test Before Committing

When enabling new keybindings, test them thoroughly before relying on them. Some might conflict with your muscle memory.

### Tip 2: Document What You Enable

Add a comment in the config file:
```lua
-- Enabled 2026-03-20: Quick save is amazing!
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = "Quick Save", silent = true })
```

### Tip 3: Check for Conflicts

Before enabling, verify the key isn't already used:
```vim
:map <leader>w
" If it shows existing mapping, choose different key
```

### Tip 4: Learn One at a Time

Don't enable all keybindings at once! Add one, use it for a week, then add another.

### Tip 5: Remove What You Don't Use

After a month, if you haven't used a keybinding, disable it. Less is more!

---

## 🎨 Customization

### Create Your Own Keybindings

Add custom bindings to the same file:

```lua
-- Your custom keybindings here
vim.keymap.set('n', '<leader>cc', ':echo "Hello!"<CR>', {
  desc = "Say Hello",
  silent = true
})
```

### Understanding the Syntax

```lua
vim.keymap.set(
  'n',              -- Mode: 'n'=normal, 'v'=visual, 'i'=insert
  '<leader>h',      -- Key combination
  ':nohlsearch<CR>', -- Command to execute
  {                 -- Options
    desc = "Clear Highlights",  -- Description (shows in which-key)
    silent = true,              -- Don't show command in command line
    noremap = true              -- Non-recursive mapping
  }
)
```

### Common Modes

- `'n'` - Normal mode
- `'v'` - Visual mode
- `'i'` - Insert mode
- `'t'` - Terminal mode
- `{'n', 'v'}` - Both normal and visual modes

---

## 🐛 Troubleshooting

### Issue: Keybinding doesn't work

**Solution 1:** Check if key is already mapped
```vim
:map <leader>h
" Shows what's currently mapped
```

**Solution 2:** Verify syntax
```lua
-- Make sure you have:
vim.keymap.set('n', '<leader>h', ':cmd<CR>', { desc = "Desc" })
--             ↑    ↑            ↑           ↑
--           mode   key        command     options
```

**Solution 3:** Reload config
```vim
:source ~/.config/nvim/lua/plugins/custom-keybindings.lua
```

---

### Issue: Keybinding conflicts with plugin

**Solution:** Use a different key

```lua
-- Instead of <leader>h, use:
vim.keymap.set('n', '<leader>ch', ':nohlsearch<CR>', { desc = "Clear Highlights" })
--                          ↑ added 'c' for 'clear'
```

---

### Issue: Description doesn't show in which-key

**Solution:** Make sure `desc` is set

```lua
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', {
  desc = "Clear Highlights",  -- This is required!
  silent = true
})
```

---

### Issue: Want to disable a keybinding

**Solution:** Comment it out or delete the mapping

```lua
-- Disable by commenting:
-- vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = "Clear" })

-- Or delete the mapping:
vim.keymap.del('n', '<leader>h')
```

---

## 📖 LazyVim Default Keybindings

**Don't override these!** They're already excellent:

### Core Bindings
- `<leader>` - Space (leader key)
- `<leader>qq` - Quit all
- `<leader>l` - Lazy plugin manager

### Files
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>fg` - Grep in files
- `<leader>e` - Toggle file tree

### Buffers
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>bd` - Delete buffer

### Windows
- `<C-h/j/k/l>` - Navigate windows (tmux-aware!)

See [Quick Reference](./00-QUICK-REFERENCE.md) for complete list.

---

## 📚 Examples of Good Custom Keybindings

### Example 1: Quick Terminal

```lua
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', {
  desc = "Open Terminal",
  silent = true
})
```

### Example 2: Toggle Relative Numbers

```lua
vim.keymap.set('n', '<leader>ur', ':set relativenumber!<CR>', {
  desc = "Toggle Relative Numbers",
  silent = true
})
```

### Example 3: Source Current File

```lua
vim.keymap.set('n', '<leader>so', ':source %<CR>', {
  desc = "Source Current File",
  silent = true
})
```

### Example 4: Format JSON

```lua
vim.keymap.set('n', '<leader>fj', ':%!jq .<CR>', {
  desc = "Format JSON",
  silent = true
})
```

---

## 🎯 Best Practices

### Do's ✅

- Use descriptive `desc` fields
- Keep bindings logical and memorable
- Group related bindings (all markdown bindings start with `<leader>m`)
- Test thoroughly before committing
- Document why you added each binding

### Don'ts ❌

- Don't override core Vim bindings (like `hjkl`, `dd`, `yy`)
- Don't override LazyVim defaults without good reason
- Don't create too many bindings (you'll forget them)
- Don't use obscure key combinations
- Don't map commonly used keys (`<Space>`, `<Enter>`, `<Esc>`)

---

## 📖 Related Documentation

- [Quick Reference](./00-QUICK-REFERENCE.md) - All keybindings in one place
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps) - Default LazyVim bindings
- [Customization Guide](./11-CUSTOMIZATION-GUIDE.md) - Advanced customization

---

## 🔗 External Resources

- **Neovim Keymaps Guide:** `:help vim.keymap`
- **LazyVim Keymaps:** https://www.lazyvim.org/keymaps
- **Which-Key Plugin:** https://github.com/folke/which-key.nvim

---

## 📋 Quick Command Reference

```vim
" Check existing mappings
:map <leader>h

" Delete a mapping
:unmap <leader>h

" List all leader mappings
:map <leader>

" Source config file
:source ~/.config/nvim/lua/plugins/custom-keybindings.lua

" Test a command before mapping
:nohlsearch
```

---

## 🎓 Learning Path

**Week 1:** Use `<leader>h` to clear highlights  
**Week 2:** Enable quick save (`<leader>w`)  
**Week 3:** Enable move lines in visual mode  
**Week 4:** Enable centered scrolling  
**Week 5+:** Add custom bindings as needed

**Remember:** Quality over quantity! Better to master 5 keybindings than to have 50 you never use.

---

**Last Updated:** March 20, 2026  
**Active Keybindings:** 1  
**Optional Keybindings:** 15+  
**Status:** ✅ Fully Configured
