# Ghostty

macOS-native terminal emulator. This config lives at `~/.config/ghostty/config` and loads optional machine-local overrides from `~/.config/ghostty/config.local` when present.

Authoritative reference:

```sh
ghostty +show-config --default --docs | less
```

## Sections

| Block           | What it does |
|-----------------|---------------|
| Theme           | `Catppuccin Macchiato` palette. |
| Typography      | `CaskaydiaMono Nerd Font Mono` 15pt, thickened 100, underline offset +1. `adjust-cell-height 5%` adds breathing room. |
| Appearance      | 96 % opacity + background blur, block cursor (non-blinking), system scrollbar, dimmed inactive splits (0.85). |
| Clipboard       | Copy-on-select to system clipboard, trimmed trailing whitespace, right-click copies selection or pastes if nothing is selected, paste from outside asks for permission. |
| Scrollback      | ~10 MB per surface (`scrollback-limit = 10000000`). |
| Window          | 140 × 38 default size, 10 px padding, inherits working directory, saves & restores state across launches. `display-p3` color space for accurate theme colors on modern Macs. |
| Shell           | zsh integration with cursor / sudo / title / ssh-env / ssh-terminfo / path features. |
| Quick terminal  | `super+ctrl+space` drop-down, 34 % screen height, 0.18 s animation. |
| macOS           | Transparent titlebar, left-option acts as Alt, secure-input auto-enabled on password prompts with an indicator, non-native fullscreen keeps menu bar visible. |
| Notifications   | `desktop-notifications = true`. Shell integration emits OSC 9 on command completion; Ghostty forwards to Notification Center when the window is unfocused. |

## Keybinds

All defined at the bottom of the config. Super is Cmd on macOS.

### Global

| Keys                    | Action |
|-------------------------|--------|
| `super+ctrl+space`      | Toggle quick terminal |
| `super+shift+r`         | Reload config |
| `super+comma`           | Open config file in editor |
| `super+k`               | Clear screen |

### Splits

| Keys                      | Action |
|---------------------------|--------|
| `super+d`                 | Split right |
| `super+shift+d`           | Split down |
| `super+shift+h/j/k/l`     | Focus split left / down / up / right |
| `super+shift+z`           | Zoom / unzoom current split |

### Tabs

| Keys                        | Action |
|-----------------------------|--------|
| `super+t`                   | New tab |
| `super+w`                   | Close surface (split or tab) |
| `super+shift+w`             | Close whole tab |
| `super+shift+]` / `[`       | Next / previous tab |
| `super+1..9`                | Jump directly to tab N |

### Font

| Keys            | Action |
|-----------------|--------|
| `super+=`       | Increase font size |
| `super+-`       | Decrease font size |
| `super+0`       | Reset font size |

## Machine-local overrides

The last line of `config` is `config-file = ?config.local`. The `?` means "don't error if missing." Create `~/.config/ghostty/config.local` on any machine where you want a different font size, theme, or opacity without editing the shared config.

## Troubleshooting

- **Keybind didn't take effect:** run `super+shift+r` to reload, or check `ghostty +show-config` to confirm parsing. Errors print to stderr when Ghostty is launched from a terminal.
- **Colors look washed out inside tmux or neovim:** ensure the terminfo entry loaded by those programs advertises RGB. For tmux this config already sets `terminal-features ",*:RGB"`.
- **Secure input stuck on:** shown by the lock icon in the titlebar while typing passwords. Ghostty disables it automatically, but you can force a reset with `super+shift+r`.
- **`config-file = ?config.local` errors:** only on Ghostty < 1.0, where the `?` optional-file syntax was unsupported. Delete the line or upgrade.
