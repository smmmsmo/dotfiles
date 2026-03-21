# Quick Reference Guide

**One-page reference for all keybindings and common commands.**

---

## 🔑 Leader Key

**Leader = Space (` `)**

When you see `<leader>`, press the Space key.

---

## 🚀 Essential Keybindings

### General
| Key | Action | Mode |
|-----|--------|------|
| `<leader>` | Opens which-key menu (shows all bindings) | Normal |
| `<leader>qq` | Quit all | Normal |
| `:q` | Quit current window | Command |
| `:w` | Save file | Command |
| `:wq` | Save and quit | Command |
| `<Esc>` | Exit mode / Clear highlights | Any |

---

## 📁 File Navigation

### Opening Files
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (fuzzy search) |
| `<leader>fr` | Recent files |
| `<leader>fg` | Grep/search in files |
| `<leader>fb` | Find buffers |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `-` | Open Oil.nvim file browser (if installed) |

### Buffer Management
| Key | Action |
|-----|--------|
| `<S-h>` | Previous buffer (Shift + h) |
| `<S-l>` | Next buffer (Shift + l) |
| `<leader>bd` | Delete/close buffer |
| `<leader>bb` | Switch to another buffer |

---

## 🪟 Window Navigation (Neovim Splits)

### Tmux-Aware Navigation
| Key | Action |
|-----|--------|
| `<C-h>` | Move to left window/tmux pane |
| `<C-j>` | Move to bottom window/tmux pane |
| `<C-k>` | Move to top window/tmux pane |
| `<C-l>` | Move to right window/tmux pane |
| `<C-\>` | Move to previous window/tmux pane |

### Window Management
| Key | Action |
|-----|--------|
| `<C-w>s` | Split horizontally |
| `<C-w>v` | Split vertically |
| `<C-w>q` | Quit window |
| `<C-w>=` | Equalize window sizes |

---

## 💻 Terminal

### Terminal Toggle
| Key | Action |
|-----|--------|
| `<C-/>` | Toggle floating terminal |
| `<leader>ft` | Terminal (root dir) |
| `<leader>fT` | Terminal (current working dir) |

### In Terminal Mode
| Key | Action |
|-----|--------|
| `<C-\><C-n>` | Exit terminal mode to normal mode |
| `<C-h/j/k/l>` | Navigate to Neovim window |

---

## 🧪 Testing (vim-test)

### Run Tests
| Key | Action |
|-----|--------|
| `<leader>t` | Run test nearest to cursor |
| `<leader>T` | Run entire test file |
| `<leader>a` | Run all tests (full suite) |
| `<leader>l` | Re-run last test |
| `<leader>g` | Go to last test file |

**Note:** Tests run in a tmux pane via vimux.

---

## 📝 Markdown

### Viewing
| Key | Action |
|-----|--------|
| `<leader>mr` | Toggle markdown rendering (in Neovim) |
| `<leader>mp` | Start markdown preview (browser) |
| `<leader>ms` | Stop markdown preview |
| `<leader>mt` | Toggle markdown preview |
| `<leader>mo` | Open current file in Typora |

### Formatting (Visual Mode)
| Key | Action |
|-----|--------|
| `<leader>mb` | **Bold** selected text |
| `<leader>mi` | *Italic* selected text |
| `<leader>mc` | `Code` selected text |
| `<leader>ml` | Create [link]() from selection |

---

## 🔍 Search & Replace

### Search
| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `*` | Search word under cursor |
| `<leader>h` | Clear search highlights |

### Find & Replace
| Command | Action |
|---------|--------|
| `:%s/old/new/g` | Replace all in file |
| `:s/old/new/g` | Replace in current line |
| `:%s/old/new/gc` | Replace with confirmation |

---

## 💡 Code Intelligence (LSP)

### Navigation
| Key | Action |
|-----|--------|
| `K` | Show hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format code |

### Diagnostics
| Key | Action |
|-----|--------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<leader>cd` | Line diagnostics |
| `<leader>q` | Diagnostics quickfix list |

---

## 🎨 Git Integration

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Git blame current line |
| `<leader>gd` | Git diff |
| `<leader>gs` | Git status |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |

---

## 🛠️ Plugin Management

| Key | Action |
|-----|--------|
| `<leader>l` | Open Lazy.nvim UI |
| `:Lazy sync` | Update/install plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy health` | Check plugin health |

---

## 📋 Copy/Paste

### Vim Registers
| Key | Action |
|-----|--------|
| `yy` | Yank (copy) current line |
| `Y` | Yank to end of line |
| `dd` | Delete (cut) current line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `"+y` | Copy to system clipboard |
| `"+p` | Paste from system clipboard |

---

## 🎯 Visual Mode

| Key | Action |
|-----|--------|
| `v` | Enter visual mode (character) |
| `V` | Enter visual line mode |
| `<C-v>` | Enter visual block mode |
| `gv` | Reselect last visual selection |
| `>` | Indent right |
| `<` | Indent left |

---

## 🔢 Numbers & Text Objects

### Text Objects (use with verbs like d, c, y)
| Key | Action |
|-----|--------|
| `iw` | Inside word |
| `aw` | Around word |
| `i"` | Inside quotes |
| `a"` | Around quotes |
| `i(` or `i)` | Inside parentheses |
| `a(` or `a)` | Around parentheses |
| `i{` or `i}` | Inside braces |
| `it` | Inside HTML/XML tag |

### Examples
- `diw` - Delete inside word
- `ci"` - Change inside quotes
- `ya{` - Yank around braces
- `dit` - Delete inside tag

---

## 🏃 Quick Actions

### Common Workflows
| Action | Keys |
|--------|------|
| Save and quit | `:wq` or `ZZ` |
| Quit without saving | `:q!` or `ZQ` |
| Undo | `u` |
| Redo | `<C-r>` |
| Open file under cursor | `gf` |
| Go back | `<C-o>` |
| Go forward | `<C-i>` |

---

## 🚨 Emergency Commands

| Command | Action |
|---------|--------|
| `:q!` | Force quit (discard changes) |
| `:qa!` | Force quit all windows |
| `:w !sudo tee %` | Save with sudo |
| `<C-c>` | Cancel current operation |
| `:checkhealth` | Check Neovim health |
| `:Lazy restore` | Restore plugins to lockfile |

---

## 💾 Custom Keybindings (Added by You)

| Key | Action | Source |
|-----|--------|--------|
| `<leader>h` | Clear search highlights | custom-keybindings.lua |
| `<C-h/j/k/l>` | Tmux-aware navigation | tmux-navigation.lua |
| `<leader>t/T/a/l/g` | Test commands | vim-test.lua |
| `<leader>m*` | Markdown commands | markdown-preview.lua |

---

## 📖 Getting More Help

### In Neovim:
- `:help <topic>` - Built-in help (e.g., `:help navigation`)
- `<leader>` - Wait to see which-key menu
- `:Telescope keymaps` - Search all keymaps

### Documentation:
- [Full Documentation Index](./README.md)
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps)
- [Neovim Help](https://neovim.io/doc/)

---

## 📌 Print-Friendly Version

Want a physical copy? Print this page and keep it next to your keyboard!

**Pro Tip:** Keep this file open in a split while learning:
```bash
nvim -O somefile.txt ~/.config/nvim/DOCUMENTATION/00-QUICK-REFERENCE.md
```

---

**Last Updated:** March 20, 2026  
**Quick Tip:** Press `<leader>` and wait 1 second to see all available keybindings!
