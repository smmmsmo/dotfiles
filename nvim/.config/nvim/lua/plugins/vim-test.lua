-- ============================================================================
-- Vim-Test Plugin Configuration
-- ============================================================================
--
-- Plugin: vim-test
-- Repository: https://github.com/vim-test/vim-test
--
-- Purpose:
--   Run tests directly from Neovim without leaving your editor. This plugin
--   provides a wrapper around various test runners (RSpec, Jest, pytest, etc.)
--   and integrates with tmux via vimux to display test output in a split pane.
--
-- Features:
--   - Run nearest test to cursor
--   - Run entire test file
--   - Run full test suite
--   - Re-run last test
--   - Jump to last test file
--   - Works with multiple test frameworks automatically
--
-- ============================================================================

return {
  -- Main test runner plugin
  "vim-test/vim-test",
  
  -- Dependencies required for tmux integration
  dependencies = {
    -- Vimux: Interact with tmux from vim
    -- Opens test output in a tmux pane instead of blocking Neovim
    "preservim/vimux"
  },
  
  -- Configuration function
  config = function()
    -- ========================================================================
    -- KEYBINDINGS
    -- ========================================================================
    
    -- Run the test nearest to the cursor
    -- Example: If cursor is inside a specific test function, run only that test
    vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { 
      desc = "Run Nearest Test",
      silent = true 
    })
    
    -- Run all tests in the current file
    vim.keymap.set("n", "<leader>T", ":TestFile<CR>", { 
      desc = "Run Test File",
      silent = true 
    })
    
    -- Run the entire test suite for the project
    vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", { 
      desc = "Run All Tests",
      silent = true 
    })
    
    -- Re-run the last test that was executed
    -- Useful for quickly iterating on a failing test
    vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { 
      desc = "Run Last Test",
      silent = true 
    })
    
    -- Visit/jump to the last test file that was run
    vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", { 
      desc = "Go to Last Test",
      silent = true 
    })
    
    -- ========================================================================
    -- STRATEGY CONFIGURATION
    -- ========================================================================
    
    -- Use vimux as the test strategy
    -- This runs tests in a tmux pane instead of blocking Neovim
    -- The output appears in a split tmux pane that stays open
    vim.cmd("let test#strategy = 'vimux'")
    
    -- ========================================================================
    -- OPTIONAL CONFIGURATIONS (Commented out - uncomment if needed)
    -- ========================================================================
    
    -- Set the height of the tmux pane for test output (default: 20%)
    -- vim.cmd("let g:VimuxHeight = '30'")
    
    -- Open tmux pane in a vertical split instead of horizontal
    -- vim.cmd("let g:VimuxOrientation = 'v'")
    
    -- Use nearest pane instead of creating a new one
    -- vim.cmd("let g:VimuxUseNearest = 1")
    
    -- Clear test output before running new test
    -- vim.cmd("let test#preserve_screen = 0")
    
    -- Set custom test command for specific frameworks
    -- Example for RSpec with custom formatting:
    -- vim.cmd("let test#ruby#rspec#options = '--format documentation'")
    
    -- Example for Jest with coverage:
    -- vim.cmd("let test#javascript#jest#options = '--coverage'")
  end,
}

-- ============================================================================
-- SUPPORTED TEST FRAMEWORKS
-- ============================================================================
--
-- vim-test automatically detects and supports these test runners:
--
-- Languages & Frameworks:
--   Ruby:       RSpec, Minitest, Cucumber, Rails
--   JavaScript: Jest, Mocha, Jasmine, Karma, Vitest
--   Python:     pytest, nose, Django
--   Go:         go test
--   Rust:       cargo test
--   Elixir:     ExUnit
--   PHP:        PHPUnit, Behat
--   C#:         xUnit, NUnit
--   Java:       JUnit, Maven, Gradle
--   And many more...
--
-- The plugin auto-detects which test runner to use based on your project.
--
-- ============================================================================
-- USAGE GUIDE
-- ============================================================================
--
-- 1. RUNNING TESTS:
--    - Position cursor inside a test function → Press <leader>t
--    - Open any test file → Press <leader>T to run entire file
--    - Press <leader>a to run all tests in the project
--
-- 2. VIEWING OUTPUT:
--    - Tests run in a tmux split pane (via vimux)
--    - Pane stays open so you can see results
--    - Red/green output shows pass/fail status
--
-- 3. ITERATING ON FAILING TESTS:
--    - Fix your code
--    - Press <leader>l to re-run the last test
--    - No need to navigate back to the test file
--
-- 4. TMUX INTEGRATION:
--    - Requires running Neovim inside tmux
--    - First test run creates a new tmux pane
--    - Subsequent tests reuse the same pane
--    - Close pane with: Ctrl+b then x (standard tmux)
--
-- ============================================================================
-- KEYBINDINGS REFERENCE
-- ============================================================================
--
-- | Key         | Command        | Action                              |
-- |-------------|----------------|-------------------------------------|
-- | <leader>t   | :TestNearest   | Run test nearest to cursor          |
-- | <leader>T   | :TestFile      | Run all tests in current file       |
-- | <leader>a   | :TestSuite     | Run entire test suite               |
-- | <leader>l   | :TestLast      | Re-run last test                    |
-- | <leader>g   | :TestVisit     | Jump to last test file              |
--
-- Note: <leader> is typically the spacebar in LazyVim
--
-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================
--
-- Issue: "No tmux runner pane found"
-- Solution: Make sure you're running Neovim inside a tmux session
--   Start tmux: tmux
--   Start Neovim: nvim
--
-- Issue: Tests don't run or wrong test runner is used
-- Solution: Check that your project has the correct test files/config
--   - RSpec: spec/ directory with *_spec.rb files
--   - Jest: package.json with jest config
--   - pytest: test_*.py or *_test.py files
--
-- Issue: Want to use different test strategy (not tmux)
-- Solution: Change the strategy setting:
--   vim.cmd("let test#strategy = 'neovim'")  -- Use Neovim's :terminal
--   vim.cmd("let test#strategy = 'basic'")   -- Block Neovim and show output
--
-- Issue: Vimux pane orientation is wrong
-- Solution: Uncomment and modify VimuxOrientation setting above
--
-- ============================================================================
-- CUSTOMIZATION EXAMPLES
-- ============================================================================
--
-- 1. Change tmux pane size:
--    vim.cmd("let g:VimuxHeight = '40'")  -- 40% of screen height
--
-- 2. Run tests with coverage:
--    vim.cmd("let test#python#pytest#options = '--cov'")
--
-- 3. Use verbose output:
--    vim.cmd("let test#ruby#rspec#options = '-f d'")  -- RSpec documentation format
--
-- 4. Custom test command:
--    vim.cmd("let test#ruby#rspec#executable = 'bundle exec rspec'")
--
-- ============================================================================
