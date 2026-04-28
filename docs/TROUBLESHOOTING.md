# TROUBLESHOOTING

Known issues and how to fix them.

## Alacritty: `TOML parse error … invalid basic string`

**Symptom**

```
[ERROR] Unable to import config "…/alacritty/shared.toml": Config error:
TOML parse error at line 31, column 49
   |
31 |   { key = "Return", mods = "Shift", chars  = "\r" },
   |                                              ^
invalid basic string, expected non-double-quote visible characters, `\`
```

**Cause**

A literal control byte (e.g. raw `0x1B` ESC) snuck into the TOML source,
usually from a copy-paste of escape-prefixed strings or from a tool that
serialized `` as the actual byte. Alacritty's TOML parser forbids
non-printable bytes inside basic strings.

**Fix**

Open `alacritty/shared.toml` and rewrite the offending line using
explicit escapes:

```toml
{ key = "Return", mods = "Shift", chars = "\r" },
```

Then verify with:

```sh
alacritty migrate --dry-run
```

It should print "Successfully migrated…" with no errors. The bytes after
fixing should look like `\ u 0 0 1 B \ r` — eight ASCII characters
between the quotes — not a raw `0x1B`.

## Alacritty: import file not found

**Symptom**

```
[WARN]  Unable to import config "~/.config/omarchy/current/theme/alacritty.toml":
File not found
```

**Cause**

Linux overlay imports the omarchy theme. If you're not running omarchy,
the file doesn't exist.

**Fix**

Either install omarchy, or edit `alacritty/linux.toml` and remove the
omarchy line from the import list. Pick a theme manually instead — see
[`CUSTOMIZATION.md`](CUSTOMIZATION.md#customizing-alacritty-colors-on-macos)
(same approach works on Linux).

## Ghostty: theme not found

**Symptom**

Terminal opens with default colors; ghostty log mentions "theme not found".

**Cause (Linux)**

`config.linux` includes `?"~/.config/omarchy/current/theme/ghostty.conf"`.
The `?` makes it optional, so this isn't a hard error — but if the file
doesn't exist Ghostty falls back to default colors.

**Fix**

Install omarchy, or replace the line with a hard-coded theme:

```
theme = "Tokyo Night Storm"
```

## bootstrap.sh: "skipping chsh (non-interactive)"

**Cause**

`bootstrap.sh` was run from a context without a TTY (CI, an editor task
runner, an LLM-driven shell). It can't prompt for the password chsh
needs.

**Fix**

Run `chsh` yourself afterwards:

```sh
chsh -s "$(command -v zsh)"
```

If `/etc/shells` doesn't list zsh:

```sh
sudo sh -c 'echo "$(command -v zsh)" >> /etc/shells'
chsh -s "$(command -v zsh)"
```

## bootstrap.sh: "missing source"

**Symptom**

```
skip  ~/.config/ghostty/config  (missing source: …/ghostty/config.linux)
```

**Cause**

The repo doesn't yet have the file `bootstrap.sh` is trying to link
from. Either you're on a `git pull`-pending branch, or someone added a
`link` line to bootstrap without committing the source file.

**Fix**

`git status` in the dotfiles repo. Either commit the missing file or
remove the stray `link` line.

## zsh: conf.d not loading

**Symptom**

`~/.zshrc` runs but functions/aliases are missing.

**Cause**

`.zshrc` discovers `conf.d/` via `${${:-$HOME/.zshrc}:A:h}/conf.d`. If
`~/.zshrc` is *not* a symlink to the dotfiles repo, the `:A` modifier
resolves to `~/` and conf.d won't be found.

**Fix**

```sh
ls -l ~/.zshrc       # should show "-> /…/dotfiles/zsh/.zshrc"
bash ~/GITHUB/dotfiles/bootstrap.sh
exec zsh -l
```

## tmux: copy-paste not reaching system clipboard

**Cause**

`set-clipboard on` uses OSC52 — the terminal must support it.

- Ghostty: supported by default.
- Alacritty: enabled in `shared.toml` via `[terminal] osc52 = "CopyPaste"`.
- Other terminals: check their OSC52 docs.

If you're SSH'd into a remote host, OSC52 will round-trip the clipboard
through the local terminal — no extra config on the remote needed.

## Git pager / delta not coloring

**Symptom**

`git diff` shows raw text instead of delta-styled output.

**Fix**

```sh
which delta            # ensure delta is installed
git config --global --get core.pager   # should be "delta"
```

If delta is installed but isn't being used, your `~/.gitconfig` may not
be the dotfiles symlink. Check:

```sh
ls -l ~/.gitconfig
```

## Ghostty `config.local` not applying

**Cause**

`config.shared` references `?config.local` as a relative path, resolved
against the directory of the *shared* file — i.e.,
`~/GITHUB/dotfiles/ghostty/`. Putting `config.local` in `~/.config/ghostty/`
won't work.

**Fix**

```sh
$EDITOR ~/GITHUB/dotfiles/ghostty/config.local
```

## "Already linked" but it's not

**Cause**

`bootstrap.sh` decides "already linked" via exact-string equality on the
symlink target. If you previously linked with a relative path, an `..`
form, or a different prefix, the script will see them as wrong and
re-link with an absolute path — that's fine.

If you intentionally used a relative or unusual link target, edit the
`link` invocation in `bootstrap.sh` to match.

## Restoring a backed-up file

`bootstrap.sh` saves displaced files to `<path>.backup-<UTC timestamp>`.
To restore:

```sh
ls -la ~/.config/starship.toml*    # find the backup
rm ~/.config/starship.toml         # remove the symlink
mv ~/.config/starship.toml.backup-20260428T135221Z ~/.config/starship.toml
```

Or, if you just want to compare:

```sh
diff ~/.config/starship.toml ~/.config/starship.toml.backup-20260428T135221Z
```
