# Neovim configuration

A Neovim 0.11+ setup for C / C++ / Java development with a first-class competitive-programming workflow. Modular lazy.nvim spec files, Mason-managed toolchains, LSP via the modern `vim.lsp.config` API.

## Directory layout

```
~/.config/nvim/
├── init.lua                  entry point: options → keymaps → autocmds → lazy
├── lua/
│   ├── config/
│   │   ├── options.lua       core vim options
│   │   ├── keymaps.lua       global keymaps (non-plugin)
│   │   ├── autocmds.lua      autocmds incl. CP template insertion
│   │   └── lazy.lua          bootstraps lazy.nvim
│   ├── plugins/              one file per concern (see plugins.md)
│   │   ├── colorscheme.lua
│   │   ├── ui.lua
│   │   ├── editor.lua
│   │   ├── lsp.lua
│   │   ├── completion.lua
│   │   ├── dap.lua
│   │   ├── terminal.lua
│   │   ├── compile-run.lua
│   │   ├── competitest.lua
│   │   └── jdtls.lua
│   └── cp/
│       └── runner.lua        custom compile/run for C/C++/Java/Python
├── ftplugin/
│   ├── c.lua / cpp.lua / python.lua   4-space indent
│   ├── lua.lua                        2-space indent
│   └── java.lua                       nvim-jdtls bootstrap
├── templates/                cp.cpp, cp.c, Main.java, cp.py
├── include/bits/stdc++.h     Apple-clang shim for CP
├── docs/                     you are here
└── lazy-lock.json
```

## First launch

1. Start `nvim`. lazy.nvim bootstraps itself (see `lua/config/lazy.lua`) and installs every plugin. This takes a minute on first run.
2. When plugins are ready, Mason installs the LSP servers and tools listed in `lua/plugins/lsp.lua:18` and `lua/plugins/lsp.lua:28`. Run `:Mason` to watch progress or fix failures.
3. Treesitter compiles parsers on demand; `:TSUpdate` forces a refresh.
4. **Java requires a system JDK 21** — `jdtls` will exit code 1 without one. See [`troubleshooting.md`](troubleshooting.md#java-lsp-jdtls-quits-exit-1).
5. **C++ on macOS** needs the bundled `<bits/stdc++.h>` shim. It ships in `include/` and is already wired into the clangd config, runner, and competitest (see [`competitive-programming.md`](competitive-programming.md#bitsstdch-on-apple-clang)).

## Topic docs

- [`keymaps.md`](keymaps.md) — every leader group and binding
- [`plugins.md`](plugins.md) — what each plugin file adds
- [`lsp.md`](lsp.md) — LSP stack, Mason tools, format-on-save
- [`competitive-programming.md`](competitive-programming.md) — templates, test cases, Competitive Companion, custom runner
- [`debugging.md`](debugging.md) — nvim-dap + codelldb
- [`troubleshooting.md`](troubleshooting.md) — real problems hit during setup and their fixes

## Conventions

- Leader key is `<space>` (set in `init.lua` before lazy).
- All plugin specs live under `lua/plugins/` and are auto-loaded by lazy.nvim.
- Groups under `<leader>` are labeled via which-key in `lua/plugins/ui.lua:84-94`.
