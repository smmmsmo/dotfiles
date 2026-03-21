# Vim-Test: Test Runner Integration

**Run tests directly from Neovim with tmux integration.**

---

## 📖 Overview

The `vim-test` plugin allows you to run tests without leaving Neovim. Tests execute in a tmux pane (via vimux), so you can see output while continuing to code. It automatically detects your test framework and works with 20+ testing tools.

**Repositories:**
- vim-test: https://github.com/vim-test/vim-test
- vimux: https://github.com/preservim/vimux

---

## ✅ Installation Status

**Status:** ✅ Installed  
**Config File:** `~/.config/nvim/lua/plugins/vim-test.lua`  
**Dependencies:** 
- `vim-test/vim-test`
- `preservim/vimux` (tmux integration)
- **Requires:** Running Neovim inside tmux

---

## 🔑 Keybindings

| Key | Command | Action |
|-----|---------|--------|
| `<leader>t` | `:TestNearest` | Run test nearest to cursor |
| `<leader>T` | `:TestFile` | Run all tests in current file |
| `<leader>a` | `:TestSuite` | Run entire test suite |
| `<leader>l` | `:TestLast` | Re-run last test |
| `<leader>g` | `:TestVisit` | Jump to last test file |

**Remember:** `<leader>` = Space key

---

## 🚀 How It Works

### The Flow

1. You write code in Neovim
2. Position cursor in/near a test
3. Press `<leader>t`
4. Test runs in a tmux split pane
5. See results immediately
6. Continue coding

### Visual Example

```
┌─────────────────────────────────────┐
│         Tmux Window                 │
├──────────────────┬──────────────────┤
│                  │                  │
│  Neovim          │  Test Output     │
│  (editing code)  │                  │
│                  │  Running tests...│
│  it('should...') │  ✓ 45 passing   │
│    ← cursor here │  ✗ 2 failing    │
│  Press <leader>t │                  │
│                  │  TypeError: ...  │
│                  │                  │
└──────────────────┴──────────────────┘
```

---

## 📦 Setup Requirements

### 1. Neovim Configuration (Already Done ✅)

Plugin is already installed via:
```
~/.config/nvim/lua/plugins/vim-test.lua
```

### 2. Tmux Requirement (IMPORTANT)

**You MUST run Neovim inside tmux for this to work.**

```bash
# Start tmux first
tmux

# Then start Neovim
nvim
```

### 3. Test Framework (Project-Specific)

vim-test auto-detects test frameworks. Make sure your project has:
- Test files in standard locations
- Test framework installed (npm, pip, gem, etc.)

**Supported frameworks:** See section below.

---

## 📚 Usage Guide

### Basic Workflow

**Step 1: Start tmux**
```bash
tmux
```

**Step 2: Open Neovim and test file**
```bash
nvim tests/user.test.js
```

**Step 3: Run tests**
```
Space + t    # Run test at cursor
Space + T    # Run all tests in file
Space + a    # Run full test suite
```

**Step 4: See results in tmux pane**
- Test output appears automatically
- Pane stays open for review
- Red/green output shows pass/fail

**Step 5: Iterate**
```
# Fix the failing test
# Press Space + l to re-run
# Repeat until all tests pass
```

---

### Running Specific Tests

#### Test Nearest to Cursor
**Keybinding:** `<leader>t`

```javascript
describe('User', () => {
  it('should create user', () => {
    ← Put cursor here or anywhere in this test
    // Press Space + t
    // Runs ONLY this test
  });
  
  it('should delete user', () => {
    // This test won't run
  });
});
```

**Use when:** Testing one specific function/scenario

---

#### Test Entire File
**Keybinding:** `<leader>T` (capital T)

```javascript
// user.test.js
describe('User', () => {
  it('test 1', () => { ... });  ← Runs this
  it('test 2', () => { ... });  ← Runs this
  it('test 3', () => { ... });  ← Runs this
});

// Press Space + Shift + t
// Runs ALL tests in this file
```

**Use when:** Testing an entire module/component

---

#### Test Full Suite
**Keybinding:** `<leader>a`

```bash
# Runs ALL tests in your project
# Equivalent to: npm test, pytest, rspec, etc.
```

**Use when:** 
- Pre-commit checks
- Verifying nothing broke
- CI/CD simulation

---

#### Re-run Last Test
**Keybinding:** `<leader>l`

