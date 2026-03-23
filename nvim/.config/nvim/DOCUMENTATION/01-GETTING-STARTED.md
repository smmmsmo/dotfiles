# Getting Started with Your Neovim Configuration

**Welcome! This guide will get you up and running with your fully configured Neovim setup.**

---

## 🎯 What You Have

Your Neovim configuration is built on **LazyVim**, a modern Neovim distribution with sensible defaults and powerful features. On top of that, you have custom plugins for:

- ✅ Seamless Tmux ↔ Neovim navigation
- ✅ Beautiful markdown preview
- ✅ Test runner integration
- ✅ Quality-of-life keybindings

**Think of it like:** VS Code, but faster, terminal-based, and infinitely customizable.

---

## 🚀 First Steps

### 1. Verify Installation

Open Neovim and check everything is working:

```bash
# Start Neovim
nvim

# Check health (inside Neovim)
:checkhealth

# Check installed plugins
:Lazy
```

**What to look for:**
- ✅ No major errors in `:checkhealth`
- ✅ All plugins shown in `:Lazy` UI
- ✅ Green checkmarks (plugins installed)

---

### 2. Learn the Leader Key

**Most important concept:** The leader key!

```
Leader = Space (   )
```

When you see `<leader>x`, it means:
1. Press Space
2. Press x

**Try it now:**
```
1. Open Neovim: nvim
2. Press Space
3. Wait 1 second
4. A menu appears showing all available commands!
```

This is **which-key** - your interactive cheat sheet!

---

### 3. Essential Keybindings (Learn These First)

**File Operations:**
```
Space + f + f    Find files (fuzzy search)
Space + f + r    Recent files
Space + e        Toggle file explorer
:w               Save file
:q               Quit
```

**Navigation:**
```
Ctrl + h/j/k/l   Move between windows/panes
Space + b + b    Switch buffers
Shift + h        Previous buffer
Shift + l        Next buffer
```

**Search:**
```
/pattern         Search forward
n                Next result
N                Previous result
Space + h        Clear search highlights (custom)
```

**Code:**
```
K                Show documentation
gd               Go to definition
Space + c + a    Code actions
Space + c + r    Rename symbol
```

---

## 📚 Learn by Doing

### Exercise 1: Open and Edit a File

```bash
# Step 1: Start Neovim
nvim

# Step 2: Find a file (press keys one at a time)
Space f f

# Step 3: Type to search (fuzzy!)
# Try typing parts of a filename

# Step 4: Select with Enter
Enter

# Step 5: Make an edit
i    (enter insert mode)
# Type something
Esc  (back to normal mode)

# Step 6: Save
:w

# Step 7: Quit
:q
```

---

### Exercise 2: Use the File Explorer

```bash
nvim

# Open file explorer
Space e

# Navigate with j/k (down/up)
# Open file with Enter
# Create file: press 'a', type name, Enter
# Delete file: press 'd'
# Rename file: press 'r'

# Close explorer
Space e
```

---

### Exercise 3: Split Windows

```bash
nvim

# Open a file
Space f f

# Split vertically
Ctrl + w v

# Split horizontally
Ctrl + w s

# Navigate between splits
Ctrl + h    (left)
Ctrl + l    (right)
Ctrl + j    (down)
Ctrl + k    (up)

# Close split
Ctrl + w q
```

---

### Exercise 4: Search in Files

```bash
nvim

# Search for text in all files
Space f g

# Type your search term
# Navigate results with Ctrl+j/k
# Open file with Enter
```

---

## 🎨 Customizing Your Setup

### Change Theme

Your config includes multiple themes. To change:

```bash
# Open theme config
nvim ~/.config/nvim/lua/plugins/theme.lua

# Or try a different one
:colorscheme tokyonight
:colorscheme catppuccin
:colorscheme gruvbox
```

---

### Adjust Options

