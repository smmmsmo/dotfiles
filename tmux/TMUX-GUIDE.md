# tmux Configuration Guide

Personal tmux setup — Tokyo Night theme, Neovim-friendly, works on macOS and Linux.

**Config location:** `~/.config/tmux/tmux.conf`
**Dotfiles source:** `dotfiles/tmux/.config/tmux/tmux.conf`
The machine config is a symlink to the dotfiles source, so editing either one is the same file.

**Prefix key:** `Ctrl+Space`
Everything below that says "prefix +" means press `Ctrl+Space` first, then the key.

---

## Fresh Machine Setup

```bash
# 1. Clone dotfiles and stow tmux
git clone <your-dotfiles-repo> ~/github/dotfiles
cd ~/github/dotfiles
stow tmux   # or manually: ln -s ~/github/dotfiles/tmux/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf

# 2. Start tmux — TPM clones itself automatically on first launch
tmux

# 3. Install all plugins
prefix + I   # capital I
```

That's it. Sessions start restoring automatically via tmux-continuum.

---

## Prefix Key

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Activate prefix (wait for next key) |
| `prefix + r` | Reload config (live, no restart needed) |
| `prefix + ?` | List every keybinding currently active |
| `prefix + t` | Show a clock (press any key to close) |

When you press `Ctrl+Space` the left status badge turns **red** and shows `PREFIX` — confirming tmux is waiting for your next key.

---

## Sessions

Sessions are the top-level containers. Think of each session as a project or context.

| Key | Action |
|-----|--------|
| `prefix + s` | Open session/window tree picker (with preview) |
| `prefix + $` | Rename current session |
| `Alt+Up` | Switch to previous session (no prefix needed) |
| `Alt+Down` | Switch to next session (no prefix needed) |
| `prefix + d` | Detach from tmux (leaves everything running) |

```bash
# Create a named session from the terminal
tmux new -s myproject

# Attach to a session by name
tmux attach -t myproject

# List all sessions
tmux ls
```

> **Tip:** When you kill a session, tmux switches to the next one instead of exiting — you never lose your other sessions by accident.

---

## Windows

Windows are tabs within a session. Each window can have multiple panes.

| Key | Action |
|-----|--------|
| `prefix + c` | New window (opens in current directory) |
| `prefix + ,` | Rename current window |
| `prefix + Tab` | Toggle to last used window |
| `Alt+]` | Next window (no prefix) |
| `Alt+[` | Previous window (no prefix) |
| `prefix + n` | Next window (with repeat) |
| `prefix + p` | Previous window (with repeat) |
| `Alt+1` … `Alt+9` | Jump directly to window 1–9 (no prefix) |

> **Tip:** `Alt+1..9` is the fastest way to switch windows. Rename your windows (`prefix + ,`) so the tabs are meaningful.

---

## Panes

Panes split a window into multiple terminals side-by-side or stacked.

### Splitting

| Key | Action |
|-----|--------|
| `prefix + \|` | Split vertically (side by side) |
| `prefix + \\` | Same as above (no Shift needed) |
| `prefix + -` | Split horizontally (top and bottom) |

All splits open in the current pane's working directory.

### Navigating

| Key | Action |
|-----|--------|
| `prefix + h` | Move to pane on the left |
| `prefix + j` | Move to pane below |
| `prefix + k` | Move to pane above |
| `prefix + l` | Move to pane on the right |

### Resizing

Hold prefix, then press repeatedly — the `-r` flag means you don't need to re-press prefix for each step.

| Key | Action |
|-----|--------|
| `prefix + H` | Move border left (narrows pane) |
| `prefix + J` | Move border down (tallens pane) |
| `prefix + K` | Move border up (shortens pane) |
| `prefix + L` | Move border right (widens pane) |

Each press moves the border 5 cells.

### Other Pane Actions

| Key | Action |
|-----|--------|
| `prefix + x` | Kill current pane (asks confirmation) |
| `prefix + z` | Zoom pane to full window (press again to restore) |
| `prefix + q` | Show pane numbers (press a number to jump to it) |
| `prefix + <` | Swap pane with previous |
| `prefix + >` | Swap pane with next |
| `prefix + b` | Break pane out into its own window |
| `prefix + B` | Pull a pane from another window into this one |

> **Tip:** When a pane is zoomed, the status bar shows a green **ZOOM** badge on the right so you never forget you're in zoom mode.

---

## Popup Terminal

A floating terminal overlay — opens over your current layout without disturbing it.

| Key | Action |
|-----|--------|
| `prefix + g` | Open popup shell (80% width × 80% height, current directory) |
| `q` or `exit` | Close the popup |

Use it for quick git commands, file lookups, or one-off scripts without creating a new pane or window.

---

## Copy Mode

Copy mode lets you scroll through history and copy text — like vim's visual mode for the terminal.

### Entering / Exiting

| Key | Action |
|-----|--------|
| `prefix + v` | Enter copy mode |
| `prefix + [` | Enter copy mode (tmux default, still works) |
| `q` or `Escape` | Exit copy mode |

The status bar shows a yellow **COPY** badge while you are in copy mode.

### Moving Around

| Key | Action |
|-----|--------|
| `h j k l` | Move character by character (vim motions) |
| `w / b` | Jump forward / backward by word |
| `0` / `$` | Start / end of line |
| `C-u` | Half page up |
| `C-d` | Half page down |
| `g` | Jump to top of scrollback history |
| `G` | Jump to bottom of scrollback history |

### Searching

| Key | Action |
|-----|--------|
| `/` | Search forward (incremental — results highlight as you type) |
| `?` | Search backward (incremental) |
| `n` | Jump to next match |
| `N` | Jump to previous match |

