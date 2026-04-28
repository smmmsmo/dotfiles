# CUSTOMIZATION

## Machine-local overrides

For settings that differ per machine (a different font size on the
external monitor, a corp-issued git identity, …) — keep them out of git
and let the existing config files load them.

### Ghostty

`config.shared` ends with:

```
config-file = ?config.local
```

The `?` makes it optional. To use it:

```sh
echo "font-size = 17" > ~/GITHUB/dotfiles/ghostty/config.local
```

`.gitignore` already excludes `ghostty/config.local`.

### Alacritty

Alacritty's `general.import` does not support `?`-prefix optionals, but
missing imports degrade to a warning, not a hard error. Recommended
pattern: append a local file to your OS overlay's import list when you
need it.

```toml
# in ~/GITHUB/dotfiles/alacritty/linux.toml
[general]
import = [
  "~/GITHUB/dotfiles/alacritty/shared.toml",
  "~/.config/omarchy/current/theme/alacritty.toml",
  "~/GITHUB/dotfiles/alacritty/local.toml",   # add this row
]
```

`alacritty/local.toml` is gitignored. Create it as needed.

### zsh

`zsh/conf.d/` files are sourced in numeric order. To add machine-local
zsh, drop a `99-local.zsh` (or similar — the loader globs by `*.zsh`):

```sh
cat > ~/GITHUB/dotfiles/zsh/conf.d/99-local.zsh <<'EOF'
# work laptop only
[[ -d /Applications/Docker.app ]] && alias dc=docker-compose
EOF
```

If you don't want it tracked, gitignore it:

```sh
echo "zsh/conf.d/99-local.zsh" >> ~/GITHUB/dotfiles/.gitignore
```

### git

Use the standard `[includeIf]` pattern for per-directory identities:

```ini
# in ~/.gitconfig (i.e., the file at git/.gitconfig)
[includeIf "gitdir:~/Work/"]
    path = ~/Work/.gitconfig.work
```

Or keep work identity in a non-tracked file and `[include]` it.

## Adding a new tool

Walk through with a hypothetical `bat` config.

### 1. Create the config in the repo

```sh
mkdir -p ~/GITHUB/dotfiles/bat
$EDITOR ~/GITHUB/dotfiles/bat/config
```

If the tool needs OS variants, mirror Ghostty/Alacritty: drop a
`shared.<ext>` plus `<os>.<ext>` overlay files.

### 2. Add a symlink line to `bootstrap.sh`

```bash
# inside bootstrap.sh
link "~/.config/bat/config" "$REPO/bat/config"
```

For OS-variant tools:

```bash
link "~/.config/somewhere/config" "$REPO/tool/config.${OS}"
```

### 3. Re-run

```sh
bash ~/GITHUB/dotfiles/bootstrap.sh
```

It picks up the new line and links. Existing files at the target are
backed up automatically.

### 4. Document

Add a row to the table in `README.md` and a section in `docs/CONFIGS.md`.

## Customizing the prompt

`starship/starship.toml` is one file. Common tweaks:

- **Change palette:** edit `palette = "midnight_horizon"` near the top
  and the `[palettes.midnight_horizon]` block. Or add a new palette and
  switch in one line.
- **Move language modules off the right side:** delete or shorten
  `right_format`, then drop the modules into `format` instead.
- **Hide a module on a slow command:** set its `disabled = true` or
  bump `command_timeout` lower.

## Customizing Alacritty colors on macOS

The macOS overlay imports `~/.config/alacritty/themes/catppuccin-macchiato.toml`.
Drop in any other Catppuccin variant or a different theme entirely:

```sh
curl -L -o ~/.config/alacritty/themes/tokyo-night.toml \
  https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/tokyo_night.toml
# then edit alacritty/macos.toml to point at the new file
```

## Customizing Ghostty themes

Ghostty ships a large theme catalog. List them:

```sh
ghostty +list-themes
```

Set one in the OS overlay file (`config.macos` or `config.linux`):

```
theme = "Tokyo Night Storm"
```

## Adding a tmux plugin

The current `tmux.conf` is plugin-free on purpose. If you want TPM:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then add to the bottom of `tmux/tmux.conf`:

```tmux
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
run '~/.tmux/plugins/tpm/tpm'
```

Reload with `prefix + q` (the binding in this config) and install
plugins with `prefix + I`.
