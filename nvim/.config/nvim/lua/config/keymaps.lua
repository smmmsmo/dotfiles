-- ============================================================================
-- Keymaps Configuration
-- ============================================================================
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- ============================================================================
-- Better Navigation
-- ============================================================================

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down (Centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up (Centered)" })

-- Centered search navigation
map("n", "n", "nzzzv", { desc = "Next Search (Centered)" })
map("n", "N", "Nzzzv", { desc = "Prev Search (Centered)" })

-- Better page up/down
map("n", "<C-f>", "<C-f>zz", { desc = "Page Down (Centered)" })
map("n", "<C-b>", "<C-b>zz", { desc = "Page Up (Centered)" })

-- Move to start/end of line
map({ "n", "x", "o" }, "H", "^", { desc = "Start of Line" })
map({ "n", "x", "o" }, "L", "$", { desc = "End of Line" })

-- ============================================================================
-- Better Editing
-- ============================================================================

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlight" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlight" })

-- Better indenting (keeps selection)
map("v", "<", "<gv", { desc = "Indent Left" })
map("v", ">", ">gv", { desc = "Indent Right" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Duplicate lines
map("n", "<A-S-j>", "<cmd>t.<CR>", { desc = "Duplicate Line Down" })
map("n", "<A-S-k>", "<cmd>t.-1<CR>", { desc = "Duplicate Line Up" })
map("v", "<A-S-j>", ":t'><CR>gv", { desc = "Duplicate Selection Down" })
map("v", "<A-S-k>", ":t'<-1<CR>gv", { desc = "Duplicate Selection Up" })

-- Join lines and keep cursor position
map("n", "J", "mzJ`z", { desc = "Join Lines" })

-- Add blank lines
map("n", "<leader>o", "o<Esc>k", { desc = "Add Line Below" })
map("n", "<leader>O", "O<Esc>j", { desc = "Add Line Above" })

-- ============================================================================
-- Clipboard & Paste
-- ============================================================================

-- Paste without yanking in visual mode
map("x", "p", '"_dP', { desc = "Paste Without Yanking" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete Without Yanking" })

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to System Clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy Line to System Clipboard" })

-- Paste from system clipboard
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from System Clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste Before from System Clipboard" })

-- ============================================================================
-- Buffer Management
-- ============================================================================

-- Buffer navigation (LazyVim already has <S-h> and <S-l>)
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- Close buffer
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Delete Buffer (Force)" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Delete Other Buffers" })

-- ============================================================================
-- Window Management
-- ============================================================================

-- Split windows
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split Vertical" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split Horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal Window Size" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close Window" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close Other Windows" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Width" })

-- Maximize window
map("n", "<leader>wm", "<C-w>_<C-w>|", { desc = "Maximize Window" })

-- ============================================================================
-- Quick Save & Quit
-- ============================================================================

map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save" })
map("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Save All" })
map("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and Quit" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit All (Force)" })

-- ============================================================================
-- Select All
-- ============================================================================

map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- ============================================================================
-- Quick Fix & Location List
-- ============================================================================

map("n", "<leader>qn", "<cmd>cnext<CR>zz", { desc = "Next Quickfix" })
map("n", "<leader>qp", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open Quickfix" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close Quickfix" })

map("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "Next Location" })
map("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "Prev Location" })
map("n", "<leader>lo", "<cmd>lopen<CR>", { desc = "Open Location List" })
map("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Close Location List" })

-- ============================================================================
-- Undo/Redo
-- ============================================================================

map("n", "U", "<C-r>", { desc = "Redo" })

-- ============================================================================
-- Better Escape
-- ============================================================================

map("i", "jk", "<Esc>", { desc = "Escape" })
map("i", "kj", "<Esc>", { desc = "Escape" })

-- ============================================================================
-- Toggle Options
-- ============================================================================

map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle Wrap" })
map("n", "<leader>un", "<cmd>set number!<CR>", { desc = "Toggle Line Numbers" })
map("n", "<leader>ur", "<cmd>set relativenumber!<CR>", { desc = "Toggle Relative Numbers" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle Spell" })
map("n", "<leader>uc", "<cmd>set cursorline!<CR>", { desc = "Toggle Cursorline" })
map("n", "<leader>ul", "<cmd>set list!<CR>", { desc = "Toggle List Chars" })
map("n", "<leader>ui", "<cmd>IBLToggle<CR>", { desc = "Toggle Indent Lines" })

-- ============================================================================
-- LSP Keymaps (Additional)
-- ============================================================================

map("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
map("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "Mason" })
map("n", "<leader>cL", "<cmd>LspLog<CR>", { desc = "LSP Log" })
map("n", "<leader>cR", "<cmd>LspRestart<CR>", { desc = "LSP Restart" })

-- ============================================================================
-- Diagnostics
-- ============================================================================

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- ============================================================================
-- Insert Mode Helpers
-- ============================================================================

-- Navigate in insert mode
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

-- Delete word in insert mode
map("i", "<C-w>", "<C-o>diw", { desc = "Delete Word" })

-- ============================================================================
-- Command Mode Helpers
-- ============================================================================

map("c", "<C-a>", "<Home>", { desc = "Start of Line" })
map("c", "<C-e>", "<End>", { desc = "End of Line" })
map("c", "<C-h>", "<Left>", { desc = "Move Left" })
map("c", "<C-l>", "<Right>", { desc = "Move Right" })

-- ============================================================================
-- Misc
-- ============================================================================

-- Source current file
map("n", "<leader>cx", "<cmd>source %<CR>", { desc = "Source Current File" })

-- Open file explorer at current file
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Explorer" })
map("n", "<leader>E", "<cmd>Neotree reveal<CR>", { desc = "Reveal in Explorer" })

-- Lazy plugin manager
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy Plugin Manager" })

-- Change working directory to current file
map("n", "<leader>cD", "<cmd>cd %:p:h<CR><cmd>pwd<CR>", { desc = "Change to File Directory" })
