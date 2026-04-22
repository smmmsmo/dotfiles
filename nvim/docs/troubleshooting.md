# Troubleshooting

Real issues hit while building this config, in the order they appeared. Each entry is short and includes the final fix so you can skim for symptoms.

## `E1511: Wrong number of characters for field "foldclose"`

**Symptom:** error on startup from `vim.opt.fillchars`.

**Cause:** one of the glyphs in `fillchars` was more than one display cell wide.

**Fix:** in `lua/config/options.lua`, keep `fillchars` simple:

```lua
vim.opt.fillchars = { eob = " ", fold = " ", foldsep = " " }
```

Don't set `foldopen` / `foldclose` unless you've verified the glyph width.

## `module 'nvim-treesitter.configs' not found`

**Symptom:** startup error from lazy.nvim, treesitter never initializes.

**Cause:** the `nvim-treesitter` default branch is now `main`, which has completely removed the classic `configs` module. The widely-used setup API only exists on `master`.

**Fix:** pin both plugins to `master` (`lua/plugins/editor.lua:4, 8`):

```lua
{ "nvim-treesitter/nvim-treesitter", branch = "master", ... }
dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" } }
```

For an already-cloned install: `cd ~/.local/share/nvim/lazy/nvim-treesitter && git checkout master`, then `:Lazy sync`.

## `require('lspconfig')` deprecated

**Symptom:** warning on `LspAttach` or `VimEnter` about the deprecated setup API.

**Fix:** use the Neovim 0.11+ API (already done in `lua/plugins/lsp.lua`):

```lua
vim.lsp.config(name, { ...overrides... })
vim.lsp.enable({ "clangd", "lua_ls", "pyright", "bashls" })
```

Server defaults still come from `nvim-lspconfig` (it ships `lsp/<name>.lua` files that the `vim.lsp.enable` call picks up).

## `attempt to call method 'get_install_path' (a nil value)`

**Symptom:** error when jdtls or codelldb tries to start.

**Cause:** Mason 2.0 removed the `get_install_path()` helper on package objects.

**Fix:** build the path directly from the Mason data dir:

```lua
local mason_pkg_root = vim.fn.stdpath("data") .. "/mason/packages"
local codelldb_dir   = mason_pkg_root .. "/codelldb"
local jdtls_root     = mason_pkg_root .. "/jdtls"
```

Applied in `lua/plugins/dap.lua:55` and `ftplugin/java.lua`.

## vim-illuminate: `attempt to call method 'parent' (a nil value)` in `nvim-treesitter/locals.lua:286`

**Symptom:** recurring error when moving the cursor in source files.

**Cause:** illuminate's treesitter provider tries to call removed API on the `master` branch after upstream churn.

**Fix:** drop the treesitter provider (`lua/plugins/editor.lua:169`):

```lua
require("illuminate").configure({
  providers = { "lsp", "regex" },
  ...
})
```

LSP-based reference highlighting works fine for everything we care about.

## Java LSP (`jdtls`) quits exit 1

**Symptom:** `Client jdtls quit with exit code 1` in `:LspLog` or `:messages` as soon as you open a `.java` file.

**Cause:** no JDK runtime available on `$PATH` (jdtls itself is written in Java and needs a JRE ≥ 21 to launch).

**Fix on macOS:**

```sh
brew install openjdk@21
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk \
             /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

Verify with `/usr/libexec/java_home -V`. Restart Neovim; reopen a `.java` file.

## `fatal error: 'bits/stdc++.h' file not found`

**Symptom:** clangd red-squiggles on `#include <bits/stdc++.h>`, or compile errors from `g++`/`clang++`.

**Cause:** macOS ships Apple clang's libc++, which does not include GCC's `<bits/stdc++.h>` convenience header.

**Fix:** three-part shim (already in place — recreate if you ever blow away configs):

1. `~/.config/nvim/include/bits/stdc++.h` — the shim itself; includes the whole standard library.
2. `~/.config/clangd/config.yaml`:
   ```yaml
   CompileFlags:
     Add:
       - -I/Users/mo/.config/nvim/include
       - -std=gnu++20
       - -Wall
       - -Wextra
   ```
3. Compile commands in `lua/cp/runner.lua:30-34` and `lua/plugins/competitest.lua:37` both pass `-I<stdpath("config")>/include`.

Verify end-to-end:

```sh
g++ -O2 -std=gnu++20 -I/Users/mo/.config/nvim/include -o /tmp/t /tmp/t.cpp
```

Should succeed on any `#include <bits/stdc++.h>` program.
