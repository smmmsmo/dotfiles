# Markdown Preview & Rendering

**Beautiful GitHub-style markdown rendering in Neovim and browser.**

---

## 📖 Overview

This configuration provides **three professional ways** to read and edit Markdown files:

1. **render-markdown.nvim** - GitHub-style rendering directly in Neovim (⭐ Recommended)
2. **markdown-preview.nvim** - Live preview in your web browser
3. **Typora Integration** - Open files in Typora WYSIWYG editor

**You can use all three depending on your needs!**

---

## ✅ Installation Status

**Status:** ✅ Installed  
**Config File:** `~/.config/nvim/lua/plugins/markdown-preview.lua`

**Plugins Installed:**
- `MeanderingProgrammer/render-markdown.nvim`
- `iamcco/markdown-preview.nvim`
- Typora integration keybindings

---

## 🔑 Keybindings

### In-Editor Rendering (render-markdown.nvim)
| Key | Action |
|-----|--------|
| `<leader>mr` | Toggle markdown rendering on/off |

*Auto-renders when you open .md files!*

### Browser Preview (markdown-preview.nvim)
| Key | Action |
|-----|--------|
| `<leader>mp` | Start markdown preview in browser |
| `<leader>ms` | Stop markdown preview |
| `<leader>mt` | Toggle markdown preview |

### Typora Integration
| Key | Action |
|-----|--------|
| `<leader>mo` | Open current file in Typora |
| `<leader>mO` | Open file under cursor in Typora |

### Markdown Formatting (Visual Mode Only)
| Key | Action | Result |
|-----|--------|--------|
| `<leader>mb` | Bold selection | `**text**` |
| `<leader>mi` | Italic selection | `*text*` |
| `<leader>mc` | Code selection | `` `text` `` |
| `<leader>ml` | Create link | `[text]()` |

---

## 🚀 Usage Guide

### Method 1: In-Editor Rendering (Recommended) ⭐

**Best for:** Reading documentation, quick edits, staying in flow

**How to use:**
```bash
# Open any markdown file
nvim README.md

# Rendering happens automatically!
# See beautiful GitHub-style formatting
```

**Features:**
- ✅ GitHub-style headings with icons
- ✅ Syntax-highlighted code blocks
- ✅ Rendered tables
- ✅ Checkboxes (✓ and ☐)
- ✅ Bullet points and numbering
- ✅ Quote blocks
- ✅ Links (clickable with `gx`)

**Toggle rendering:**
```
Space + m + r    (if rendering gets in the way of editing)
```

**Visual Example:**
```markdown
# Before (raw markdown)
# My Project
**Bold text** and *italic*
- Item 1
- Item 2

# After (rendered in Neovim)
󰲡 My Project
Bold text and italic
● Item 1
● Item 2
```

---

### Method 2: Browser Preview

**Best for:** Final review before publishing, seeing exact GitHub rendering

**How to use:**
```bash
# Open markdown file
nvim documentation.md

# Start preview
Space + m + p

# Your browser opens with live preview!
# Edit in Neovim → See changes in browser instantly
```

**Features:**
- ✅ Exact GitHub markdown rendering
- ✅ Real-time updates as you type
- ✅ Full HTML/CSS support
- ✅ Dark/light theme
- ✅ Scroll sync (page follows your cursor)

**Stop preview:**
```
Space + m + s
```

**Toggle preview on/off:**
```
Space + m + t
```

---

### Method 3: Typora (WYSIWYG Editor)

**Best for:** Complex documents, non-developer edits, visual editing

**How to use:**
```bash
# Open markdown file in Neovim
nvim report.md

# Open in Typora
Space + m + o

# Typora window opens
# Edit visually, changes save to file
# Switch back to Neovim when done
```

**Open file under cursor:**
```markdown
See also: [other-doc.md](./other-doc.md)
           ↑ cursor here

Press: Space + m + O
# Opens other-doc.md in Typora
```

---

## 📚 Common Use Cases

### Use Case 1: Reading Documentation

**Scenario:** You need to read a README.md file

**Best Method:** render-markdown.nvim (automatic)

```bash
nvim README.md
# Just read! Looks beautiful automatically
```

**Why:** No extra commands, instant readable view, stay in Neovim.

---

### Use Case 2: Writing New Documentation

**Scenario:** Creating a new guide or documentation

**Best Method:** Combination approach

```bash
# Step 1: Write in Neovim with rendering
nvim new-guide.md

# Step 2: Toggle rendering off when needed
Space + m + r    # Edit raw markdown

# Step 3: Toggle back on to see result
Space + m + r

# Step 4: Final review in browser
Space + m + p
```

**Why:** Write efficiently in Neovim, verify final look in browser.

---

### Use Case 3: Quick Edits to Existing Docs

**Scenario:** Fix typos or update existing markdown

**Best Method:** render-markdown.nvim only

```bash
nvim docs/guide.md
# Make changes while seeing formatted view
# Save and done!
```

**Why:** Fastest workflow, no context switching.

---

### Use Case 4: Complex Document with Tables/Images

**Scenario:** Creating a document with complex formatting

**Best Method:** Start in Typora, refine in Neovim

```bash
# Step 1: Create structure in Typora (visual)
Space + m + o

# Step 2: Refine content in Neovim
# (Typora saves, you can switch back)

# Step 3: Quick edits always in Neovim
```

**Why:** Typora handles tables/images visually, Neovim for quick edits.

---

### Use Case 5: Reviewing Pull Request Docs

**Scenario:** Checking how docs will look on GitHub

**Best Method:** Browser preview

```bash
nvim CONTRIBUTING.md
Space + m + p
# See exact GitHub rendering
```

