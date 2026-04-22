-- Lightweight compile-and-run for C / C++ / Java.
-- Runs the compile command, then executes the binary in a floating toggleterm,
-- feeding `input.txt` on stdin when present.
local M = {}

local function buf_info()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then return nil, "Save the buffer first." end
  local dir = vim.fn.fnamemodify(path, ":p:h")
  local name = vim.fn.fnamemodify(path, ":t")
  local stem = vim.fn.fnamemodify(path, ":t:r")
  local ext = vim.fn.fnamemodify(path, ":e")
  return { path = path, dir = dir, name = name, stem = stem, ext = ext }
end

local function shquote(s) return vim.fn.shellescape(s) end

local LANG = {
  c = {
    match = function(b) return b.ext == "c" end,
    compile = function(b)
      return string.format("cd %s && gcc -O2 -std=gnu17 -Wall -Wextra -o %s %s -lm",
        shquote(b.dir), shquote(b.stem), shquote(b.name))
    end,
    run = function(b) return string.format("./%s", shquote(b.stem)) end,
  },
  cpp = {
    match = function(b) return b.ext == "cpp" or b.ext == "cc" or b.ext == "cxx" end,
    compile = function(b)
      local includes = vim.fn.stdpath("config") .. "/include"
      return string.format(
        "cd %s && g++ -O2 -std=gnu++20 -Wall -Wextra -Wshadow -DLOCAL -I%s -o %s %s",
        shquote(b.dir), shquote(includes), shquote(b.stem), shquote(b.name))
    end,
    run = function(b) return string.format("./%s", shquote(b.stem)) end,
  },
  java = {
    match = function(b) return b.ext == "java" end,
    compile = function(b)
      return string.format("cd %s && javac %s", shquote(b.dir), shquote(b.name))
    end,
    run = function(b)
      return string.format("cd %s && java %s", shquote(b.dir), shquote(b.stem))
    end,
  },
  python = {
    match = function(b) return b.ext == "py" end,
    compile = function(_) return "true" end,
    run = function(b) return string.format("python3 %s", shquote(b.path)) end,
  },
}

local function detect(b)
  for _, spec in pairs(LANG) do
    if spec.match(b) then return spec end
  end
end

local function input_file(dir)
  for _, name in ipairs({ "input.txt", "in.txt", "stdin.txt" }) do
    local p = dir .. "/" .. name
    if vim.fn.filereadable(p) == 1 then return p end
  end
end

local function term_exec(cmd, opts)
  opts = opts or {}
  local ok, tt = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.cmd("botright split | terminal " .. cmd)
    return
  end
  local Terminal = tt.Terminal
  local t = Terminal:new({
    cmd = cmd,
    direction = opts.direction or "float",
    close_on_exit = false,
    hidden = true,
    float_opts = { border = "rounded", width = math.floor(vim.o.columns * 0.85), height = math.floor(vim.o.lines * 0.8) },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.keymap.set({ "n", "t" }, "q", function() term:close() end, { buffer = term.bufnr })
    end,
  })
  t:toggle()
end

function M.compile()
  local b, err = buf_info(); if not b then return vim.notify(err, vim.log.levels.WARN) end
  vim.cmd("write")
  local spec = detect(b); if not spec then return vim.notify("Unsupported filetype", vim.log.levels.WARN) end
  local cmd = spec.compile(b)
  term_exec(cmd)
end

function M.run()
  local b, err = buf_info(); if not b then return vim.notify(err, vim.log.levels.WARN) end
  vim.cmd("write")
  local spec = detect(b); if not spec then return vim.notify("Unsupported filetype", vim.log.levels.WARN) end

  local input = input_file(b.dir)
  local run_cmd = spec.run(b)
  if input then run_cmd = run_cmd .. " < " .. shquote(input) end

  local full
  if spec.compile(b) == "true" then
    full = string.format("cd %s && %s", shquote(b.dir), run_cmd)
  else
    full = string.format("%s && time %s", spec.compile(b), run_cmd)
  end
  term_exec(full)
end

function M.edit_input()
  local b, err = buf_info(); if not b then return vim.notify(err, vim.log.levels.WARN) end
  vim.cmd("edit " .. vim.fn.fnameescape(b.dir .. "/input.txt"))
end

function M.edit_output()
  local b, err = buf_info(); if not b then return vim.notify(err, vim.log.levels.WARN) end
  vim.cmd("edit " .. vim.fn.fnameescape(b.dir .. "/expected_output.txt"))
end

function M.diff_output()
  local b, err = buf_info(); if not b then return vim.notify(err, vim.log.levels.WARN) end
  local spec = detect(b); if not spec then return vim.notify("Unsupported filetype", vim.log.levels.WARN) end
  local input = input_file(b.dir) or "/dev/null"
  local compile = spec.compile(b)
  local run = spec.run(b) .. " < " .. shquote(input)
  local expected = b.dir .. "/expected_output.txt"
  if vim.fn.filereadable(expected) == 0 then
    return vim.notify("No expected_output.txt in " .. b.dir, vim.log.levels.WARN)
  end
  local actual = vim.fn.tempname()
  local full = string.format("%s && %s > %s 2>&1 && diff -u %s %s",
    compile, run, shquote(actual), shquote(expected), shquote(actual))
  term_exec(full)
end

return M
