# Debugging

All DAP wiring lives in `lua/plugins/dap.lua`.

## Stack

- **mfussenegger/nvim-dap** — core DAP client.
- **rcarriga/nvim-dap-ui** + **nvim-neotest/nvim-nio** — windowed UI.
- **theHamsta/nvim-dap-virtual-text** — inline value annotations.
- **jay-babu/mason-nvim-dap.nvim** — ensures `codelldb`, `javadbg`, `javatest` are installed via Mason (`dap.lua:26-30`).

## C / C++ (codelldb)

Adapter wired at `dap.lua:54-65`. The path is constructed directly from Mason's data dir — **Mason 2.0 removed `get_install_path()`**, so the config uses:

```lua
vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
```

Launch configuration for both `cpp` and `c` (`dap.lua:67-81`) prompts for the executable:

```
Executable: /path/to/cwd/
```

Point it at the binary produced by `<leader>rc` or a `g++`/`gcc` compile. `stopOnEntry` is off, `cwd` is `${workspaceFolder}`.

For a typical CP workflow:

1. Compile with debug info (the default `-O2` in the runner is fine for simple cases but hides locals — compile manually with `-O0 -g` if you need clean stepping).
2. `<leader>du` to open DAP UI.
3. `<leader>db` on the line you want to break.
4. `<leader>dc` → enter the binary path.

## DAP UI layout

Defined at `dap.lua:32-46`:

- **Left sidebar** (width 40): scopes, breakpoints, stacks, watches.
- **Bottom panel** (height 10): repl, console.

The UI opens automatically on launch / attach and closes on terminate / exit (listeners at `dap.lua:49-52`).

## Breakpoint signs

Custom glyphs at `dap.lua:84-93`:

| Sign                      | Glyph | Highlight group            |
|---------------------------|-------|----------------------------|
| `DapBreakpoint`           | ●     | `DiagnosticSignError`      |
| `DapBreakpointCondition`  | ◆     | `DiagnosticSignWarn`       |
| `DapLogPoint`             | ◆     | `DiagnosticSignInfo`       |
| `DapStopped`              | →     | `DiagnosticSignOk` + `Visual` linehl |
| `DapBreakpointRejected`   | ●     | `DiagnosticSignHint`       |

## Keybindings

See [`keymaps.md`](keymaps.md#debug-leaderd-luapluginsdaplua10-21).

## Java

`java-debug-adapter` and `java-test` are installed via `mason-tool-installer` (`lua/plugins/lsp.lua:33-34`) and merged into the jdtls session in `ftplugin/java.lua`. Use the same `<leader>d*` keys once jdtls has attached.