```bash
# Open options file
nvim ~/.config/nvim/lua/config/options.lua

# Common settings to add:
vim.opt.number = true           -- Line numbers
vim.opt.relativenumber = true   -- Relative line numbers
vim.opt.tabstop = 4            -- Tab width
vim.opt.expandtab = true       -- Use spaces instead of tabs
```

---

## 💡 Tips for Learning Neovim

### Tip 1: Use Vim Motions

Learn these movement commands (they'll change your life):

```
h j k l          Left, Down, Up, Right
w                Next word
b                Previous word
0                Start of line
$                End of line
gg               Top of file
G                Bottom of file
%                Jump to matching bracket
```

---

### Tip 2: Master Visual Mode

```
v                Enter visual mode (select characters)
V                Visual line mode (select lines)
Ctrl + v         Visual block mode (select columns)

# Then:
d                Delete selection
y                Copy selection
c                Change selection (delete and enter insert)
>                Indent right
<                Indent left
```

---

### Tip 3: Learn Text Objects

Text objects let you operate on semantic units:

```
diw              Delete inside word
daw              Delete around word (includes space)
di"              Delete inside quotes
da"              Delete around quotes (includes quotes)
dit              Delete inside HTML tag
dap              Delete around paragraph

# Works with any verb:
ciw              Change inside word
yaw              Yank (copy) around word
vi(              Visual select inside parentheses
```

**This is the secret sauce of Vim!**

---

### Tip 4: Use the Dot Command

The `.` key repeats your last change:

```
# Example:
dw               Delete word
.                Delete next word
.                Delete next word
.                Delete next word

# Works with any change!
```

---

### Tip 5: Practice Daily

Don't try to learn everything at once:
- **Week 1:** Master basic navigation (hjkl, w, b)
- **Week 2:** Learn insert mode workflow (i, a, o, A, O)
- **Week 3:** Visual mode and text objects
- **Week 4:** Advanced motions (f, t, /, *, #)

---

## 🔧 Tmux Integration

If you use tmux (recommended!):

### Start Your Session

```bash
# Start tmux
tmux

# Start Neovim
nvim

# Create tmux pane
Prefix + %    (vertical split)
Prefix + "    (horizontal split)

# Navigate between Neovim and tmux with Ctrl+hjkl!
```

**See:** [Tmux Navigation Documentation](./03-TMUX-NAVIGATION.md)

---

## 📝 Working with Markdown

Your config has excellent markdown support:

```bash
# Open markdown file
nvim README.md

# Rendering happens automatically!
# GitHub-style headings, code blocks, tables

# Toggle rendering
Space m r

# Preview in browser
Space m p

# Preview in terminal with Glow
Space m g

# Open in Typora
Space m o
```

**See:** [Markdown Preview Documentation](./04-MARKDOWN-PREVIEW.md)

---

## 🧪 Running Tests

If you write tests (and you should!):

```bash
# In tmux, open test file
nvim tests/example.test.js

# Run test at cursor
Space t

# Run all tests in file
Space T

# Run full test suite
Space a

# Output appears in tmux pane!
```

**See:** [Vim-Test Documentation](./05-VIM-TEST.md)

---

## 🆘 Getting Help

### In Neovim

```vim
:help               " Neovim help system
:help navigation    " Help on specific topic
:help <topic>       " Help on any topic
:Tutor              " Interactive Neovim tutorial (30 min)
```

### Documentation

- [Quick Reference](./00-QUICK-REFERENCE.md) - One-page cheat sheet
- [Full Documentation](./README.md) - Complete guide index

### When Stuck

1. **Press Space** - which-key shows available commands
2. **Use `:help <topic>`** - Built-in help is excellent
3. **Check documentation** - All plugins documented here
4. **Read error messages** - They're usually helpful!

---

## 🎯 Next Steps

### Immediate (Do These Now)

1. ✅ Complete Exercise 1-4 above
2. ✅ Read [Quick Reference](./00-QUICK-REFERENCE.md)
3. ✅ Run `:Tutor` (Neovim's built-in tutorial)
4. ✅ Practice basic movements (hjkl, w, b)

### This Week

1. Read [LazyVim Basics](./02-LAZYVIM-BASICS.md)
2. Set up tmux integration if you use tmux
3. Configure your theme
4. Learn one new text object per day

### This Month

1. Read all plugin documentation
2. Customize keybindings to your preferences
3. Learn LSP features (code intelligence)
4. Master visual mode and text objects

---

## 📖 Recommended Reading Order

If you're new to Neovim, read these in order:

1. **This guide** (you are here!)
2. [Quick Reference](./00-QUICK-REFERENCE.md) - Bookmark this!
3. [LazyVim Basics](./02-LAZYVIM-BASICS.md) - Understand your foundation
4. [Tmux Navigation](./03-TMUX-NAVIGATION.md) - If you use tmux
5. Other plugin docs as needed

---

## 💪 Building Muscle Memory

### The 30-Day Challenge

**Don't use your mouse or arrow keys for 30 days!**

**Week 1:** Force yourself to use hjkl  
**Week 2:** Add w, b, e (word motions)  
**Week 3:** Add f, t, / (search motions)  
**Week 4:** Add text objects (diw, ci", etc.)

**Result:** You'll be faster than you ever were with a mouse!

---

## 🎓 Learning Resources

### Interactive

- `:Tutor` - Built into Neovim (30 minutes)
- Vim Adventures - https://vim-adventures.com (gamified)

### Reading

- LazyVim Docs - https://www.lazyvim.org
- Neovim Docs - https://neovim.io/doc

### Videos

- ThePrimeagen (YouTube) - Vim workflows
- TypeCraft (YouTube) - Neovim configurations

---

## 🚨 Common Beginner Mistakes

### Mistake 1: Staying in Insert Mode

**Wrong:** Entering insert mode and staying there  
**Right:** Use normal mode for navigation, insert mode only for typing

### Mistake 2: Using Arrow Keys

**Wrong:** Using arrow keys to navigate  
**Right:** Use hjkl and word motions (w, b, e)

### Mistake 3: Not Using Text Objects

**Wrong:** `ddddddd` (delete 7 lines manually)  
**Right:** `7dd` or `dip` (delete inside paragraph)

### Mistake 4: Ignoring Visual Mode

**Wrong:** Deleting one line at a time  
**Right:** Visual select multiple lines → delete

### Mistake 5: Not Reading Error Messages

**Wrong:** Panicking when something goes wrong  
**Right:** Read the error message - it tells you what's wrong!

---

## ✅ Checklist: First Day Setup

- [ ] Verified `:checkhealth` shows no critical errors
- [ ] Opened `:Lazy` and confirmed plugins installed
- [ ] Pressed Space and saw which-key menu
- [ ] Completed Exercise 1 (Open and edit a file)
- [ ] Learned basic movements (hjkl, w, b)
- [ ] Saved and quit successfully (`:wq`)
- [ ] Bookmarked Quick Reference documentation
- [ ] Ran `:Tutor` (or scheduled time to do it)

---

## 🎉 You're Ready!

Congratulations! You now have a powerful Neovim setup and know how to use it.

**Remember:**
- Learning Neovim is a journey, not a sprint
- Focus on one skill at a time
- Practice daily
- Use `:help` when stuck
- Refer to documentation often

**Most importantly:** Have fun! Neovim is incredibly powerful and rewarding once you get past the initial learning curve.

---

## 📞 Where to Go from Here

**Immediate:**
- Practice! Open real files and work with them
- Run `:Tutor` if you haven't yet
- Keep [Quick Reference](./00-QUICK-REFERENCE.md) open

**This Week:**
- Read all documentation files
- Customize your setup
- Learn one new feature per day

**This Month:**
- Master text objects
- Learn advanced LSP features
- Contribute to the config (make it yours!)

---

**Welcome to the Neovim family!** 🚀

**Last Updated:** March 20, 2026  
**Your Next Step:** Complete the exercises above!
