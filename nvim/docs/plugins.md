# Plugins

One section per file under `lua/plugins/`. Plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim), bootstrapped from `lua/config/lazy.lua`.

## `colorscheme.lua`

- **folke/tokyonight.nvim** — sets the `tokyonight-night` colorscheme at startup.

## `ui.lua`

- **nvim-tree/nvim-web-devicons**, **MunifTanjim/nui.nvim**, **nvim-lua/plenary.nvim** — shared deps loaded lazily.
- **nvim-lualine/lualine.nvim** — statusline with `globalstatus`, tokyonight theme, branch/diff/diagnostics + attached LSP client names on the right (`ui.lua:22-28`).
- **akinsho/bufferline.nvim** — tabline with LSP diagnostics and a neo-tree offset (`ui.lua:51-54`).
- **nvim-neo-tree/neo-tree.nvim** — file explorer. `<leader>e` toggles, `<leader>E` reveals. Dotfiles and gitignored files visible by default (`ui.lua:67-71`).
- **folke/which-key.nvim** — `modern` preset, declares group labels for `<leader>b/c/d/f/g/l/r/s/t` (`ui.lua:84-94`).
- **nvimdev/dashboard-nvim** — `hyper` theme, shortcuts for new file, find file, recent, new CP (pre-sets cpp filetype), Lazy, quit.
- **rcarriga/nvim-notify** — overrides `vim.notify`; compact, fade-in, bottom-up.

## `editor.lua`

- **nvim-treesitter/nvim-treesitter** (pinned to `master`) — parsers for C/C++/Java/Python/Lua/Vim + common formats. Highlight + indent + incremental selection + textobjects. The `master` branch pin is load-bearing; see [`troubleshooting.md`](troubleshooting.md#nvim-treesitter-configs-not-found).
- **nvim-telescope/telescope.nvim** — fuzzy finder with fzf-native and ui-select extensions. All `<leader>f*` bindings route through here.
- **lewis6991/gitsigns.nvim** — gutter signs + per-buffer git keymaps (`<leader>g*`, `]h` / `[h`).
- **kdheepak/lazygit.nvim** — `<leader>gg`.
- **windwp/nvim-autopairs** — `check_ts = true` so pairs respect treesitter context.
- **numToStr/Comment.nvim** — `gcc` / `gc{motion}` / visual `gc`.
- **lukas-reineke/indent-blankline.nvim** (`ibl`) — indent guides, scope off, excluded in UI filetypes.
- **kylechui/nvim-surround** — `ys` / `ds` / `cs`.
- **RRethy/vim-illuminate** — highlights references under the cursor. Providers restricted to `lsp` + `regex` (treesitter provider is buggy, see troubleshooting).
- **folke/todo-comments.nvim** — highlights TODO/FIXME/NOTE; `<leader>ft` opens them via telescope.
- **folke/trouble.nvim** — `<leader>x*` panels for diagnostics / symbols / quickfix.

## `lsp.lua`

See [`lsp.md`](lsp.md) for the full story. High-level:

- **mason-org/mason.nvim** — installer.
- **mason-org/mason-lspconfig.nvim** — ensures `clangd lua_ls jdtls pyright bashls` are installed.
- **WhoIsSethDaniel/mason-tool-installer.nvim** — ensures `clang-format stylua google-java-format codelldb java-debug-adapter java-test` are installed.
- **neovim/nvim-lspconfig** — provides the server definitions (`lsp/<name>.lua`) that `vim.lsp.enable()` picks up. We override via `vim.lsp.config()` for clangd and lua_ls; `jdtls` is owned by `ftplugin/java.lua` and deliberately excluded from `vim.lsp.enable`.
- **stevearc/conform.nvim** — format-on-save; `:FormatDisable` / `:FormatEnable` to toggle.

## `completion.lua`

- **hrsh7th/nvim-cmp** with `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline` sources.
- **L3MON4D3/LuaSnip** + **rafamadriz/friendly-snippets** — snippet engine + preloaded snippet library.
- **onsails/lspkind.nvim** — completion item icons.
- Tab / S-Tab navigates; cmp integrates with nvim-autopairs so `(` auto-inserts the right brace.

## `dap.lua`

See [`debugging.md`](debugging.md). Loads **nvim-dap**, **nvim-dap-ui**, **nvim-dap-virtual-text**, **mason-nvim-dap**. Wires `codelldb` for C/C++ using `$MASON/packages/codelldb/extension/adapter/codelldb`.

## `terminal.lua`

- **akinsho/toggleterm.nvim** — `<C-\>` toggles a terminal. Float/horizontal/vertical variants are available. The custom CP runner in `lua/cp/runner.lua` opens a floating toggleterm for compile/run results.

## `compile-run.lua`

Thin spec file that only contributes `<leader>r*` keymaps pointing into the custom module `lua/cp/runner.lua`. Runner itself does not depend on any plugin — if toggleterm is unavailable it falls back to `:botright split | terminal`.

## `competitest.lua`

See [`competitive-programming.md`](competitive-programming.md). Loads **xeluxee/competitest.nvim**. Configures compile/run commands per language, testcase file layout, received-problem paths, and Competitive Companion on port 27121.

## `jdtls.lua`

One-liner that declares **mfussenegger/nvim-jdtls** with `ft = "java"`. The actual startup happens in `ftplugin/java.lua` on the first Java buffer.
