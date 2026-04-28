# ARCHITECTURE

How the repo is organized and why.

## Goals

1. **One repo, two OSes.** macOS and Linux share the same `git pull`. No
   per-machine branches, no `.local` ad-hoc copies that drift.
2. **No dead settings on the wrong OS.** Linux Ghostty doesn't need
   `macos-titlebar-style`; macOS doesn't need `async-backend = epoll`.
3. **Idempotent setup.** Running `bootstrap.sh` twice is a no-op. Adding
   a new tool is one new entry in the script + new files in the repo.
4. **Recoverable.** Live files are never overwritten — only moved to
   `*.backup-<timestamp>`.

## OS detection

Two layers of detection:

| Layer       | Method                                  | Used by              |
| ----------- | --------------------------------------- | -------------------- |
| Bootstrap   | `case "$(uname -s)"` → `macos` / `linux` | Symlink choice       |
| zsh runtime | `case "$OSTYPE"` → `macos` / `linux` / `wsl` (`zsh/conf.d/01-environment.zsh`) | Per-OS PATH, locale, brew prefix, etc. |

The two detect *separately* so one can change without dragging the other
along — e.g., the runtime detection has a WSL branch that the bootstrap
doesn't need.

## Per-tool overlay strategy

Most tools support some "import another file" mechanism. We use that to
avoid duplicating shared content.

### Ghostty

Native directive: `config-file = <path>` (relative to the parent file's
directory; absolute and `~` paths also work). `?` prefix makes it
non-fatal if the file is missing.

```
~/.config/ghostty/config            (symlink → config.<os>)
   └─ config.<os>
        ├─ config-file = config.shared       # always
        ├─ config-file = ?<theme>            # OS-specific
        └─ <OS-specific keys>
```

### Alacritty

Native directive: `general.import = [...]` (resolved with `~` expansion;
no `?` prefix support — missing imports log a warning but don't abort).

```
~/.config/alacritty/alacritty.toml  (symlink → <os>.toml)
   └─ <os>.toml
        ├─ general.import = [shared.toml, theme.toml]
        └─ <OS-specific keys>
```

### tmux

No tool-level imports needed — the `if-shell` directive handles per-OS
conditionals inside the single `tmux.conf`. The current `tmux.conf` is
portable enough that no conditional branches are required at this time.

### zsh

Single `~/.zshrc` sources every file in `conf.d/` in glob order. Each
module checks `$_os` for OS-specific behavior. The conf.d location is
discovered via `${${:-$HOME/.zshrc}:A:h}/conf.d`, which resolves the
symlink to find conf.d alongside the actual `.zshrc` in the repo. This
means **no separate symlink for `conf.d/`** is needed.

### git, starship

Single config, identical on both OSes. Direct symlink, no overlay.

## bootstrap.sh contract

```
link <target-on-disk> <source-in-repo>
  if target is the correct symlink already   → skip
  elif target is a wrong symlink             → unlink, re-link
  elif target is a real file/dir             → mv to .backup-<ts>, link
  else                                       → mkdir -p parent, link
```

`unlink_path <target>` retires a path that no longer should exist (used
to delete `~/.config/git/config` once its content was merged into
`~/.gitconfig`).

The bootstrap never touches `nvim/`. lazy.nvim's lockfile churns on
every plugin update; symlinking it would create constant noise in
`git status` of the dotfiles repo. nvim files live in the repo for
backup but aren't under the bootstrap's control.

## Why these tools

- **Ghostty + Alacritty:** Ghostty's GPU pipeline and macOS integration
  are best-in-class; Alacritty is the universal fallback (omarchy/Wayland,
  remote sessions where Ghostty isn't installed). Both share the same
  font and key bindings as much as their config languages allow.
- **tmux** with `C-Space` prefix: ergonomic, doesn't conflict with vim
  or shell readline.
- **zsh** with a flat module system (no `oh-my-zsh`, no plugin manager
  — modules are sourced files, period).
- **starship**: prompt parity across OSes; the rich palette in
  `starship/starship.toml` is the same on both.
- **git-delta**: pretty diffs without changing core git invocations.

## Adding a new managed tool

See [`CUSTOMIZATION.md`](CUSTOMIZATION.md#adding-a-new-tool).
