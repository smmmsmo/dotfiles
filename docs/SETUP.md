# SETUP

First-time install on a fresh machine.

## 1. Install dependencies

### macOS

```sh
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Required
brew install zsh git tmux starship git-delta git-lfs
brew install --cask ghostty alacritty
brew install --cask font-caskaydia-mono-nerd-font

# Optional but assumed by the zsh modules
brew install fzf bat zoxide direnv eza ripgrep fd jq
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
```

### Arch Linux (omarchy)

```sh
sudo pacman -S --needed zsh git tmux starship git-delta git-lfs alacritty \
  fzf bat zoxide direnv eza ripgrep fd jq \
  zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search \
  ttf-cascadia-code-nerd
# Ghostty: `paru -S ghostty` or download a release tarball
```

### Ubuntu / Debian

```sh
sudo apt install -y zsh git tmux git-lfs fzf bat zoxide direnv ripgrep fd-find jq
# starship, git-delta, eza: install from their release pages or via cargo
# Ghostty / Alacritty: download release builds; nerd font: download zip into ~/.local/share/fonts and run fc-cache -fv
```

## 2. Clone

```sh
mkdir -p ~/GITHUB && cd ~/GITHUB
git clone git@github.com:smmmsmo/dotfiles.git
```

> **Why `~/GITHUB`?** The Alacritty overlays import paths are written as
> `~/GITHUB/dotfiles/alacritty/shared.toml`. If you clone to a different
> location, edit those imports (or symlink `~/GITHUB/dotfiles` to wherever
> you cloned it).

## 3. Run bootstrap

```sh
bash ~/GITHUB/dotfiles/bootstrap.sh
```

Expected output (first run):

```
bootstrap (os=linux, repo=/home/you/GITHUB/dotfiles)

  link  ~/.zshrc  → /home/you/GITHUB/dotfiles/zsh/.zshrc
  link  ~/.zprofile  → /home/you/GITHUB/dotfiles/zsh/.zprofile
  link  ~/.gitconfig  → /home/you/GITHUB/dotfiles/git/.gitconfig
  back  ~/.config/git/config  (removed; → …/config.backup-…)
  back  ~/.config/starship.toml  → …/starship.toml.backup-…
  link  ~/.config/starship.toml  → …/starship/starship.toml
  link  ~/.config/tmux/tmux.conf  → …/tmux/tmux.conf
  link  ~/.config/ghostty/config  → …/ghostty/config.linux
  link  ~/.config/alacritty/alacritty.toml  → …/alacritty/linux.toml

login-shell running: chsh -s /usr/bin/zsh  (will prompt for password)
login-shell now /usr/bin/zsh — takes effect on next login

done
```

`bootstrap.sh` skips `chsh` automatically when stdin isn't a TTY (e.g., when
run from a non-interactive script). Set `BOOTSTRAP_NO_CHSH=1` to force-skip
even in interactive mode. Run `chsh` yourself afterwards if needed:

```sh
chsh -s "$(command -v zsh)"
```

## 4. macOS-only post-install

### Fetch the Catppuccin Alacritty palette

The macOS overlay imports `~/.config/alacritty/themes/catppuccin-macchiato.toml`.
The import is optional — Alacritty falls back to default colors if the file is
missing — but if you want the theme:

```sh
mkdir -p ~/.config/alacritty/themes
curl -L -o ~/.config/alacritty/themes/catppuccin-macchiato.toml \
  https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-macchiato.toml
```

### Ghostty config location

Ghostty reads `~/.config/ghostty/config` (XDG path) on macOS as well as the
older `~/Library/Application Support/com.mitchellh.ghostty/config`. The
bootstrap symlink at `~/.config/ghostty/config` is enough — no extra step.

### Grant Secure Input permission (optional)

`config.macos` enables `macos-auto-secure-input`. macOS may prompt for input
monitoring permission the first time Ghostty launches.

## 5. Linux-only post-install

### Omarchy theme integration

`config.linux` and `linux.toml` both `import` from
`~/.config/omarchy/current/theme/`. As long as omarchy is installed, theme
switching from the omarchy menu propagates to both terminals automatically.

If you're not on omarchy, either:
1. Replace those imports with hard-coded theme paths, or
2. Create a stub: `mkdir -p ~/.config/omarchy/current/theme && touch
   ~/.config/omarchy/current/theme/{ghostty.conf,alacritty.toml}` — the
   imports are `?`-prefixed (Ghostty) / hard (Alacritty) so the stub
   prevents Alacritty errors. For Alacritty, edit `linux.toml` to drop the
   omarchy import line if you'd rather pick a theme directly.

### Login shell after `chsh`

`chsh` only takes effect on next login. To switch the current session to
zsh without logging out: `exec zsh -l`.

## 6. Verify

```sh
# Symlinks all point into the repo
ls -l ~/.zshrc ~/.gitconfig ~/.config/{starship.toml,tmux/tmux.conf,ghostty/config,alacritty/alacritty.toml}

# Git settings resolve
git config --get user.email
git config --get alias.co        # → "checkout"
git config --get pull.rebase     # → "true"

# Tools start without errors
alacritty --print-events &       # Ctrl-D to close
tmux new -A -s test
starship explain
```
