# LSP

The LSP stack uses the Neovim 0.11+ `vim.lsp.config` / `vim.lsp.enable` API rather than the deprecated `require("lspconfig").xxx.setup{}`. Server definitions ship as `lsp/<name>.lua` files inside nvim-lspconfig and are picked up automatically once enabled.

All LSP wiring lives in `lua/plugins/lsp.lua`, except `jdtls` which is started per-buffer in `ftplugin/java.lua`.

## Servers (managed by mason-lspconfig)

`ensure_installed` at `lua/plugins/lsp.lua:18`:

| Server   | Filetypes             | Notes |
|----------|-----------------------|-------|
| `clangd` | C, C++                | Overridden at `lsp.lua:106-117`: `--background-index`, `--clang-tidy`, `--header-insertion=iwyu`, placeholders. Reads `~/.config/clangd/config.yaml` for the `<bits/stdc++.h>` include path. |
| `lua_ls` | Lua                   | Overridden at `lsp.lua:119-129`: LuaJIT runtime, neovim runtime in workspace.library, `vim` global, inlay hints on. |
| `jdtls`  | Java                  | **Not** enabled via `vim.lsp.enable` — owned by `ftplugin/java.lua`. |
| `pyright`| Python                | Defaults. |
| `bashls` | sh, bash              | Defaults. |

`vim.lsp.enable({ "clangd", "lua_ls", "pyright", "bashls" })` is called at `lsp.lua:132`.

## Non-LSP tools (mason-tool-installer)

Installed at `lsp.lua:28-37`:

- `clang-format`, `stylua`, `google-java-format`, `black`, `shfmt` — formatters invoked by conform.nvim.
- `codelldb` — C/C++ debug adapter, wired in `lua/plugins/dap.lua:55-65`.
- `java-debug-adapter`, `java-test` — bundles merged into the jdtls session in `ftplugin/java.lua`.

## Capabilities + on_attach

`lsp.lua:67-72` builds capabilities from `cmp_nvim_lsp` and exposes `_G.LspCapabilities` so `ftplugin/java.lua` can feed the same caps into jdtls.

`_G.LspOnAttach` (`lsp.lua:75-92`) is bound by the `LspAttach` autocmd at `lsp.lua:94-100`. It sets the buffer-local LSP keymaps (see [`keymaps.md`](keymaps.md#lsp-leaderl--bare-keys-luapluginslsplua75-92)) and enables inlay hints when the server supports them.

## Diagnostics UI

Configured once at `lsp.lua:46-58`:

- Virtual text with a `●` prefix, spacing 2.
- Rounded float border, source shown.
- Error/Warn/Info/Hint sign glyphs.

Hover and signature help are also rebound to force a rounded border (`lsp.lua:61-64`).

## Format-on-save (conform.nvim)

`lsp.lua:137-166`. Runs before write, LSP fallback on, 1.5 s timeout. Formatters per filetype:

| ft     | formatter            |
|--------|----------------------|
| c, cpp | `clang-format`       |
| java   | `google-java-format` |
| python | `black`              |
| lua    | `stylua`             |
| sh     | `shfmt`              |

Toggles (both commands defined in `init` at `lsp.lua:158-164`):

- `:FormatDisable` — disable autoformat for the session.
- `:FormatDisable!` — disable autoformat for the current buffer only.
- `:FormatEnable` — re-enable for both.

Manual formatting:

- `<leader>lf` — `vim.lsp.buf.format({ async = true })`.
- `<leader>lF` — `conform.format({ async = true, lsp_fallback = true })`.

## Java (jdtls)

`ftplugin/java.lua` starts jdtls the first time a `.java` buffer loads. It:

1. Resolves the launcher jar under `$MASON/packages/jdtls/` (Mason 2.0 path).
2. Adds `java-debug-adapter` and `java-test` bundles so dap + test-running work inside the LSP session.
3. Picks a platform config folder (`config_mac` / `config_linux` / `config_win`).
4. Creates a per-project workspace at `stdpath("cache") .. "/jdtls/workspace/<root-name>"`.
5. Uses `_G.LspCapabilities` and `_G.LspOnAttach` so Java shares the same keymaps and cmp capabilities as everything else.

**A system JDK is required.** See [`troubleshooting.md`](troubleshooting.md#java-lsp-jdtls-quits-exit-1).