```bash
# Runs the exact same test command as before
# Super useful for TDD workflow:
# 1. Write test
# 2. Run test (fails)
# 3. Write code
# 4. Press Space + l (re-run)
# 5. Repeat step 3-4 until green
```

**Use when:** Iterating on failing tests

---

#### Visit Last Test File
**Keybinding:** `<leader>g`

```bash
# Jump back to the test file you last ran
# Useful when you're in implementation file
```

**Example workflow:**
1. In `user.test.js` → Run test → Fails
2. Switch to `user.js` → Fix code
3. Press `Space + g` → Back to `user.test.js`
4. Press `Space + l` → Re-run test

---

## 🎯 Common Use Cases

### Use Case 1: Test-Driven Development (TDD)

```bash
# Step 1: Write failing test
nvim tests/calculator.test.js
# Write: it('should add numbers', () => { expect(add(2,3)).toBe(5); })
Space + t    # Run test → RED (fails)

# Step 2: Implement feature
Switch to calculator.js
# Write: function add(a, b) { return a + b; }

# Step 3: Re-run test
Space + l    # Run test → GREEN (passes)

# Step 4: Repeat for next feature
```

---

### Use Case 2: Debugging Failing Tests

```bash
# CI shows failing tests
# Clone repo, open test file
nvim tests/auth.test.js

# Run failing test
Space + T    # Run all tests in file
# See which ones fail

# Position cursor on failing test
Space + t    # Run only that test
# Read error in tmux pane

# Fix code
# Press Space + l to verify fix
```

---

### Use Case 3: Pre-Commit Checks

```bash
# Before committing
Space + a    # Run full test suite

# Watch output in tmux pane
# All green? Commit!
# Any red? Fix first
```

---

### Use Case 4: Component Testing

```bash
# Working on React component
nvim src/Button.jsx

# Open test file
:e src/Button.test.jsx

# Run component tests
Space + T    # All Button tests

# Toggle between files
<C-^>        # Switch to last file
```

---

## 🧪 Supported Test Frameworks

vim-test auto-detects these frameworks:

### JavaScript/TypeScript
- **Jest** - Most common React/Node testing
- **Mocha** - Classic Node.js testing
- **Vitest** - Modern Vite-based testing
- **Jasmine** - Behavior-driven testing
- **Karma** - Browser testing

### Python
- **pytest** - Most popular Python testing
- **unittest** - Python standard library
- **nose/nose2** - Python test runner
- **Django** - Django test suite

### Ruby
- **RSpec** - Behavior-driven development
- **Minitest** - Ruby standard library
- **Cucumber** - Acceptance testing

### Go
- **go test** - Standard Go testing

### Rust
- **cargo test** - Cargo test runner

### PHP
- **PHPUnit** - PHP unit testing
- **Behat** - PHP acceptance testing

### Other Languages
- **Elixir** - ExUnit
- **C#** - xUnit, NUnit
- **Java** - JUnit, Maven, Gradle

**Auto-detection:** vim-test looks at your project structure and files to determine which framework to use.

---

## 💡 Pro Tips

### Tip 1: Keep Tmux Pane Visible

Set up your tmux layout so test output is always visible:
```bash
# Vertical split: Code left, tests right
# Horizontal split: Code top, tests bottom
```

### Tip 2: Focus on Failures

When running full suite, focus on failed tests:
```bash
Space + a    # Run all tests
# Scroll through tmux pane to find failures
# Position cursor on failed test in Neovim
Space + t    # Run just that test
```

### Tip 3: Test File Navigation

Quick switch between implementation and test:
```bash
# If following naming convention:
# file.js → file.test.js
# Use fuzzy finder:
Space + f + f
# Type: test
```

### Tip 4: Watch Mode Alternative

Instead of watch mode, use:
```bash
# Run test
Space + t
# Fix code
# Re-run
Space + l
# Faster than waiting for auto-rerun!
```

### Tip 5: Test Output in Quickfix

If you prefer quickfix over tmux pane:
```lua
-- Edit plugin config to use:
vim.cmd("let test#strategy = 'neovim'")
-- Instead of 'vimux'
```

---

## 🐛 Troubleshooting

### Issue: "No tmux runner pane found"

**Cause:** Neovim is not running inside tmux

