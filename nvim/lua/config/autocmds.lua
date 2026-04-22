local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank.
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function() vim.highlight.on_yank({ timeout = 180 }) end,
})

-- Trim trailing whitespace on save (skip diffs/markdown).
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  callback = function()
    local ft = vim.bo.filetype
    if ft == "diff" or ft == "markdown" then return end
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Restore cursor position.
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create parent dirs on save.
autocmd("BufWritePre", {
  group = augroup("AutoMkdir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+:[\\/][\\/]") then return end
    local dir = vim.fn.fnamemodify(vim.uv.fs_realpath(args.match) or args.match, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- Close some filetypes with <q>.
autocmd("FileType", {
  group = augroup("CloseWithQ", { clear = true }),
  pattern = { "help", "lspinfo", "man", "qf", "query", "checkhealth", "dap-float" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

-- Insert boilerplate on new C++/Java file (competitive programming templates).
autocmd("BufNewFile", {
  group = augroup("CpTemplates", { clear = true }),
  pattern = { "*.cpp", "*.cc", "*.cxx" },
  command = "silent! 0r " .. vim.fn.stdpath("config") .. "/templates/cp.cpp",
})

autocmd("BufNewFile", {
  group = augroup("CpTemplatesJava", { clear = true }),
  pattern = "*.java",
  callback = function(args)
    local tpl = vim.fn.stdpath("config") .. "/templates/Main.java"
    if vim.fn.filereadable(tpl) == 1 then
      local lines = vim.fn.readfile(tpl)
      local classname = vim.fn.fnamemodify(args.file, ":t:r")
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("__CLASSNAME__", classname)
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
  end,
})
