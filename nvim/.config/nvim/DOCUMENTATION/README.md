# Neovim Configuration Documentation

Welcome to your comprehensive Neovim setup documentation. This directory contains detailed guides for all plugins, keybindings, and workflows configured in your Neovim setup.

---

## 📚 Table of Contents

### Core Documentation
1. [**Quick Reference Guide**](./00-QUICK-REFERENCE.md) - Quick lookup for all keybindings
2. [**Getting Started**](./01-GETTING-STARTED.md) - First steps with this config
3. [**LazyVim Basics**](./02-LAZYVIM-BASICS.md) - Understanding your base setup

### Plugin Documentation
4. [**Tmux Navigation**](./03-TMUX-NAVIGATION.md) - Seamless Neovim ↔ Tmux navigation
5. [**Markdown Preview**](./04-MARKDOWN-PREVIEW.md) - Beautiful markdown rendering
6. [**Vim-Test**](./05-VIM-TEST.md) - Test runner integration
7. [**Custom Keybindings**](./06-CUSTOM-KEYBINDINGS.md) - Quality-of-life shortcuts

### Workflow Guides
8. [**Tmux + Neovim Workflow**](./07-TMUX-NEOVIM-WORKFLOW.md) - Best practices
9. [**Testing Workflow**](./08-TESTING-WORKFLOW.md) - Running tests efficiently
10. [**Markdown Workflow**](./09-MARKDOWN-WORKFLOW.md) - Writing documentation

### Advanced Topics
11. [**Configuration Comparison**](./10-CONFIG-COMPARISON.md) - TypeCraft vs LazyVim
12. [**Customization Guide**](./11-CUSTOMIZATION-GUIDE.md) - Extending your config
13. [**Troubleshooting**](./12-TROUBLESHOOTING.md) - Common issues and solutions

---

## 🚀 Quick Start

**New to this config?** Start here:
1. Read [Getting Started](./01-GETTING-STARTED.md)
2. Review [Quick Reference](./00-QUICK-REFERENCE.md)
3. Learn [LazyVim Basics](./02-LAZYVIM-BASICS.md)

**Looking for specific features?** Jump to the relevant plugin documentation.

**Need a quick keybinding?** Check [Quick Reference](./00-QUICK-REFERENCE.md).

---

## 🎯 Most Useful Documents

### For Daily Use:
- [Quick Reference](./00-QUICK-REFERENCE.md) - Keep this open!
- [Tmux Navigation](./03-TMUX-NAVIGATION.md) - Essential for workflow
- [Markdown Preview](./04-MARKDOWN-PREVIEW.md) - Reading docs

### For Development:
- [Vim-Test](./05-VIM-TEST.md) - Running tests
- [Testing Workflow](./08-TESTING-WORKFLOW.md) - Best practices
- [Tmux + Neovim Workflow](./07-TMUX-NEOVIM-WORKFLOW.md) - Pro tips

### For Customization:
- [Customization Guide](./11-CUSTOMIZATION-GUIDE.md) - Make it yours
- [Config Comparison](./10-CONFIG-COMPARISON.md) - Learn from others

---

## 💡 How to Use This Documentation

### Reading in Neovim:
```bash
# Open from command line
nvim ~/.config/nvim/DOCUMENTATION/README.md

# Or from within Neovim
:e ~/.config/nvim/DOCUMENTATION/README.md
```

With the markdown plugins configured, these docs will render beautifully!

**Keybindings for reading:**
- `Space + m + r` - Toggle markdown rendering
- `Space + m + p` - Preview in browser
- `Space + m + o` - Open in Typora

### Reading in Browser:
```bash
# With markdown-preview
nvim README.md
# Then press: Space + m + p
```

### Reading in Typora:
```bash
typora ~/.config/nvim/DOCUMENTATION/README.md
```

---

## 📖 Documentation Structure

Each documentation file follows this structure:

```
# Title

## Overview
Brief description of what this covers

## Installation Status
Whether it's already installed

## Keybindings
Table of all keybindings

## Usage Guide
Step-by-step instructions

## Common Use Cases
Real-world examples

## Tips & Tricks
Pro tips

## Troubleshooting
Common issues and solutions

## Related Documentation
Links to related docs
```

---

## 🔄 Keeping Documentation Updated

This documentation reflects your config as of: **March 20, 2026**

If you modify your config:
1. Update the relevant documentation file
2. Add notes about what changed
3. Update keybindings in Quick Reference

---

## 🆘 Getting Help

### Documentation Not Clear?
- Check [Troubleshooting](./12-TROUBLESHOOTING.md)
- Read the related plugin's official docs (links provided in each file)

### Plugin Not Working?
- Verify installation: `:Lazy` in Neovim
- Check health: `:checkhealth`
- See [Troubleshooting](./12-TROUBLESHOOTING.md)

### Want to Add Features?
- See [Customization Guide](./11-CUSTOMIZATION-GUIDE.md)
- Review LazyVim docs: https://www.lazyvim.org

---

## 📝 Notes

### About This Config:
- **Base:** LazyVim (modern Neovim distribution)
- **Package Manager:** lazy.nvim
- **Leader Key:** Space (default)
- **Theme:** Multiple themes available (check plugins/theme.lua)

### Config Location:
```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/                 # Core config
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── options.lua        # Editor options
│   │   ├── keymaps.lua        # Custom keymaps
│   │   └── autocmds.lua       # Auto commands
│   └── plugins/               # Plugin configurations
│       ├── tmux-navigation.lua
│       ├── markdown-preview.lua
│       ├── vim-test.lua
│       ├── custom-keybindings.lua
│       └── ...
└── DOCUMENTATION/             # This directory!
```

---

## 🌟 Philosophy

This config follows these principles:

1. **Stay in Flow** - Minimal context switching
2. **Intuitive Keybindings** - Memorable and logical
3. **Well Documented** - Every feature explained
4. **Modular Design** - Easy to customize/remove features
5. **Performance First** - Lazy loading and optimization

---

## 📚 External Resources

### LazyVim:
- Official Docs: https://www.lazyvim.org
- Keymaps: https://www.lazyvim.org/keymaps
- Plugins: https://www.lazyvim.org/plugins

### Neovim:
- Official Docs: https://neovim.io/doc/
- User Manual: `:help user-manual`
- Plugin Development: https://neovim.io/doc/user/lua-guide.html

### Tmux:
- Official Docs: https://github.com/tmux/tmux/wiki
- Getting Started: https://github.com/tmux/tmux/wiki/Getting-Started

---

## 🙏 Credits

This configuration is built on the shoulders of giants:

- **LazyVim** - folke/LazyVim
- **lazy.nvim** - folke/lazy.nvim
- **vim-tmux-navigator** - christoomey/vim-tmux-navigator
- **render-markdown.nvim** - MeanderingProgrammer/render-markdown.nvim
- **markdown-preview.nvim** - iamcco/markdown-preview.nvim
- **vim-test** - vim-test/vim-test
- **vimux** - preservim/vimux

Special thanks to TypeCraft Dev for workflow inspiration!

---

## 🔖 Bookmark This!

Keep this README handy - it's your map to everything this config can do.

**Pro tip:** Create a shell alias:
```bash
# Add to your ~/.bashrc or ~/.zshrc
alias nvimdocs='nvim ~/.config/nvim/DOCUMENTATION/README.md'
```

Then just type `nvimdocs` to open this guide!

---

**Last Updated:** March 20, 2026  
**Config Version:** 1.0  
**Neovim Version:** 0.9+
