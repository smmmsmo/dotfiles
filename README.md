# dotfiles

Personal cross-platform dotfiles for macOS and Linux. One repo drives both
machines; OS-specific bits live in per-OS overlay files so neither machine
carries dead settings the other will warn about.

Tools managed: **Ghostty**, **Alacritty**, **tmux**, **zsh**, **starship**, **git**.
Neovim has its own `nvim/` directory in this repo but is not touched by the
bootstrap script — manage it with `lazy.nvim` directly.

```
~/GITHUB/dotfiles/
├── bootstrap.sh        # OS-aware idempotent linker (also runs chsh)
├── README.md           # this file
├── docs/
│   ├── SETUP.md            # first-time install for macOS + Linux
│   ├── ARCHITECTURE.md     # how OS detection / overlays work
│   ├── CONFIGS.md          # per-tool reference
│   ├── CUSTOMIZATION.md    # local overrides, adding new tools
│   └── TROUBLESHOOTING.md  # known issues + fixes
│
├── ghostty/
│   ├── config.shared       # portable, imported by both overlays
│   ├── config.macos        # macOS overlay (Catppuccin Macchiato + macOS keys)
│   └── config.linux        # Linux overlay (omarchy dynamic theme + GTK)
│
├── alacritty/
│   ├── shared.toml         # portable base
│   ├── macos.toml          # macOS overlay (Catppuccin import)
│   └── linux.toml          # Linux overlay (omarchy import)
│
├── tmux/
│   ├── tmux.conf
│   └── TMUX-GUIDE.md       # cheatsheet
│
├── zsh/
│   ├── .zshrc              # modular loader (sources conf.d/*.zsh)
│   ├── .zprofile           # login-shell setup
│   ├── conf.d/             # 01-environment.zsh ... 10-tools.zsh
│   └── REFERENCE.md        # alias/function/keybind cheatsheet
│
├── starship/starship.toml
├── git/.gitconfig
└── nvim/                   # untouched by bootstrap.sh
```

## Quickstart

```sh
git clone git@github.com:smmmsmo/dotfiles.git ~/GITHUB/dotfiles
bash ~/GITHUB/dotfiles/bootstrap.sh
```

That's it. The script:
1. Detects OS via `uname -s`.
2. For each managed config: backs up any existing real file to
   `<path>.backup-<UTC timestamp>`, then creates an absolute-path symlink
   into the repo.
3. Runs `chsh -s "$(command -v zsh)"` if zsh isn't already the login shell.

Re-run any time — already-correct links are skipped.

## Symlink table

| Live path                              | Source in repo            |
| -------------------------------------- | ------------------------- |
| `~/.zshrc`                             | `zsh/.zshrc`              |
| `~/.zprofile`                          | `zsh/.zprofile`           |
| `~/.gitconfig`                         | `git/.gitconfig`          |
| `~/.config/starship.toml`              | `starship/starship.toml`  |
| `~/.config/tmux/tmux.conf`             | `tmux/tmux.conf`          |
| `~/.config/ghostty/config`             | `ghostty/config.<os>`     |
| `~/.config/alacritty/alacritty.toml`   | `alacritty/<os>.toml`     |

`<os>` is `macos` or `linux`.

## Where to read next

- New machine? → [`docs/SETUP.md`](docs/SETUP.md)
- Want to understand the layout? → [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- Adding a new tool / customizing? → [`docs/CUSTOMIZATION.md`](docs/CUSTOMIZATION.md)
- Something broken? → [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)
- Per-tool reference → [`docs/CONFIGS.md`](docs/CONFIGS.md)
