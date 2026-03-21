-- ============================================================================
-- Autocommands Configuration
-- ============================================================================
-- Autocommands are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ============================================================================
-- General Autocommands
-- ============================================================================

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight text on yank",
})

-- Auto resize splits when terminal is resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Resize splits on terminal resize",
})

-- Close certain filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with q",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  group = augroup("last_location", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening buffer",
})

-- Auto create parent directories when saving
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create parent directories",
})

-- Check if file changed outside of neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check if file changed outside of neovim",
})

-- ============================================================================
-- Filetype-specific Settings
-- ============================================================================

-- Markdown settings
autocmd("FileType", {
  group = augroup("markdown_settings", { clear = true }),
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.conceallevel = 2
    vim.opt_local.linebreak = true
  end,
  desc = "Markdown specific settings",
})

-- Git commit message settings
autocmd("FileType", {
  group = augroup("gitcommit_settings", { clear = true }),
  pattern = { "gitcommit", "gitrebase" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "72"
    vim.opt_local.textwidth = 72
  end,
  desc = "Git commit message settings",
})

-- JSON settings (no concealing)
autocmd("FileType", {
  group = augroup("json_settings", { clear = true }),
  pattern = { "json", "jsonc" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "JSON settings",
})

-- Makefile settings (use tabs)
autocmd("FileType", {
  group = augroup("makefile_settings", { clear = true }),
  pattern = { "make", "makefile", "Makefile" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Makefile settings",
})

-- Python settings
autocmd("FileType", {
  group = augroup("python_settings", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.colorcolumn = "88"  -- Black formatter default
  end,
  desc = "Python settings",
})

-- Go settings
autocmd("FileType", {
  group = augroup("go_settings", { clear = true }),
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Go settings",
})

-- Java settings
autocmd("FileType", {
  group = augroup("java_settings", { clear = true }),
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "120"
  end,
  desc = "Java settings",
})

-- C/C++ settings
autocmd("FileType", {
  group = augroup("cpp_settings", { clear = true }),
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "80"
  end,
  desc = "C/C++ settings",
})

-- ============================================================================
-- Terminal Autocommands
-- ============================================================================

-- Enter insert mode when opening terminal
autocmd("TermOpen", {
  group = augroup("term_insert", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-- Close terminal without showing exit code
autocmd("TermClose", {
  group = augroup("term_close", { clear = true }),
  pattern = "*",
  callback = function(event)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(event.buf, { force = true })
    end
  end,
  desc = "Close terminal on success",
})

-- ============================================================================
-- LSP Autocommands
-- ============================================================================

-- Show diagnostics on cursor hold
autocmd("CursorHold", {
  group = augroup("show_diagnostics", { clear = true }),
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
  desc = "Show diagnostics on cursor hold",
})

-- Format on save (handled by conform.nvim, but this is a fallback)
autocmd("BufWritePre", {
  group = augroup("format_on_save", { clear = true }),
  callback = function()
    -- Check if conform is available and let it handle formatting
    local ok, conform = pcall(require, "conform")
    if not ok then
      -- Fallback to LSP formatting if conform is not available
      vim.lsp.buf.format({ async = false })
    end
  end,
  desc = "Format on save",
})

-- ============================================================================
-- Large File Handling
-- ============================================================================

-- Disable features for large files
autocmd("BufReadPre", {
  group = augroup("large_file", { clear = true }),
  callback = function(event)
    local file = event.match
    local size = vim.fn.getfsize(file)
    if size > 1024 * 1024 then -- 1MB
      vim.opt_local.syntax = "off"
      vim.opt_local.filetype = ""
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.foldmethod = "manual"
      vim.b.large_file = true
      vim.notify("Large file detected. Some features disabled.", vim.log.levels.WARN)
    end
  end,
  desc = "Optimize for large files",
})

-- ============================================================================
-- Auto Save
-- ============================================================================

-- Auto save on focus lost (optional - uncomment if desired)
-- autocmd({ "FocusLost", "BufLeave" }, {
--   group = augroup("auto_save", { clear = true }),
--   callback = function()
--     if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
--       vim.api.nvim_command("silent! update")
--     end
--   end,
--   desc = "Auto save on focus lost",
-- })

-- ============================================================================
-- Clean Up
-- ============================================================================

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    -- Don't trim whitespace in certain filetypes
    local exclude_ft = { "markdown", "diff" }
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      return
    end
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace",
})
