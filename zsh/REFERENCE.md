# Zsh Configuration Reference

Quick reference for all aliases, functions, keybindings, options, and tools
configured in this zsh setup.

## Table of Contents

- [Shell Options](#shell-options)
- [Key Bindings](#key-bindings)
- [Aliases](#aliases)
- [Functions](#functions)
- [Plugins](#plugins)
- [CLI Tools](#cli-tools)
- [FZF Shortcuts](#fzf-shortcuts)
- [What Was Intentionally NOT Added](#what-was-intentionally-not-added)
- [Install Missing Tools](#install-missing-tools)

---

## Shell Options

Configured in `conf.d/02-options.zsh`.

### Directory Navigation

| Option             | What it does                                        |
|--------------------|-----------------------------------------------------|
| `auto_cd`          | Type a directory name to cd into it (no `cd` needed)|
| `auto_pushd`       | Every cd pushes onto the directory stack             |
| `pushd_ignore_dups`| No duplicate entries in the directory stack           |
| `pushd_silent`     | Don't print the stack on pushd/popd                  |
| `cdable_vars`      | `cd VARNAME` works if VARNAME holds a path           |

### Completion

| Option             | What it does                                        |
|--------------------|-----------------------------------------------------|
| `complete_in_word` | Complete from cursor position, not end of word       |
| `always_to_end`    | Move cursor to end of word after completion          |
| `list_packed`      | Compact completion list (less vertical space)        |

### Globbing

| Option             | What it does                                        |
|--------------------|-----------------------------------------------------|
| `extended_glob`    | Extended patterns: `^*.log` (not .log), `#` `~`     |
| `glob_dots`        | `*.txt` also matches `.hidden.txt`                   |

### History

| Option                  | What it does                                              |
|-------------------------|-----------------------------------------------------------|
| `hist_expire_dups_first`| Expire duplicate entries first when history is full        |
| `hist_ignore_all_dups`  | Remove ALL older duplicates (not just consecutive)         |
| `hist_ignore_space`     | Prefix command with space to exclude from history          |
| `hist_find_no_dups`     | Don't show duplicates when searching history               |
| `hist_reduce_blanks`    | Remove extra whitespace from saved commands                |
| `hist_save_no_dups`     | Don't write duplicates to the history file                 |
| `hist_verify`           | Show recalled command before executing (edit first)        |
| `append_history`        | Append to history file, don't overwrite                    |
| `share_history`         | Share history across all sessions in real time; also handles incremental appending — `inc_append_history` is intentionally not set alongside it to avoid duplicate/disordered history |

### Safety & Misc

| Option                | What it does                                          |
|-----------------------|-------------------------------------------------------|
| `interactive_comments`| Allow `#` comments in interactive shell               |
| `no_beep`             | Silence the terminal bell                             |
| `rm_star_wait`        | 10-second pause before executing `rm *` (Ctrl-C to cancel) |
| `prompt_subst`        | Allow variable expansion in the prompt                |
| `long_list_jobs`      | Show PID in job notifications                         |

---

## Key Bindings

Configured in `conf.d/04-keybindings.zsh`. Uses emacs mode (`bindkey -e`).

| Binding          | Action                                |
|------------------|---------------------------------------|
| `Ctrl-A`         | Beginning of line                     |
| `Ctrl-E`         | End of line                           |
| `Ctrl-W`         | Delete word backward                  |
| `Alt-D`          | Delete word forward                   |
| `Alt-F`          | Move forward one word                 |
| `Alt-B`          | Move backward one word                |
| `Ctrl-Right`     | Move forward one word                 |
| `Ctrl-Left`      | Move backward one word                |
| `Home`           | Beginning of line                     |
| `End`            | End of line                           |
| `Ctrl-X Ctrl-E`  | Open current command in $EDITOR       |
| `Ctrl-F`         | Accept autosuggestion (primary — works inside tmux) |
| `Ctrl-]`         | Accept autosuggestion (alternative)   |
| `Ctrl-Space`     | Accept autosuggestion (outside tmux only — tmux intercepts this as its prefix) |
| `Up Arrow`       | History substring search up           |
| `Down Arrow`     | History substring search down         |
| `Ctrl-P`         | History substring search up           |
| `Ctrl-N`         | History substring search down         |
| `Ctrl-T`         | FZF file picker                       |
| `Ctrl-R`         | FZF history search                    |
| `Alt-C`          | FZF directory picker                  |
| `Ctrl-/`         | Toggle FZF preview pane               |

---

## Aliases

Configured in `conf.d/08-aliases.zsh`.

### Navigation

| Alias   | Expands to          | Notes                           |
|---------|---------------------|---------------------------------|
| `..`    | `cd ..`             |                                 |
| `...`   | `cd ../..`          |                                 |
| `....`  | `cd ../../..`       |                                 |
| `-`     | `cd -`              | Go back to previous directory   |
| `d`     | `dirs -v`           | Show numbered directory stack   |
| `1`-`9` | `cd +N`             | Jump to Nth entry in dir stack  |
| `j`     | `cd`                | Zoxide shorthand                |
| `ji`    | `cdi`               | Interactive zoxide (fzf picker) |

### File Listing (eza)

| Alias  | What it does                                  |
|--------|-----------------------------------------------|
| `ls`   | `eza --icons --group-directories-first`       |
| `l`    | Single column listing                         |
| `ll`   | Long listing with git status                  |
| `la`   | Long listing including hidden files           |
| `lt`   | Tree view, 2 levels deep                      |
| `ltt`  | Tree view, 3 levels deep                      |
| `lttt` | Tree view, 4 levels deep                      |

### File Viewing (bat)

| Alias  | What it does                    |
|--------|---------------------------------|
| `cat`  | `bat --paging=never`            |
| `catp` | `bat` (with default paging)     |
| `batp` | `bat --paging=always`           |

### Modern CLI Replacements

| Alias   | Tool       | What it does                                |
|---------|------------|---------------------------------------------|
| `grep`  | `rg`       | ripgrep — fast grep, respects .gitignore    |
| `rgs`   | `rg`       | ripgrep including hidden files              |
| `lg`    | `lazygit`  | Interactive git TUI                         |
| `top`   | `btop`     | Modern system monitor                       |
| `usage` | `dust`     | Visual disk usage analyzer                  |
| `psa`   | `procs`    | Modern process viewer with color            |

### Git

| Alias    | Expands to                        | Notes                              |
|----------|-----------------------------------|------------------------------------|
| `g`      | `git`                             |                                    |
| `gs`     | `git status -sb`                  | Short status with branch           |
| `ga`     | `git add`                         |                                    |
| `gaa`    | `git add --all`                   |                                    |
| `gc`     | `git commit -v`                   | Verbose (shows diff in editor)     |
| `gcm`    | `git commit -m`                   |                                    |
| `gca`    | `git commit --amend --no-edit`    | Amend without changing message     |
| `gcam`   | `git commit --amend`              | Amend with message edit            |
| `gd`     | `git diff`                        |                                    |
| `gds`    | `git diff --staged`               |                                    |
| `gl`     | `git log --oneline --graph --all` | Compact log with branch graph      |
| `gll`    | `git log --graph --pretty=...`    | Detailed log with colors           |
| `gp`     | `git pull --rebase --autostash`   | Clean pull: rebases and stashes    |
| `gps`    | `git push`                        |                                    |
| `gpf`    | `git push --force-with-lease`     | Safe force push                    |
| `gco`    | `git checkout`                    |                                    |
| `gcb`    | `git checkout -b`                 | Create and switch to new branch    |
| `gsw`    | `git switch`                      |                                    |
| `gswc`   | `git switch -c`                   | Create and switch to new branch    |
| `gst`    | `git stash`                       |                                    |
| `gstp`   | `git stash pop`                   |                                    |
| `gstl`   | `git stash list`                  |                                    |
| `gf`     | `git fetch --all --prune`         | Fetch all remotes, prune deleted   |
| `gm`     | `git merge --no-ff`               | Always create merge commit         |
| `grb`    | `git rebase`                      |                                    |
| `grbi`   | `git rebase -i`                   | Interactive rebase                 |
| `gcp`    | `git cherry-pick`                 |                                    |
| `greset` | `git reset --soft HEAD~1`         | Undo last commit, keep changes     |
| `gclean` | `git clean -fd`                   | Remove untracked files/dirs        |
| `gwip`   | `git add -A && git commit -m...`  | Quick WIP commit with timestamp    |

### Docker

| Alias    | Expands to                      | Notes                           |
|----------|---------------------------------|---------------------------------|
| `dk`     | `docker`                        |                                 |
| `dkc`    | `docker compose`                |                                 |
| `dkcu`   | `docker compose up -d`          | Detached mode                   |
| `dkcd`   | `docker compose down`           |                                 |
| `dkps`   | `docker ps --format "table..."` | Clean table output              |
| `dkpsa`  | `docker ps -a --format...`      | Include stopped containers      |
| `dkim`   | `docker images`                 |                                 |
| `dkrm`   | `docker rm`                     |                                 |
| `dkrmi`  | `docker rmi`                    |                                 |
| `dkprune`| `docker system prune -af...`    | Remove all unused + volumes     |

### Node / npm

| Alias | Expands to              |
|-------|-------------------------|
| `ni`  | `npm install`           |
| `nid` | `npm install --save-dev`|
| `nr`  | `npm run`               |
| `nrs` | `npm run start`         |
| `nrd` | `npm run dev`           |
| `nrb` | `npm run build`         |
| `nrt` | `npm run test`          |
| `nrl` | `npm run lint`          |

### Python

| Alias      | Expands to                          | Notes                         |
|------------|-------------------------------------|-------------------------------|
| `py`       | `python3`                           |                               |
| `pip`      | `pip3`                              |                               |
| `venv`     | `python3 -m venv .venv`             | Create venv in current dir    |
| `activate` | `source .venv/bin/activate`         | Auto-finds .venv or venv/     |

### File Operations (safety)

| Alias   | Expands to  | Notes                                      |
|---------|-------------|--------------------------------------------|
| `cp`    | `cp -iv`    | Interactive + verbose (bypass with `\cp`)   |
| `mv`    | `mv -iv`    | Interactive + verbose (bypass with `\mv`)   |
| `rm`    | `rm -iv`    | Interactive + verbose (bypass with `\rm`)   |
| `mkdirp`| `mkdir -p`  | Create parent directories                   |

### Misc

| Alias        | What it does                              |
|--------------|-------------------------------------------|
| `df`         | `df -h` (human-readable disk free)        |
| `du`         | `du -sh` (human-readable disk usage)      |
| `path`       | Pretty-print PATH (one entry per line)    |
| `reload`     | Re-source .zshrc                          |
| `zshrc`      | Edit .zshrc in $EDITOR                    |
| `nvimrc`     | Edit neovim config                        |
| `ghosttyrc`  | Edit ghostty config                       |
| `starshiprc` | Edit starship config                      |
| `dot`        | cd to dotfiles repo                       |
| `hosts`      | Edit /etc/hosts (with sudo)               |
| `ip`         | Show public IP address                    |
| `localip`    | Show local IP address                     |
| `ports`      | Show listening ports                      |
| `flushdns`   | Flush DNS cache (macOS only)              |
| `brewup`     | Update + upgrade + cleanup Homebrew       |

---

## Functions

Configured in `conf.d/09-functions.zsh`.

### File & Directory

| Function     | Usage                    | What it does                              |
|--------------|--------------------------|-------------------------------------------|
| `mkcd`       | `mkcd project-name`     | mkdir + cd in one step                     |
| `extract`    | `extract archive.tar.gz`| Universal archive extractor (tar/zip/7z/rar/etc.) |
| `up`         | `up 3`                  | Go up N directories (like `cd ../../..`)   |
| `sizeof`     | `sizeof node_modules`   | Human-readable size of file/directory      |
| `tre`        | `tre 3 src/`            | Tree view with eza (configurable depth)    |
| `port`       | `port 3000`             | Show what's listening on a port            |

### FZF-Powered Interactive

| Function | Usage        | What it does                                      |
|----------|--------------|---------------------------------------------------|
| `fcd`    | `fcd`        | Fuzzy cd into any subdirectory                    |
| `fkill`  | `fkill`      | Interactively select and kill a process           |
| `fhist`  | `fhist`      | Fuzzy search history, place in input buffer       |
| `fenv`   | `fenv`       | Fuzzy search environment variables                |

### Git

| Function | Usage         | What it does                                     |
|----------|---------------|--------------------------------------------------|
| `gbr`    | `gbr`         | FZF branch switcher (local + remote)             |
| `gshow`  | `gshow`       | FZF commit browser with diff preview             |
| `groot`  | `groot`       | cd to git repository root                        |

### Development

| Function | Usage                     | What it does                           |
|----------|---------------------------|----------------------------------------|
| `serve`  | `serve` or `serve 3000`   | Start HTTP server in current directory |
| `json`   | `json file.json` or pipe  | Pretty-print JSON via jq               |
| `cheat`  | `cheat tar`               | Command cheat sheet from cheat.sh      |

### macOS Only

| Function | Usage    | What it does                        |
|----------|----------|-------------------------------------|
| `hidden` | `hidden` | Toggle hidden files in Finder       |

---

## Plugins

Configured in `conf.d/06-plugins.zsh`. No plugin manager used — sourced directly from system paths.

| Plugin                         | Purpose                            | Accept key        |
|--------------------------------|------------------------------------|--------------------|
| `zsh-autosuggestions`          | Ghost text from history/completion | `Ctrl-F` (inside tmux), `Ctrl-Space` (outside tmux) |
| `zsh-syntax-highlighting`     | Fish-like syntax coloring          | (automatic)        |
| `zsh-history-substring-search`| Up/Down to search history by substring | `Up`/`Down` arrow |
| `zsh-completions`             | Extra completions for ~300 commands | (via tab)          |

---

## CLI Tools

Modern replacements for standard unix tools. All are optional —
aliases fall back gracefully when tools aren't installed.

### Already Installed

| Tool       | Replaces | Purpose                                    |
|------------|----------|--------------------------------------------|
| `bat`      | `cat`    | Syntax-highlighted file viewer              |
| `eza`      | `ls`     | Modern ls with icons, git status, tree view |
| `fd`       | `find`   | Fast file finder, respects .gitignore       |
| `fzf`      | —        | Fuzzy finder for files, history, branches   |
| `ripgrep`  | `grep`   | Fast content search, respects .gitignore    |
| `delta`    | —        | Git diff viewer with syntax highlighting    |
| `zoxide`   | `cd`     | Frecency-based directory jumper             |
| `direnv`   | —        | Per-directory environment variables         |
| `starship` | —        | Fast, customizable prompt                   |
| `lazygit`  | —        | Interactive git TUI                         |
| `jq`       | —        | JSON processor                              |

### Recommended (not yet installed)

| Tool       | Replaces | Purpose                    | Install              |
|------------|----------|----------------------------|----------------------|
| `btop`     | `top`    | Modern system monitor      | `brew install btop`  |
| `dust`     | `du`     | Visual disk usage analyzer | `brew install dust`  |
| `procs`    | `ps`     | Colored process viewer     | `brew install procs` |

---

## FZF Shortcuts

Configured in `conf.d/05-fzf.zsh`.

| Shortcut    | What it does                              | Preview               |
|-------------|-------------------------------------------|-----------------------|
| `Ctrl-T`    | Insert file path                          | bat (syntax highlight)|
| `Ctrl-R`    | Search command history                    | —                     |
| `Alt-C`     | cd into directory                         | eza tree              |
| `Ctrl-Y`    | Copy selection to clipboard               | macOS: `pbcopy`; Linux: `xclip`/`xsel` (skipped if none found) |
| `Ctrl-/`    | Toggle preview pane                       | —                     |
| `Ctrl-U`    | Scroll preview up                         | —                     |
| `Ctrl-D`    | Scroll preview down                       | —                     |

Color theme: **Tokyo Night** (consistent with bat, delta, starship, terminal).

---

## What Was Intentionally NOT Added

These were evaluated and deliberately excluded. This isn't a gap —
it's a conscious decision.

| Suggestion               | Why it was skipped                                                           |
|--------------------------|------------------------------------------------------------------------------|
| `correct` / `correct_all`| Triggers false positives on valid commands zsh doesn't recognize (scripts, new CLI tools). Annoying in practice. |
| `noclobber`              | Breaks common `>` redirect patterns. Forces using `>|` for overwrites. Not worth the friction. |
| `atuin`                  | Already have 200k shared history + substring search + fzf Ctrl-R. Atuin adds a database layer for marginal gain. |
| `fzf-tab`                | Conflicts with the existing `menu select` completion. Would require removing current zstyle rules. |
| `thefuck`                | Adds 200-400ms to shell startup for a novelty command corrector.              |
| `broot`                  | Already covered by fzf + fd + eza (same use case: file navigation/search).    |
| `autojump` / `fasd`      | Older, inferior alternatives to zoxide (already installed).                   |
| `zsh-defer`              | Shell startup is already ~100ms. No performance problem to solve.             |
| `fast-syntax-highlighting`| Marginal speed difference vs zsh-syntax-highlighting at this config size.     |
| `zsh-vi-mode`            | Would change the emacs-mode workflow. Major habit change, not an improvement. |
| `auto_param_slash`       | Already enabled by default in zsh. Setting it explicitly is redundant.        |
| Modular XDG ZDOTDIR      | Would require a .zshenv file and changing how zsh finds its config. More complexity than the conf.d approach. |

---

## Cross-Platform Notes

### Locale (`LC_ALL`)
`LANG=en_US.UTF-8` is set unconditionally. `LC_ALL` is only forced on macOS,
where the locale is always present. On Linux, containers, and remote hosts,
`LC_ALL` is left unset so the system locale takes effect — avoids `setlocale`
warnings when `en_US.UTF-8` isn't generated.

### fzf clipboard (`Ctrl-Y`)
The `Ctrl-Y` copy binding auto-detects the clipboard tool at shell startup:
- **macOS** → `pbcopy`
- **Linux with xclip** → `xclip -selection clipboard`
- **Linux with xsel** → `xsel --clipboard --input`
- **Neither found** → binding is omitted (no silent failure)

Install on Linux: `sudo apt install xclip` or `sudo pacman -S xclip`.

### `fcd` and `ff` fallbacks
`fcd` uses `fd` when available, otherwise falls back to `find`.
`ff` uses `bat` for the preview when available, otherwise falls back to `cat`.

---

## Install Missing Tools

One command to install everything not yet on your system:

```sh
brew install zsh-completions btop dust procs
```

Already installed (no action needed): `ripgrep`, `lazygit`, `bat`,
`eza`, `fd`, `fzf`, `delta`, `zoxide`, `direnv`, `starship`, `jq`.

After installing zsh-completions, rebuild the completion cache:

```sh
rm -f ~/.cache/zsh/zcompdump && source ~/.zshrc
```

---

## File Structure

```
zsh/
  .zshrc                  # Loader — sources all modules from conf.d/
  .zprofile               # Login shell setup (placeholder)
  REFERENCE.md            # This file
  conf.d/
    01-environment.zsh    # Locale, EDITOR, XDG, PAGER, PATH
    02-options.zsh        # setopt calls, history config
    03-completion.zsh     # fpath, compinit, zstyle rules
    04-keybindings.zsh    # bindkey mappings
    05-fzf.zsh            # FZF config and shell integration
    06-plugins.zsh        # Autosuggestions, syntax-highlighting, history-search
    07-prompt.zsh         # Starship init with vcs_info fallback
    08-aliases.zsh        # All aliases (navigation, git, docker, tools)
    09-functions.zsh      # Shell functions (extract, fzf helpers, etc.)
    10-tools.zsh          # zoxide, direnv (eval hooks)
```

To add new config, create a new `.zsh` file in `conf.d/` with the
appropriate numeric prefix. Files are sourced in glob order.
