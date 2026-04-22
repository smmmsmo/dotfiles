# tmux

Terminal multiplexer. Config at `~/.config/tmux/tmux.conf`. Plugins managed by TPM under `~/.config/tmux/plugins/`.

- **Prefix:** `Ctrl+Space`
- **Theme:** Tokyo Night (inline — no external theme plugin)
- **Bootstrap:** TPM auto-clones itself on first start. Press `prefix + I` after launch to install plugins.

## Cheat sheet

### Core

| Keys             | Action |
|------------------|--------|
| `prefix + ,`     | Reload config |
| `prefix + c`     | New window (inherits CWD) |
| `prefix + C`     | New session (inherits CWD) |
| `prefix + r`     | Rename window (prefilled) |
| `prefix + S`     | Rename session (prefilled) |
| `prefix + s`     | Session tree with preview |
| `prefix + O`     | sessionx — fzf session picker |
| `prefix + x`     | Kill pane (confirm) |
| `prefix + X`     | Kill current session (confirm) |
| `prefix + e`     | Respawn pane after command exited |

### Splits

| Keys             | Action |
|------------------|--------|
| `prefix + \|`    | Vertical split (CWD preserved) |
| `prefix + \\`    | Alias for `\|` (no shift needed) |
| `prefix + -`     | Horizontal split |
| `prefix + z`     | Zoom / unzoom current pane (tmux default) |
| `prefix + b`     | Break pane into its own window |
| `prefix + B`     | Join pane from another window |

### Navigation

| Keys                 | Action |
|----------------------|--------|
| `Ctrl+h/j/k/l`       | Move between panes (seamless with Neovim via vim-tmux-navigator) |
| `prefix + ;`         | Last pane |
| `prefix + Tab`       | Last window |
| `Alt+1..9`           | Jump directly to window N |
| `prefix + n` / `p`   | Next / prev window (repeatable) |
| `Alt+Up` / `Alt+Down`| Previous / next session |
| `prefix + H/J/K/L`   | Resize pane (repeatable) |
| `prefix + <` / `>`   | Swap pane up / down |

### Copy mode (vi)

| Keys                 | Action |
|----------------------|--------|
| `prefix + v` or `[`  | Enter copy mode |
| `v`                  | Begin selection |
| `Ctrl+v`             | Toggle rectangle / block selection |
| `y` or `Enter`       | Yank to clipboard, exit |
| `Ctrl+u` / `Ctrl+d`  | Half-page up / down |
| `g` / `G`            | Top / bottom of scrollback |
| `/` / `?`            | Incremental search down / up |
| `o` (tmux-open)      | Open highlighted URL or path |

### Extras

| Keys             | Action |
|------------------|--------|
| `prefix + g`     | Popup scratch session (attaches to persistent `scratch`) |
| `prefix + u`     | fzf-url — pick a URL from visible text and open it |
| `prefix + space` | tmux-thumbs — hint-mode copy of any path / hash / URL |
| `prefix + Shift+space` | tmux-thumbs — copy **and** open the match |
| `prefix + Tab`   | extrakto — fzf over visible pane text (⚠ overrides default last-window; swap keys if unwanted) |
| `prefix + P`     | Toggle synchronize-panes (broadcast input) |
| `prefix + *`     | Toggle pipe-pane logging to `~/tmux-<window>.log` |
| `prefix + Ctrl+s`| tmux-resurrect save |
| `prefix + Ctrl+r`| tmux-resurrect restore |

> **Key conflict note:** `prefix + Tab` is bound to both `last-window` and extrakto in this config. The extrakto plugin binding loads last, so it wins. If you want `last-window` back, set `@extrakto_key` to something else (e.g. `e`) in `tmux.conf`.

## Structure

```
~/.config/tmux/
├── tmux.conf            main config (heavily commented)
├── plugins/             TPM-managed; auto-populated
│   ├── tpm/
│   ├── tmux-resurrect/
│   ├── tmux-continuum/
│   └── ... (the rest listed below)
└── docs/
    └── README.md        this file
```

## Plugins

Declared in order under the "PLUGINS" section of `tmux.conf`:

