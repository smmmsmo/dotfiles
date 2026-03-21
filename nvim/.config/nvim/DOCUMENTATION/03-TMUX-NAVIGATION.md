# Tmux Navigation Plugin

**Seamless navigation between Neovim splits and Tmux panes.**

---

## 📖 Overview

The `vim-tmux-navigator` plugin allows you to navigate between Neovim windows and Tmux panes using the same keybindings. This creates a unified navigation experience where you don't have to think about whether you're switching Neovim splits or Tmux panes.

**Repository:** https://github.com/christoomey/vim-tmux-navigator

---

## ✅ Installation Status

**Status:** ✅ Installed  
**Config File:** `~/.config/nvim/lua/plugins/tmux-navigation.lua`  
**Dependencies:** Requires corresponding Tmux configuration

---

## 🔑 Keybindings

| Key | Action | Works In |
|-----|--------|----------|
| `<C-h>` | Navigate Left | Neovim + Tmux |
| `<C-j>` | Navigate Down | Neovim + Tmux |
| `<C-k>` | Navigate Up | Neovim + Tmux |
| `<C-l>` | Navigate Right | Neovim + Tmux |
| `<C-\>` | Navigate to Previous | Neovim + Tmux |

**Note:** `<C-h>` means Ctrl + h (hold Control and press h)

---

## 🚀 How It Works

### The Magic

When you press `<C-h>` (for example):

1. **Inside Neovim:** If there's a split to the left, it moves to that split
2. **At Edge:** If you're at the leftmost Neovim split, it moves to the adjacent Tmux pane
3. **Seamless:** You don't have to think about whether you're in Neovim or Tmux

### Visual Example

```
┌─────────────────────────────────────┐
│           Tmux Session              │
├──────────────────┬──────────────────┤
│                  │                  │
│  Neovim Window   │   Tmux Pane 2    │
│  ┌──────┬──────┐ │                  │
│  │Split1│Split2│ │   $ htop         │
│  │      │      │ │                  │
│  │      │      │ │                  │
│  └──────┴──────┘ │                  │
│                  │                  │
└──────────────────┴──────────────────┘

Press <C-l> anywhere in Neovim → Moves to Tmux Pane 2
Press <C-h> in Tmux Pane 2 → Moves back to Neovim Split2
Press <C-h> in Split2 → Moves to Split1
```

---

## 📦 Setup Requirements

### 1. Neovim Configuration (Already Done ✅)

The plugin is already installed and configured in:
```
~/.config/nvim/lua/plugins/tmux-navigation.lua
```

### 2. Tmux Configuration (REQUIRED)

You must add configuration to your `~/.tmux.conf` file for this to work.

**Location:** `~/.tmux.conf`

**Add this to your tmux.conf:**

```tmux
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
```

### 3. Reload Tmux Configuration

After editing `~/.tmux.conf`:

```bash
# From your shell (outside tmux):
tmux source-file ~/.tmux.conf

# OR from inside tmux (press prefix first, usually Ctrl+b):
# Prefix + : (to enter command mode)
# Then type:
source-file ~/.tmux.conf
```

---

## 📚 Usage Guide

### Starting Your Workflow

1. **Start Tmux:**
   ```bash
   tmux
   ```

2. **Open Neovim:**
   ```bash
   nvim
   ```

3. **Create some splits/panes:**
   - Neovim split: `<C-w>v` (vertical) or `<C-w>s` (horizontal)
   - Tmux pane: `Prefix + %` (vertical) or `Prefix + "` (horizontal)
   
4. **Navigate freely:**
   - Use `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` to move anywhere!

### Common Workflow Example

```bash
# In Tmux:
1. Create vertical split: Prefix + %
2. Left pane: Open Neovim
3. Right pane: Run tests or logs
4. In Neovim: Create splits with <C-w>v
5. Navigate everything with <C-h/j/k/l>
```

---

## 💡 Common Use Cases

### 1. Code + Tests Side-by-Side

```
┌──────────────────────────────────┐
│         Tmux Session             │
├─────────────────┬────────────────┤
│   Neovim        │   Test Output  │
│   (editing)     │   $ npm test   │
│                 │                │
│                 │   ✓ 45 passing │
│                 │   ✗ 2 failing  │
└─────────────────┴────────────────┘

Press <C-l> to quickly check test results
Press <C-h> to go back to editing
```

### 2. Multiple File Editing

```
┌──────────────────────────────────┐
│         Neovim Window            │
├─────────────────┬────────────────┤
│   file1.js      │   file2.js     │
│                 │                │
│   function()    │   import foo   │
│   {             │                │
│     ...         │   export bar   │
└─────────────────┴────────────────┘

Press <C-l> to switch between files
No need for :bnext or buffer commands!
```

