# Keymaps

Leader is `<space>`. Sources in parentheses point to the file where the binding lives — open that file for the full context.

## Window & buffer (`lua/config/keymaps.lua`)

| Keys             | Action                              |
|------------------|--------------------------------------|
| `<C-h/j/k/l>`    | Move between splits                  |
| `<C-Up/Down>`    | Resize split vertically              |
| `<C-Left/Right>` | Resize split horizontally            |
| `<S-l>` / `<S-h>`| Next / previous buffer               |
| `<leader>bd`     | Delete current buffer                |
| `<leader>bD`     | Delete all other buffers             |
| `<leader>sv`     | Vertical split                       |
| `<leader>sh`     | Horizontal split                     |
| `<leader>w`      | Save                                 |
| `<leader>q`      | Quit all (with confirm)              |
| `<Esc>`          | Clear search highlight               |

Ergonomic extras (same file):

- `j`/`k` respect wrapped lines when no count is given.
- `<C-d>`/`<C-u>`/`n`/`N` keep the cursor centered.
- Visual `J`/`K` move selected lines; `</>` keeps selection after indent; `p` in visual does not clobber the unnamed register.

## Find (`<leader>f`, `lua/plugins/editor.lua:61-72`)

| Keys           | Action                          |
|----------------|----------------------------------|
| `<leader>ff`   | Find files                      |
| `<leader>fg`   | Live grep                       |
| `<leader>fb`   | Buffers                         |
| `<leader>fr`   | Recent files                    |
| `<leader>fh`   | Help tags                       |
| `<leader>fs`   | LSP document symbols            |
| `<leader>fd`   | Diagnostics                     |
| `<leader>fk`   | Keymaps                         |
| `<leader>fc`   | Commands                        |
| `<leader>ft`   | Todos (`todo-comments`)         |
| `<leader>/`    | Fuzzy find in current buffer    |

## LSP (`<leader>l` + bare keys, `lua/plugins/lsp.lua:75-92`)

Bound on `LspAttach` so they only exist where a server is attached.

| Keys           | Action                   |
|----------------|---------------------------|
| `gd`           | Go to definition          |
| `gD`           | Go to declaration         |
| `gr`           | References (telescope)    |
| `gi`           | Implementation            |
| `gy`           | Type definition           |
| `K`            | Hover                     |
| `<C-k>`        | Signature help            |
| `<leader>lr`   | Rename                    |
| `<leader>la`   | Code action               |
| `<leader>lf`   | Format (LSP, async)       |
| `<leader>lF`   | Format via conform.nvim   |
| `<leader>ls`   | Document symbols          |
| `<leader>lS`   | Workspace symbols         |

## Diagnostics (`lua/config/keymaps.lua:54-57`)

| Keys           | Action                   |
|----------------|---------------------------|
| `[d` / `]d`    | Prev / next diagnostic    |
| `<leader>cd`   | Line diagnostics (float)  |
| `<leader>cq`   | Diagnostics to loclist    |

## Git (`<leader>g`, `lua/plugins/editor.lua:102-131`)

| Keys           | Action                   |
|----------------|---------------------------|
| `<leader>gg`   | LazyGit                   |
| `<leader>gs`   | Stage hunk                |
| `<leader>gr`   | Reset hunk                |
| `<leader>gS`   | Stage buffer              |
| `<leader>gu`   | Undo stage hunk           |
| `<leader>gp`   | Preview hunk              |
| `<leader>gb`   | Blame line (full)         |
| `<leader>gd`   | Diff this                 |
| `]h` / `[h`    | Next / prev hunk          |

## Run (`<leader>r`, `lua/plugins/compile-run.lua:7-13`)

Custom runner defined in `lua/cp/runner.lua`. Opens a floating toggleterm.

| Keys           | Action                                      |
|----------------|----------------------------------------------|
| `<leader>rr`   | Compile and run (stdin from `input.txt` if present) |
| `<leader>rc`   | Compile only                                 |
| `<leader>ri`   | Edit `input.txt`                             |
| `<leader>ro`   | Edit `expected_output.txt`                   |
| `<leader>rd`   | Diff actual output vs `expected_output.txt`  |

## Competitive programming tests (`<leader>t`, `lua/plugins/competitest.lua:13-21`)

| Keys           | Action                              |
|----------------|--------------------------------------|
| `<leader>ta`   | Add test case                       |
| `<leader>te`   | Edit test cases                     |
| `<leader>tR`   | Run all test cases                  |
| `<leader>tu`   | Run without recompiling             |
| `<leader>tr`   | Receive test cases (browser)        |
| `<leader>tp`   | Receive full problem (browser)      |
| `<leader>tc`   | Receive contest (browser)           |

## Debug (`<leader>d`, `lua/plugins/dap.lua:10-21`)

| Keys           | Action                   |
|----------------|---------------------------|
| `<leader>db`   | Toggle breakpoint         |
| `<leader>dB`   | Conditional breakpoint    |
| `<leader>dc`   | Continue                  |
| `<leader>di`   | Step into                 |
| `<leader>do`   | Step over                 |
| `<leader>dO`   | Step out                  |
| `<leader>dr`   | REPL                      |
| `<leader>dl`   | Run last                  |
| `<leader>dt`   | Terminate                 |
| `<leader>du`   | Toggle DAP UI             |

## Trouble (`<leader>x`, `lua/plugins/editor.lua:190-195`)

| Keys           | Action                             |
|----------------|-------------------------------------|
| `<leader>xx`   | Workspace diagnostics               |
| `<leader>xX`   | Buffer diagnostics                  |
| `<leader>xs`   | Symbols panel                       |
| `<leader>xl`   | Loclist                             |
| `<leader>xq`   | Quickfix list                       |

## Explorer (`lua/plugins/ui.lua:61-64`)

| Keys           | Action                 |
|----------------|-------------------------|
| `<leader>e`    | Toggle neo-tree         |
| `<leader>E`    | Reveal current file     |

## Treesitter textobjects (`lua/plugins/editor.lua:28-49`)

| Keys           | Action                           |
|----------------|-----------------------------------|
| `af` / `if`    | Function outer / inner            |
| `ac` / `ic`    | Class outer / inner               |
| `al` / `il`    | Loop outer / inner                |
| `aa` / `ia`    | Parameter outer / inner           |
| `]f` / `[f`    | Next / prev function              |
| `]c` / `[c`    | Next / prev class                 |
| `<C-space>`    | Start / expand incremental selection |
| `<BS>`         | Shrink incremental selection      |

## Terminal (`lua/plugins/terminal.lua`)

| Keys           | Action                  |
|----------------|--------------------------|
| `<C-\>`        | Toggle terminal          |

## Misc

| Keys           | Action                            |
|----------------|------------------------------------|
| `<leader>?`    | Which-key, buffer-local bindings   |