| Plugin                        | Purpose |
|-------------------------------|---------|
| `tmux-plugins/tpm`            | Plugin manager itself (must be first). |
| `tmux-plugins/tmux-resurrect` | Save / restore sessions (`prefix+Ctrl+s` / `prefix+Ctrl+r`). Pane contents preserved. For Neovim restoration, `@resurrect-strategy-nvim = session` requires a Neovim session plugin (persistence.nvim or auto-session) to produce a session file on exit. |
| `tmux-plugins/tmux-continuum` | Auto-saves every 15 min, auto-restores on tmux start. |
| `tmux-plugins/tmux-yank`      | OSC-52 + pbcopy / xclip / xsel auto-detection. |
| `christoomey/vim-tmux-navigator` | Seamless `Ctrl+h/j/k/l` between tmux panes and Neovim splits. Requires the matching Neovim plugin. |
| `omerxx/tmux-sessionx`        | fzf session picker with previews (`prefix+O`). |
| `tmux-plugins/tmux-open`      | In copy mode, `o` opens the highlighted path/URL. |
| `wfxr/tmux-fzf-url`           | `prefix+u` fuzzy-picks any visible URL and opens it. |
| `fcsonline/tmux-thumbs`       | vimium-style hint jumps to copy / open paths, hashes, URLs, IPs. |
| `laktak/extrakto`             | fzf over all visible pane text; yanks or inserts selection at prompt. |

### Plugin management

```
prefix + I    install new plugins listed in the config
prefix + U    update installed plugins
prefix + Alt+u  uninstall plugins that are no longer in the config
```

## Terminal capabilities

- `default-terminal "tmux-256color"` — advertises 256-color support to programs inside tmux.
- `terminal-features ",*:RGB"` — 24-bit color (3.2+ preferred form vs. the older `terminal-overrides` RGB hack).
- `terminal-features ",*:usstyle"` + explicit `Smulx` / `Setulc` overrides — undercurl and colored underlines (Neovim LSP diagnostics render correctly).
- `allow-passthrough on` — OSC passthrough for inline images (kitty/iTerm2 image protocol, Ghostty). Set to `on` (active pane) rather than `all` to reduce SSH attack surface.
- `set-clipboard on` — OSC 52 clipboard passthrough.
- `focus-events on` — forwards focus changes so Neovim autoread + dim-on-blur work.

## Status bar

Tokyo Night palette, top-positioned, refreshed every 1 s.

- **Left:** session name on blue.
- **Window list:** dimmed for inactive, blue accent for active, yellow highlight for activity, red for bell.
- **Right:** `PREFIX / COPY / ZOOM / SYNC` state indicators, then `%H:%M`.
- **Pane borders:** dim line for inactive, blue for active; border title shows `#P #{pane_current_command}` so you always know what's running where.

## Sessions across restarts

tmux-resurrect + tmux-continuum together mean:

1. Every 15 minutes, current sessions (including pane contents) are snapshotted to `~/.local/share/tmux/resurrect/`.
2. On next tmux start, the latest snapshot is restored automatically.
3. Manual save / restore via `prefix+Ctrl+s` / `prefix+Ctrl+r`.

What is *not* restored automatically:

- Running processes (resurrect writes metadata, not PIDs). Your editors / REPLs are relaunched from the command line recorded at snapshot time.
- Shell history state in the pane (the pane's shell starts fresh).

## Troubleshooting

- **`prefix + I` does nothing / plugins not installing:** confirm TPM is cloned: `ls ~/.config/tmux/plugins/tpm`. The bootstrap line at the bottom of `tmux.conf` should clone it on first start; if not, clone manually:

  ```sh
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  ```

- **Colors washed out in Neovim:** you're almost certainly missing the RGB terminal feature. Verify from inside tmux:

  ```sh
  tmux info | grep -i rgb
  ```

  Should show `RGB: (flag) true`.

- **Clipboard not working under macOS:** modern Ghostty + tmux-yank works out of the box. Only if you hit issues on old macOS: `brew install reattach-to-user-namespace` and uncomment the `if-shell "uname | grep -q Darwin"` block near the end of `tmux.conf`.

- **Ctrl+Space doesn't reach tmux:** some terminal emulators swallow it. Either change the prefix (top of `tmux.conf`) or bind Ghostty to pass it through — Ghostty 1.0+ does by default.

- **tmux-thumbs first run is slow:** it compiles a Rust binary on first use. Install ahead of time with `brew install tmux-thumbs`, or wait out the one-time cargo build.

- **extrakto stole my `prefix+Tab`:** change `@extrakto_key` in `tmux.conf` to a different key (the `last-window` binding is restored automatically once extrakto stops claiming Tab).