### 3. Code + Documentation + Terminal

```
┌─────────────────────────────────────┐
│          Tmux Session               │
├───────────────┬─────────────────────┤
│               │                     │
│  Neovim       │  Documentation      │
│  (code)       │  (markdown preview) │
│               │                     │
├───────────────┴─────────────────────┤
│  Terminal (running server)          │
│  $ npm run dev                      │
└─────────────────────────────────────┘

Navigate all three areas with <C-h/j/k/l>
```

---

## 🎯 Pro Tips

### Tip 1: Zoom Tmux Panes
If you need to focus on one pane temporarily:
```
Prefix + z  (toggle zoom on current pane)
```

### Tip 2: Resize Tmux Panes
```
Prefix + Alt + arrow keys  (resize pane)
```

### Tip 3: Remember Your Context
The plugin is smart - it knows when you're in Neovim vs Tmux terminal mode.

### Tip 4: Use with Neovim Terminal
Open a terminal in Neovim (`:terminal`), and the navigation still works!

### Tip 5: Muscle Memory
After a day of use, this becomes second nature. You'll forget you're even switching between Neovim and Tmux.

---

## 🐛 Troubleshooting

### Issue: Navigation doesn't work between Neovim and Tmux

**Solution 1:** Check Tmux configuration
```bash
# Verify tmux.conf exists
cat ~/.tmux.conf | grep "vim-tmux-navigator"

# If nothing shows, you need to add the tmux config (see Setup above)
```

**Solution 2:** Reload Tmux configuration
```bash
tmux source-file ~/.tmux.conf
```

**Solution 3:** Restart Tmux
```bash
# Save your work, then:
tmux kill-server
tmux
```

---

### Issue: `<C-l>` doesn't work (clears screen instead)

**Cause:** This is actually the default terminal behavior for `<C-l>`.

**Solution:** The plugin handles this! Once tmux config is added, `<C-l>` will navigate instead of clearing screen.

**Alternative:** If you need to clear screen, use:
```bash
:!clear  (in Neovim)
# or
Ctrl+l twice quickly (in terminal)
```

---

### Issue: Works in Neovim but not from Tmux panes

**Cause:** Tmux configuration is missing or incorrect.

**Solution:** Double-check the tmux.conf configuration (see Setup section).

---

### Issue: Navigation is slow/laggy

**Cause:** Tmux is checking if the process is Vim on every keypress.

**Solution:** This is normal behavior. The lag is minimal (< 50ms) and most users don't notice it.

**Alternative:** If it really bothers you, you can disable the feature and use traditional Tmux navigation for panes (Prefix + arrow keys).

---

## 🔧 Customization

### Change Keybindings

If you want different keys, edit the plugin config:

```lua
-- In ~/.config/nvim/lua/plugins/tmux-navigation.lua
keys = {
  { "<C-Left>", "<cmd><C-U>TmuxNavigateLeft<cr>" },   -- Use arrow keys
  { "<C-Down>", "<cmd><C-U>TmuxNavigateDown<cr>" },
  { "<C-Up>", "<cmd><C-U>TmuxNavigateUp<cr>" },
  { "<C-Right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
},
```

**Warning:** If you change Neovim keybindings, you must also update the corresponding Tmux configuration!

---

### Disable for Specific Neovim Modes

If you want navigation to work only in normal mode:

```lua
-- In the plugin config
keys = {
  { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", mode = "n" },
  -- ... rest of keys
},
```

---

## 📖 Related Documentation

- [Tmux + Neovim Workflow](./07-TMUX-NEOVIM-WORKFLOW.md) - Best practices
- [Quick Reference](./00-QUICK-REFERENCE.md) - All keybindings
- [Getting Started](./01-GETTING-STARTED.md) - Initial setup

---

## 🔗 External Resources

- **Plugin Repository:** https://github.com/christoomey/vim-tmux-navigator
- **Tmux Getting Started:** https://github.com/tmux/tmux/wiki/Getting-Started
- **LazyVim Docs:** https://www.lazyvim.org

---

## 📝 Quick Command Reference

### Neovim Window Management
```vim
<C-w>v     " Vertical split
<C-w>s     " Horizontal split
<C-w>q     " Close window
<C-w>=     " Equalize window sizes
```

### Tmux Pane Management
```bash
Prefix + %    # Vertical split
Prefix + "    # Horizontal split
Prefix + x    # Close pane
Prefix + z    # Zoom pane
```

### Navigation (Works in Both!)
```
<C-h>    # Left
<C-j>    # Down
<C-k>    # Up
<C-l>    # Right
<C-\>    # Previous
```

---

**Last Updated:** March 20, 2026  
**Plugin Version:** Latest from lazy.nvim  
**Status:** ✅ Fully Configured