### Selecting and Copying

| Key | Action |
|-----|--------|
| `v` | Start character selection |
| `C-v` | Toggle rectangle / block selection |
| `y` | Yank selection → system clipboard, exit copy mode |
| `Enter` | Same as `y` |
| Mouse drag | Select and copy on release |

Copied text lands in your system clipboard (macOS `pbcopy`, Linux `xclip`/`xsel`) via tmux-yank — paste anywhere with `Cmd+V` / `Ctrl+V`.

---

## URL Opening

Two ways to open URLs from the terminal without touching the mouse:

### tmux-open (in copy mode)
1. Enter copy mode (`prefix + v`)
2. Move cursor over a URL or file path
3. Press `o` — opens in browser (macOS: `open`, Linux: `xdg-open`)
4. Press `Ctrl+o` — opens in `$EDITOR`

### tmux-fzf-url (fuzzy picker)
1. Press `prefix + u`
2. All URLs visible in the current pane are listed
3. Use fuzzy search to narrow down, press Enter to open in browser

---

## Session Save and Restore (tmux-resurrect + tmux-continuum)

Your sessions, windows, panes, and working directories are saved automatically every 15 minutes and restored when tmux starts.

| Key | Action |
|-----|--------|
| `prefix + Ctrl+s` | Save session manually right now |
| `prefix + Ctrl+r` | Restore last saved session manually |

Neovim sessions are also restored (open buffers, splits, working directory) via `tmux-resurrect-strategy-nvim`.

> **Note:** Auto-restore happens on tmux server start. If you launch tmux and your windows are empty, press `prefix + Ctrl+r` once — after that it's automatic.

---

## Status Bar Reference

```
 TMUX  myproject   win1  win2  win3        COPY  ZOOM   Apr 17  14:32  mymac
 ────  ─────────   ──────────────────      ────────────────────────────────
 left: prefix      window tabs             right: state + date + time + host
```

| Badge | Meaning |
|-------|---------|
| `PREFIX` (red) | tmux is waiting for your next key after `Ctrl+Space` |
| `TMUX` (blue) | Normal state — no prefix active |
| `COPY` (yellow) | You are in copy mode |
| `ZOOM` (green) | Current pane is zoomed |
| Hostname (`#H`) | Which machine you are on — useful over SSH |
| Window tab (yellow, bold) | That window has unseen activity |
| Window tab (red, bold) | That window has a bell |

---

## Pane Border

Each pane has a thin title line at the top showing:
```
 1 nvim       2 zsh       3 git
```
- Number = pane index (used with `prefix + q` to jump)
- Name = the command currently running in that pane

---

## Plugins Installed

| Plugin | What it does |
|--------|-------------|
| `tmux-resurrect` | Save and restore sessions manually |
| `tmux-continuum` | Auto-save every 15 min, auto-restore on start |
| `tmux-yank` | Clipboard integration on macOS and Linux |
| `tmux-open` | Open files/URLs from copy mode with `o` |
| `tmux-fzf-url` | Fuzzy-pick URLs from scrollback with `prefix + u` |

### Managing plugins

```
prefix + I        Install new plugins listed in tmux.conf
prefix + U        Update all installed plugins
prefix + Alt+u    Uninstall plugins removed from tmux.conf
```

> **Note:** Removing a plugin from `tmux.conf` does not delete its files — you must press `prefix + Alt+u` to physically remove it from `~/.config/tmux/plugins/`.

---

## Common Workflows

### Starting a new project
```bash
tmux new -s projectname
# Split into editor + terminal
prefix + |        # side-by-side split
nvim .            # open editor in left pane
prefix + l        # move to right pane
```

### Working across multiple machines (SSH)
```bash
# On local machine
tmux new -s local

# SSH into server in a new window
prefix + c
ssh user@server

# Now Alt+1 is local, Alt+2 is server
# The hostname in the status bar tells you which pane is which
```

### Recovering after a reboot
```bash
tmux   # start tmux — continuum restores automatically
# or manually: prefix + Ctrl+r
```

### Quick command without breaking layout
```
prefix + g    # popup terminal opens over your current work
git push
exit          # popup closes, you're back exactly where you were
```

---

## Troubleshooting

**Prefix not working**
Some terminals intercept `Ctrl+Space`. Test with `cat` — press `Ctrl+Space` and see if anything appears. If nothing does, your terminal is eating the key. Switch prefix to `C-a` in the config.

**Colors look wrong in Neovim**
Make sure your terminal is set to `tmux-256color` or `xterm-256color` and that `$TERM` inside tmux reports `tmux-256color`. Run `:checkhealth` in Neovim.

**Clipboard not working on Linux**
Install `xclip` or `xsel`:
```bash
sudo apt install xclip    # Debian/Ubuntu
sudo pacman -S xclip      # Arch
```

**Inline images not showing (Ghostty)**
The config has `allow-passthrough all` (global, covers all panes). If images still don't show, check that your image.nvim or similar plugin is configured for the correct protocol (ghostty or kitty). Requires tmux 3.3+.

**Plugins not loading**
TPM auto-bootstraps but you still need to install plugins once:
```
prefix + I
```
If TPM itself isn't present, restart tmux — the bootstrap script clones it automatically.

**`prefix + u` does nothing (URL picker)**
`tmux-fzf-url` requires `fzf` to be installed:
```bash
brew install fzf        # macOS
sudo apt install fzf    # Debian/Ubuntu
sudo pacman -S fzf      # Arch
```

**Sessions not restoring**
tmux-continuum saves to `~/.local/share/tmux/resurrect/`. If the directory is missing or the save file is empty, trigger a manual save first: `prefix + Ctrl+s`.
