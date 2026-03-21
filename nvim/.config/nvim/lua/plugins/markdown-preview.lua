-- ============================================================================
-- Markdown Preview & Rendering Plugin
-- ============================================================================
--
-- Purpose:
--   Professional Markdown viewing and editing in Neovim with multiple options.
--   This setup provides GitHub-style rendering and live preview capabilities.
--
-- Options Provided:
--   1. render-markdown.nvim - GitHub-style rendering INSIDE Neovim (recommended)
--   2. markdown-preview.nvim - Live preview in browser (traditional)
--   3. Typora integration - Open in Typora with a keybinding
--
-- ============================================================================

return {
  -- ==========================================================================
  -- OPTION 1: Render-Markdown (GitHub-style rendering IN Neovim) ⭐ RECOMMENDED
  -- ==========================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 
      "nvim-treesitter/nvim-treesitter", 
      "nvim-tree/nvim-web-devicons" 
    },
    ft = { "markdown" }, -- Only load for markdown files
    
    opts = {
      -- Enable GitHub-flavored markdown rendering
      -- This makes markdown look beautiful directly in Neovim!
      
      -- Heading styles (like GitHub)
      headings = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      
      -- Code block rendering
      code = {
        -- Show language name in code blocks
        sign = true,
        -- Highlight code blocks with proper syntax
        enabled = true,
        -- Style for inline code
        style = 'normal',
        width = 'block',
      },
      
      -- Checkbox rendering (like GitHub tasks)
      checkbox = {
        unchecked = '󰄱 ',
        checked = '󰱒 ',
      },
      
      -- Bullet point styles
      bullet = '●',
      
      -- Table border rendering
      pipe_table = {
        style = 'normal',
      },
      
      -- Quote block rendering
      quote = '▋',
    },
    
    config = function(_, opts)
      require('render-markdown').setup(opts)
      
      -- Toggle rendering on/off with <leader>mr
      vim.keymap.set('n', '<leader>mr', ':RenderMarkdown toggle<CR>', {
        desc = "Toggle Markdown Rendering",
        silent = true
      })
    end,
  },

  -- ==========================================================================
  -- OPTION 2: Markdown Preview in Browser (Traditional approach)
  -- ==========================================================================
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" }, -- Only load for markdown files
    build = function() 
      vim.fn["mkdp#util#install"]() 
    end,
    
    config = function()
      -- Browser preview settings
      vim.g.mkdp_auto_start = 0  -- Don't auto-open preview
      vim.g.mkdp_auto_close = 1  -- Auto-close when changing buffers
      vim.g.mkdp_refresh_slow = 0  -- Real-time updates
      vim.g.mkdp_browser = ''  -- Use default browser
      vim.g.mkdp_echo_preview_url = 1  -- Show preview URL
      
      -- GitHub-style rendering
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_theme = 'dark'  -- or 'light'
      
      -- Keybindings for browser preview
      vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', {
        desc = "Markdown Preview (Browser)",
        silent = true
      })
      
      vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', {
        desc = "Stop Markdown Preview",
        silent = true
      })
      
      vim.keymap.set('n', '<leader>mt', ':MarkdownPreviewToggle<CR>', {
        desc = "Toggle Markdown Preview",
        silent = true
      })
    end,
  },

  -- ==========================================================================
  -- OPTION 3: Typora Integration (Open in external app)
  -- ==========================================================================
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Keybinding to open current markdown file in Typora
      vim.keymap.set('n', '<leader>mo', function()
        local file = vim.fn.expand('%:p')
        if vim.fn.filereadable(file) == 1 then
          -- Open file in Typora (detached process, won't block Neovim)
          vim.fn.jobstart({ 'typora', file }, { detach = true })
          vim.notify('Opened in Typora: ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
        else
          vim.notify('Current buffer is not a file', vim.log.levels.WARN)
        end
      end, {
        desc = "Open in Typora",
        silent = true
      })
      
      -- Open markdown file under cursor in Typora
      vim.keymap.set('n', '<leader>mO', function()
        local file = vim.fn.expand('<cfile>')
        if vim.fn.filereadable(file) == 1 then
          vim.fn.jobstart({ 'typora', file }, { detach = true })
          vim.notify('Opened in Typora: ' .. file, vim.log.levels.INFO)
        else
          vim.notify('File not found: ' .. file, vim.log.levels.WARN)
        end
      end, {
        desc = "Open File Under Cursor in Typora",
        silent = true
      })
    end,
  },

  -- ==========================================================================
  -- BONUS: Better Markdown Editing Features
  -- ==========================================================================
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Auto-format markdown tables on save
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          -- Enable spell checking for markdown
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          
          -- Better text wrapping for markdown
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          
          -- Conceal markdown syntax for cleaner view
          vim.opt_local.conceallevel = 2
        end,
      })
      
      -- Quick markdown formatting keybindings (in markdown files only)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          
          -- Bold selected text
          vim.keymap.set('v', '<leader>mb', 'c**<C-r>"**<Esc>', {
            desc = "Bold Selection",
            buffer = bufnr,
            silent = true
          })
          
          -- Italic selected text
          vim.keymap.set('v', '<leader>mi', 'c*<C-r>"*<Esc>', {
            desc = "Italic Selection",
            buffer = bufnr,
            silent = true
          })
          
          -- Code inline
          vim.keymap.set('v', '<leader>mc', 'c`<C-r>"`<Esc>', {
            desc = "Code Selection",
            buffer = bufnr,
            silent = true
          })
          
          -- Create link from selection
          vim.keymap.set('v', '<leader>ml', 'c[<C-r>"]()<Esc>i', {
            desc = "Create Link",
            buffer = bufnr,
            silent = true
          })
        end,
      })
    end,
  },
}