**Why:** Exact preview of how it appears on GitHub.

---

## 💡 Pro Tips

### Tip 1: Side-by-Side Editing

Keep browser preview open in a second monitor:
```bash
# Terminal 1: Neovim
nvim doc.md
Space + m + p

# Move browser to second monitor
# Type in Neovim → Instant update in browser
```

### Tip 2: Quick Formatting

Learn the visual mode shortcuts:
```bash
# Select text in visual mode (v)
# Press Space + m + b for bold
# Much faster than typing ** **
```

### Tip 3: Concealment Level

If rendering hides too much:
```vim
:set conceallevel=0    " Show all syntax
:set conceallevel=2    " Default (hide syntax)
```

### Tip 4: Spell Checking

Spell check is auto-enabled for markdown!
```
]s    " Next misspelled word
[s    " Previous misspelled word
z=    " Suggest corrections
zg    " Add word to dictionary
```

### Tip 5: Jump to Headings

Use Telescope to jump to headings:
```
Space + f + f    # Then type: # to filter headers
```

---

## 🎨 Customization

### Change Rendering Theme

Edit `~/.config/nvim/lua/plugins/markdown-preview.lua`:

```lua
-- For browser preview theme
vim.g.mkdp_theme = 'light'  -- or 'dark'
```

### Disable Auto-Rendering

If you don't want automatic rendering:

```lua
-- In the render-markdown config
opts = {
  enabled = false,  -- Add this line
}

-- Then manually toggle with <leader>mr when needed
```

### Change Heading Icons

```lua
-- In render-markdown config
headings = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
-- Or any other icons you prefer
```

### Custom Code Block Style

```lua
-- In render-markdown config
code = {
  style = 'language',  -- Show language name
  width = 'full',      -- Full width blocks
},
```

---

## 🐛 Troubleshooting

### Issue: Rendering not showing icons

**Cause:** Nerd Font not installed

**Solution:**
```bash
# LazyVim requires Nerd Fonts
# Install from: https://www.nerdfonts.com/
# Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font
```

---

### Issue: Browser preview not opening

**Cause:** Plugin not fully installed

**Solution:**
```vim
:call mkdp#util#install()
# Wait for installation to complete
# Restart Neovim
```

---

### Issue: Typora keybinding doesn't work

**Cause:** Typora not installed or not in PATH

**Solution:**
```bash
# Check if Typora is installed
which typora

# If not found, install Typora
# Then add to PATH or use full path in config
```

---

### Issue: Rendering makes editing hard

**Cause:** Concealment level too high

**Solution:**
```
Space + m + r    # Toggle rendering off
# Edit your content
Space + m + r    # Toggle back on to preview
```

---

### Issue: Browser preview shows wrong styles

**Cause:** Custom CSS or theme issues

**Solution:**
```lua
-- In the config, reset to defaults:
vim.g.mkdp_markdown_css = ''
vim.g.mkdp_highlight_css = ''
```

---

### Issue: Spell check is annoying

**Cause:** Auto-enabled for markdown files

**Solution:**
```vim
:set nospell    " Disable in current buffer
# Or edit the config to disable auto-spell
```

---

## 📊 Feature Comparison

| Feature | In-Editor | Browser | Typora |
|---------|-----------|---------|--------|
| Speed | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Accuracy | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Stay in Neovim | ✅ | ❌ | ❌ |
| WYSIWYG | ❌ | ⚠️ | ✅ |
| Real-time | ✅ | ✅ | ✅ |
| Offline | ✅ | ✅ | ✅ |
| GitHub Style | ✅ | ✅ | ⚠️ |

**Legend:**
- ⭐⭐⭐⭐⭐ = Excellent
- ⭐⭐⭐⭐ = Good
- ⭐⭐⭐ = Average
- ⭐⭐ = Below Average

---

## 🎯 Recommended Workflow

**For 90% of markdown work:**
```bash
nvim file.md    # render-markdown auto-renders
# Write and edit with beautiful formatting
# Save and done!
```

**For publishing/documentation:**
```bash
nvim file.md
Space + m + p    # Verify exact GitHub rendering
# Make final tweaks
# Publish with confidence
```

**For non-developers:**
```bash
nvim file.md
Space + m + o    # Let them edit in Typora
# Changes save automatically
```

---

## 📖 Related Documentation

- [Quick Reference](./00-QUICK-REFERENCE.md) - All markdown keybindings
- [Markdown Workflow](./09-MARKDOWN-WORKFLOW.md) - Best practices
- [Customization Guide](./11-CUSTOMIZATION-GUIDE.md) - Advanced config

---

## 🔗 External Resources

- **render-markdown.nvim:** https://github.com/MeanderingProgrammer/render-markdown.nvim
- **markdown-preview.nvim:** https://github.com/iamcco/markdown-preview.nvim
- **Typora:** https://typora.io
- **GitHub Markdown Guide:** https://guides.github.com/features/mastering-markdown/

---

## 📋 Quick Command Reference

```bash
# Reading markdown
nvim file.md               # Auto-renders

# Toggle rendering
Space + m + r

# Browser preview
Space + m + p              # Start
Space + m + s              # Stop
Space + m + t              # Toggle

# Typora
Space + m + o              # Open current file
Space + m + O              # Open file under cursor

# Formatting (visual mode)
Space + m + b              # Bold
Space + m + i              # Italic
Space + m + c              # Code
Space + m + l              # Link
```

---

**Last Updated:** March 20, 2026  
**Recommendation:** Use render-markdown.nvim for 90% of tasks  
**Status:** ✅ Fully Configured
