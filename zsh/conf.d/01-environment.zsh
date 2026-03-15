# ══════════════════════════════════════════════════════════════════
# Environment Variables
# ══════════════════════════════════════════════════════════════════
#
# Sets up the core environment that every other module depends on:
#   - Locale (ensures consistent UTF-8 everywhere)
#   - EDITOR/VISUAL (used by git commit, Ctrl-X Ctrl-E, etc.)
#   - XDG base directories (standardizes where apps store config/cache/data)
#   - PAGER (bat with fallback to less — used by man, git, etc.)
#   - PATH (deduplicated, with Homebrew on macOS)
#
# This file is sourced FIRST because other modules reference these
# variables (e.g., completion uses XDG_CACHE_HOME, fzf uses bat).
# ══════════════════════════════════════════════════════════════════

# ── Locale ────────────────────────────────────────────────────────
# Force UTF-8 everywhere. Without this, tools may mishandle
# unicode filenames, emoji in git commits, or non-ASCII output.
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ── Editor ────────────────────────────────────────────────────────
# Prefer nvim > vim > vi. VISUAL is used by readline (Ctrl-X Ctrl-E),
# EDITOR is used by git, crontab, etc. Set both to the same value.
if   command -v nvim &>/dev/null; then export EDITOR=nvim VISUAL=nvim
elif command -v vim  &>/dev/null; then export EDITOR=vim  VISUAL=vim
else                                    export EDITOR=vi   VISUAL=vi
fi

# ── XDG base directories ─────────────────────────────────────────
# Many tools respect these (bat, starship, lazygit, etc.).
# Setting them explicitly ensures consistent paths across systems.
# See: https://specifications.freedesktop.org/basedir-spec
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ── Pager ─────────────────────────────────────────────────────────
# bat provides syntax highlighting and line numbers for paging.
# BAT_THEME is set to match the Tokyo Night color scheme used
# across fzf, delta, and the terminal.
if command -v bat &>/dev/null; then
  export PAGER="bat --paging=always"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="tokyonight_night"
else
  export PAGER="less -RFX"
  export MANPAGER="less -RFX"
fi

# ── PATH ──────────────────────────────────────────────────────────
# typeset -U ensures no duplicate entries in PATH, even after
# sourcing .zshrc multiple times (e.g., `reload` alias).
typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)

# macOS: Homebrew lives in /opt/homebrew on Apple Silicon
if [[ $_os == macos ]] && [[ -d /opt/homebrew ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi

# Antigravity (if installed)
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && path=("$HOME/.antigravity/antigravity/bin" $path)

export PATH