**Solution:**
```bash
# Exit Neovim
:q

# Start tmux first
tmux

# Then start Neovim
nvim
```

---

### Issue: Tests don't run / wrong framework detected

**Cause:** Test framework not installed or vim-test can't detect it

**Solution:**
```bash
# Verify test framework is installed
npm list jest    # For JavaScript
pip list | grep pytest    # For Python

# Check test files are in standard locations
# Jest: __tests__/ or *.test.js
# pytest: test_*.py or *_test.py
```

---

### Issue: Test command is wrong

**Cause:** vim-test using default command, not your custom one

**Solution:**
```lua
-- In ~/.config/nvim/lua/plugins/vim-test.lua
-- Add custom test command
vim.cmd("let test#javascript#jest#options = '--coverage'")
vim.cmd("let test#python#pytest#options = '-v'")
```

---

### Issue: Tmux pane is too small

**Cause:** Default vimux height

**Solution:**
```lua
-- In the plugin config, add:
vim.cmd("let g:VimuxHeight = '40'")  -- 40% height
```

---

### Issue: Want vertical tmux split

**Cause:** Default is horizontal

**Solution:**
```lua
-- In the plugin config:
vim.cmd("let g:VimuxOrientation = 'v'")
```

---

### Issue: Tests run but no output shown

**Cause:** Tmux pane hidden or cleared

**Solution:**
```bash
# In tmux, show all panes:
Prefix + q    # Shows pane numbers
# Navigate to test pane
# Or run test again: Space + l
```

---

## 🔧 Customization

### Change Keybindings

Edit `~/.config/nvim/lua/plugins/vim-test.lua`:

```lua
-- Change to your preferred keys
vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Test Nearest" })
vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test File" })
vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Test Suite" })
```

### Custom Test Commands

```lua
-- Add framework-specific options
vim.cmd("let test#ruby#rspec#options = '--format documentation'")
vim.cmd("let test#javascript#jest#executable = 'npm test --'")
vim.cmd("let test#python#pytest#options = '-v --tb=short'")
```

### Different Test Strategy

Instead of tmux, use other strategies:

```lua
-- Neovim terminal (blocks until done)
vim.cmd("let test#strategy = 'neovim'")

-- Basic (shows output in Neovim)
vim.cmd("let test#strategy = 'basic'")

-- Dispatch (if you have vim-dispatch)
vim.cmd("let test#strategy = 'dispatch'")
```

---

## 📊 Strategy Comparison

| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| **vimux** (default) | Non-blocking, persistent output | Requires tmux | Most users |
| **neovim** | No tmux needed | Blocks Neovim | Quick tests |
| **basic** | Simple, built-in | Blocks Neovim | Beginners |

**Recommendation:** Stick with vimux (default). It's the best experience.

---

## 📖 Related Documentation

- [Testing Workflow](./08-TESTING-WORKFLOW.md) - Best practices for testing
- [Tmux Navigation](./03-TMUX-NAVIGATION.md) - Navigate to test pane easily
- [Quick Reference](./00-QUICK-REFERENCE.md) - All test keybindings

---

## 🔗 External Resources

- **vim-test:** https://github.com/vim-test/vim-test
- **vimux:** https://github.com/preservim/vimux
- **Test Framework Docs:** See your framework's official documentation

---

## 📋 Quick Command Reference

```bash
# Run tests
Space + t       # Test at cursor
Space + T       # Test file
Space + a       # All tests
Space + l       # Last test
Space + g       # Go to test file

# Tmux pane control
Prefix + z      # Zoom test pane
Prefix + x      # Close test pane
Prefix + arrow  # Resize pane

# Neovim window navigation
<C-h/j/k/l>     # Navigate to test pane
```

---

## 🎓 Learning Path

**Day 1:** Learn basic commands
```bash
Space + t    # Run single test
Space + l    # Re-run test
```

**Day 2:** Learn file-level testing
```bash
Space + T    # Test entire file
```

**Day 3:** Learn suite testing
```bash
Space + a    # Run all tests
```

**Day 4:** Master the workflow
- TDD cycle: Write test → Run → Fix → Re-run
- Fast iteration with `Space + l`

---

**Last Updated:** March 20, 2026  
**Plugin Version:** Latest from lazy.nvim  
**Status:** ✅ Fully Configured  
**Requirement:** ⚠️ Must run Neovim inside tmux
