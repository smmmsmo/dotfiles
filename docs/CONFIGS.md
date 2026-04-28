# CONFIGS — per-tool reference

A high-level tour of what each managed config does. For the exhaustive
key list, read the file itself — the configs are commented inline.

## Ghostty

Three files: `config.shared` + `config.<os>`. The OS overlay starts with
`config-file = config.shared` and then layers OS-specific keys on top.

### `config.shared`
- Font: CaskaydiaMono Nerd Font, thicken on, slight cell-height bump.
- Cursor/selection: Catppuccin-friendly hex codes.
- Clipboard: ask before reading, copy on select, right-click pastes.
- Scrollback: ~10 MB per surface.
- Keybinds: super-prefixed binds for splits, tabs, font size, reload —
  all of which work on both OSes (Ghostty maps `super` to Cmd on macOS
  and the Super/Win key on Linux).
- Loads optional `?config.local` for machine-specific overrides.

### `config.macos`
- Theme: `Catppuccin Macchiato`.
- Font size 15, `display-p3` colorspace, system scrollbar, background
  blur + 96% opacity.
- macOS-specific: transparent titlebar, left option-as-alt, secure
  input indication, non-native fullscreen.
- Quick terminal (drop-down, `super+ctrl+space`).
- macOS Notification Center forwarding (`desktop-notifications = true`).

### `config.linux`
- Theme: dynamic via omarchy
  (`?"~/.config/omarchy/current/theme/ghostty.conf"`).
- Font size 9 (Linux DPI), no cursor blink, GTK toolbar flat.
- `async-backend = epoll` — workaround for Hyprland slowness
  ([ghostty#3224](https://github.com/ghostty-org/ghostty/discussions/3224)).
- Linux clipboard binds: shift+insert / control+insert.
- Split resize via super+ctrl+shift+alt+arrow.

## Alacritty

Three files: `shared.toml` + `<os>.toml`. The OS overlay imports the
shared file via `general.import`.

### `shared.toml`
- `[env] TERM = xterm-256color`, OSC52 clipboard pass-through.
- Font: CaskaydiaMono Nerd Font (Regular/Bold/Italic).
- Padding 14×14, 100k line scrollback, `save_to_clipboard` on selection.
- Bindings: shift+insert paste, control+insert copy, shift+enter sends
  `ESC \r` (alt-enter emulation for terminal apps that need it).

### `linux.toml`
- Imports omarchy theme: `~/.config/omarchy/current/theme/alacritty.toml`.
- Font size 9.
- `decorations = "None"` (titlebar-less).

### `macos.toml`
- Imports Catppuccin theme from `~/.config/alacritty/themes/`.
- Font size 14.
- `decorations = "Buttonless"`, `option_as_alt = "Both"`.
- Window opacity 96% with blur.

## tmux

Single `tmux.conf`. Highlights:

- **Prefix:** `C-Space` (primary), `C-b` retained as secondary.
- **Vi-mode copy:** `v` begins selection, `y` copies to system clipboard
  via `set -g set-clipboard on` + OSC52.
- **Splits:** `prefix + h` (horizontal, below) / `prefix + v` (vertical,
  right). Splits inherit the current pane's path.
- **Pane navigation/resize:** `Ctrl-Alt-Arrow` to move,
  `Ctrl-Alt-Shift-Arrow` to resize 5 cells. No prefix needed.
- **Window jumping:** `Alt-1..9` to a numbered window; `Alt-Left/Right`
  for previous/next; `Alt-Shift-Left/Right` to swap.
- **Sessions:** `prefix + R` rename, `prefix + C` new, `prefix + K`
  kill. `Alt-Up/Down` to cycle clients across sessions.
- **General:** mouse on, base-index 1, renumber on close, 50k history,
  escape-time 0, focus-events on, allow-passthrough on.
- **Theme:** monochrome blue accent on a transparent status bar.
  `prefix`/`copy`/`zoom` indicators on the right.

For the full keybind tour: [`tmux/TMUX-GUIDE.md`](../tmux/TMUX-GUIDE.md).

## zsh

`~/.zshrc` is a 50-line loader. Real config lives in `zsh/conf.d/`,
sourced in numeric order:

| File                  | Concern                                  |
| --------------------- | ---------------------------------------- |
| `01-environment.zsh`  | OS detection, locale, EDITOR, XDG, PATH, pager |
| `02-options.zsh`      | `setopt` flags, history config           |
| `03-completion.zsh`   | `fpath`, `compinit`, `zstyle` rules      |
| `04-keybindings.zsh`  | `bindkey` mappings                       |
| `05-fzf.zsh`          | fzf defaults + shell integration         |
| `06-plugins.zsh`      | autosuggestions, syntax-highlighting, history-substring-search |
| `07-prompt.zsh`       | `eval "$(starship init zsh)"`             |
| `08-aliases.zsh`      | navigation, git, docker, tools           |
| `09-functions.zsh`    | `extract`, fzf helpers, etc.             |
| `10-tools.zsh`        | zoxide, direnv (`eval` hooks last)       |

Cheatsheet: [`zsh/REFERENCE.md`](../zsh/REFERENCE.md).

## git

Single `.gitconfig` covers identity, delta pager, defaults, aliases,
and LFS:

- **Identity:** noreply GitHub address.
- **Pager:** delta with `tokyonight` theme, navigate mode, line numbers.
- **Defaults:** `defaultBranch=master`, `pull.rebase=true`,
  `push.autoSetupRemote=true`, `commit.verbose=true`.
- **Diff:** histogram algorithm, colorMoved, mnemonic prefixes.
- **Merge:** `conflictstyle = zdiff3`.
- **Branch/tag:** sorted by recency / version.
- **rerere:** enabled with autoupdate.
- **Aliases:** `co=checkout`, `br=branch`, `ci=commit`, `st=status`.
- **LFS:** filter block.

## starship

One `starship.toml` driving prompt and right prompt.

- Custom palette `midnight_horizon` (Tokyo Night-ish blues/teals).
- Two-line layout: `╭─` context line, `╰─` runtime/status line.
- Right prompt shows language/runtime versions (Python, Node, Go, Rust,
  Java, Lua, Ruby) and battery.
- `add_newline = false`, `command_timeout = 1500`, `scan_timeout = 30`.
- Modules to look at if you want to tweak: `[directory]`, `[git_status]`,
  `[fill]`, `[time]`.
