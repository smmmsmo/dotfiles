# Competitive programming

Two complementary tools: **competitest.nvim** (test-case manager + Competitive Companion receiver) and a **custom runner** in `lua/cp/runner.lua` for quick compile-and-run against a single `input.txt`.

## Templates

Auto-inserted on new-file creation by `lua/config/autocmds.lua:55-75`.

| Filetype | Template                        | Notes |
|----------|----------------------------------|-------|
| `.cpp` / `.cc` / `.cxx` | `templates/cp.cpp`     | `#include <bits/stdc++.h>`, common typedefs, `solve()`, optional multi-testcase loop, `dbg(...)` macro. |
| `.c`     | `templates/cp.c`                | C equivalent. |
| `.java`  | `templates/Main.java`           | `__CLASSNAME__` placeholder replaced with the actual filename stem at insert time. |
| `.py`    | `templates/cp.py`               | Wired via competitest's `template_file`; not an autocmd. |

competitest will also pick these up when it creates a file from a received problem (`template_file` at `lua/plugins/competitest.lua:69-74`).

## `<bits/stdc++.h>` on Apple clang

macOS clang does not ship the GCC convenience header. Three places need to know where our shim lives:

1. **The shim** — `include/bits/stdc++.h`. Pulls in the full C/C++98/11/17/20 stdlib.
2. **clangd** — `~/.config/clangd/config.yaml` adds `-I/Users/mo/.config/nvim/include` + `-std=gnu++20 -Wall -Wextra` so the LSP resolves the include.
3. **Compile commands** — both the custom runner and competitest pass `-I<stdpath("config")>/include`:
   - `lua/cp/runner.lua:30-34`
   - `lua/plugins/competitest.lua:37`

If you change the shim's path, update all three.

## competitest.nvim

Spec: `lua/plugins/competitest.lua`.

### Commands

| Keys          | Command                             | What it does |
|---------------|-------------------------------------|---------------|
| `<leader>ta`  | `:CompetiTestAdd`                   | Add a test case. |
| `<leader>te`  | `:CompetiTestEdit`                  | Edit existing test cases. |
| `<leader>tR`  | `:CompetiTestRun`                   | Compile + run every test case. |
| `<leader>tu`  | `:CompetiTestRunNoCompile`          | Run without recompiling. |
| `<leader>tr`  | `:CompetiTestReceive testcases`     | Receive test cases from the browser. |
| `<leader>tp`  | `:CompetiTestReceive problem`       | Receive a whole problem (creates source file from template + tests). |
| `<leader>tc`  | `:CompetiTestReceive contest`       | Receive an entire contest as a batch. |

### Test case layout

Tests live **next to the source file** (not in a subdir):

- Input:  `<stem>_input<N>.txt`
- Output: `<stem>_output<N>.txt`

Controlled at `lua/plugins/competitest.lua:57-60`.

### Received problem paths

- Single problem: `$HOME/cp/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)` (`competitest.lua:62`).
- Contest directory: `$HOME/cp/$(JUDGE)/$(CONTEST)/` with per-problem file `$(PROBLEM).$(FEXT)` (`competitest.lua:64-65`).
- You'll be prompted to confirm the path and file extension on first use (`received_*_prompt_*` flags).

### Compile / run commands

At `competitest.lua:35-49`. Highlights:

- **C++**: `g++ -O2 -std=gnu++20 -Wall -Wextra -Wshadow -DLOCAL -I<shim> -o $(FNOEXT) $(FNAME)`. `-DLOCAL` is the conventional guard for local-only debug code.
- **C**: `gcc -O2 -std=gnu17 -Wall -Wextra -o $(FNOEXT) $(FNAME) -lm`.
- **Java**: `javac`, then `java $(FNOEXT)`.
- **Python**: compile step is a no-op (`true`), run is `python3 $(FNAME)`.
- **Rust**: `rustc -O` then `./$(FNOEXT)`.

### Runner UI

Popup interface (`competitest.lua:25-33`), 85% × 80% of the screen. `multiple_testing = -1` uses all cores. 5 s time limit. Output comparison is `squish` (whitespace-insensitive). `view_output_diff = true` opens a diff on mismatch.

### Competitive Companion

1. Install the [Competitive Companion](https://github.com/jmerle/competitive-companion) browser extension.
2. In the extension's options, set the custom port to **27121**.
3. Open Neovim, run `<leader>tp` (or `<leader>tr` / `<leader>tc`).
4. Click the Competitive Companion icon on the problem page. The file + test cases land in `~/cp/...` and the buffer opens.

## Custom runner (`lua/cp/runner.lua`)

Minimal alternative when you just want to hit "run" with a single input file. No test-case scaffolding.

### Behavior

- `M.compile()` (`<leader>rc`): writes the buffer, runs the compile command in a floating toggleterm.
- `M.run()` (`<leader>rr`): writes, compiles, runs. If `input.txt` / `in.txt` / `stdin.txt` exists in the buffer's directory, it's piped on stdin. Python has no compile step and is invoked directly.
- `M.edit_input()` (`<leader>ri`): opens `input.txt` next to the source.
- `M.edit_output()` (`<leader>ro`): opens `expected_output.txt`.
- `M.diff_output()` (`<leader>rd`): compiles, runs with `input.txt` on stdin, and diffs stdout against `expected_output.txt` via `diff -u`.

### Language detection

`LANG` table at `lua/cp/runner.lua:18-51`:

| Extension           | Compile                                                                 | Run                       |
|---------------------|-------------------------------------------------------------------------|----------------------------|
| `.c`                | `gcc -O2 -std=gnu17 -Wall -Wextra -o <stem> <name> -lm`                 | `./<stem>`                 |
| `.cpp/.cc/.cxx`     | `g++ -O2 -std=gnu++20 -Wall -Wextra -Wshadow -DLOCAL -I<shim> -o <stem> <name>` | `./<stem>`          |
| `.java`             | `javac <name>`                                                          | `java <stem>`              |
| `.py`               | (none)                                                                  | `python3 <path>`           |

### Why both?

competitest covers the "graded" workflow: multiple named test cases, parallel runs, pass/fail UI, Competitive Companion. The custom runner is for the "while I'm debugging" loop — faster to invoke, prints live to a terminal, easy to pair with `dbg(...)` output from the C++ template.