-- ============================================================================
-- HOW PROS READ MARKDOWN IN NEOVIM
-- ============================================================================
--
-- METHOD 1: render-markdown.nvim (MODERN & RECOMMENDED) ⭐
-- ---------------------------------------------------------
-- What it does:
--   - Renders markdown beautifully INSIDE Neovim
--   - GitHub-style headings, code blocks, tables, checkboxes
--   - No external apps needed
--   - Live rendering as you type
--
-- Usage:
--   1. Open any .md file in Neovim
--   2. Rendering happens automatically
--   3. Press <leader>mr to toggle rendering on/off
--   4. Edit normally - rendering updates in real-time
--
-- Pros:
--   ✅ Stay in Neovim (no context switching)
--   ✅ Fast and lightweight
--   ✅ Beautiful GitHub-style rendering
--   ✅ Works offline
--
-- Cons:
--   ❌ Not a true WYSIWYG editor (but close!)
--
--
-- METHOD 2: markdown-preview.nvim (TRADITIONAL)
-- ----------------------------------------------
-- What it does:
--   - Opens live preview in your browser
--   - Real-time updates as you type
--   - Exact GitHub markdown rendering
--
-- Usage:
--   1. Open .md file
--   2. Press <leader>mp to start preview
--   3. Edit in Neovim, see changes in browser
--   4. Press <leader>ms to stop preview
--
-- Pros:
--   ✅ Exact GitHub rendering
--   ✅ Full HTML/CSS support
--   ✅ Great for documentation writing
--
-- Cons:
--   ❌ Requires switching between Neovim and browser
--   ❌ Uses more resources
--
--
-- METHOD 3: Typora (WYSIWYG EDITOR)
-- ----------------------------------
-- What it does:
--   - Opens file in Typora app
--   - Full WYSIWYG editing
--   - Best for non-technical users
--
-- Usage:
--   1. Open .md file in Neovim
--   2. Press <leader>mo to open in Typora
--   3. Edit in Typora with full visual editing
--   4. Changes sync back to file
--
-- Pros:
--   ✅ True WYSIWYG experience
--   ✅ Best for complex documents
--   ✅ Great UI/UX
--
-- Cons:
--   ❌ Leaves Neovim workflow
--   ❌ Proprietary software
--   ❌ Slower than terminal
--
-- ============================================================================
-- KEYBINDINGS REFERENCE
-- ============================================================================
--
-- MARKDOWN RENDERING (render-markdown.nvim):
--   <leader>mr    - Toggle GitHub-style rendering in Neovim
--
-- BROWSER PREVIEW (markdown-preview.nvim):
--   <leader>mp    - Start browser preview
--   <leader>ms    - Stop browser preview
--   <leader>mt    - Toggle browser preview
--
-- TYPORA INTEGRATION:
--   <leader>mo    - Open current file in Typora
--   <leader>mO    - Open file under cursor in Typora
--
-- MARKDOWN FORMATTING (in markdown files only):
--   <leader>mb    - Bold selected text (visual mode)
--   <leader>mi    - Italic selected text (visual mode)
--   <leader>mc    - Code selected text (visual mode)
--   <leader>ml    - Create link from selection (visual mode)
--
-- Note: <leader> is typically Space in LazyVim
--
-- ============================================================================
-- RECOMMENDED WORKFLOW
-- ============================================================================
--
-- For Most Users (Recommended):
--   1. Use render-markdown.nvim for 90% of markdown reading/editing
--      - Beautiful rendering in Neovim
--      - Fast and efficient
--   2. Use <leader>mp for final preview when publishing
--      - Verify exact GitHub rendering
--   3. Keep Typora for when non-devs need to edit
--
-- For Documentation Writers:
--   1. Write in Neovim with render-markdown
--   2. Use <leader>mp for live preview while writing
--   3. Keep browser and Neovim side-by-side
--
-- For Quick Reads:
--   1. Just open the .md file in Neovim
--   2. render-markdown makes it readable immediately
--   3. No extra commands needed
--
-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================
--
-- Issue: render-markdown not showing icons/formatting
-- Solution: Make sure you have a Nerd Font installed
--   - LazyVim requires Nerd Fonts
--   - Check: https://www.nerdfonts.com
--
-- Issue: markdown-preview not opening in browser
-- Solution: Run :call mkdp#util#install() manually
--   - Then restart Neovim
--   - Check your default browser is set
--
-- Issue: Typora keybinding not working
-- Solution: Verify Typora is installed
--   - Run: which typora
--   - Install if missing: https://typora.io
--
-- Issue: Want different preview theme
-- Solution: Change vim.g.mkdp_theme above
--   - Options: 'dark' or 'light'
--
-- Issue: Rendering makes editing harder
-- Solution: Toggle rendering off with <leader>mr
--   - Edit with rendering off
--   - Toggle back on to preview
--
-- ============================================================================
-- ADDITIONAL FEATURES
-- ============================================================================
--
-- This configuration also enables:
--   ✅ Spell checking in markdown files
--   ✅ Better text wrapping (respects words)
--   ✅ Syntax concealing for cleaner view
--   ✅ Quick formatting keybindings
--
-- Auto-enabled when you open .md files!
--
-- ============================================================================
