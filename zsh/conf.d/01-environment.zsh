# ══════════════════════════════════════════════════════════════════
# Environment Variables
# ══════════════════════════════════════════════════════════════════

# ── OS detection ──────────────────────────────────────────────────
# _os is referenced throughout all modules — set it first.
case "$OSTYPE" in
  darwin*)  _os=macos ;;
  linux*)
    if [[ -n "$WSL_DISTRO_NAME" || -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
      _os=wsl
    else
      _os=linux
    fi
    ;;
  *)        _os=other ;;
esac
export _os

# ── Locale ────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
# LC_ALL overrides every locale category — only force it on macOS where
# en_US.UTF-8 is always present. On Linux/containers the locale may not
# be generated, causing noisy setlocale warnings on every shell start.
[[ $_os == macos ]] && export LC_ALL="en_US.UTF-8"

# ── Editor ────────────────────────────────────────────────────────
if   command -v nvim &>/dev/null; then export EDITOR=nvim VISUAL=nvim
elif command -v vim  &>/dev/null; then export EDITOR=vim  VISUAL=vim
else                                    export EDITOR=vi   VISUAL=vi
fi
export SUDO_EDITOR="$EDITOR"

# ── XDG base directories ─────────────────────────────────────────
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ── Pager ─────────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  export PAGER="bat --paging=always"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="tokyonight_night"
else
  export PAGER="less -RFX"
  export MANPAGER="less -RFX"
  export LESS="-FRX"
fi

# ── less colors (when bat is unavailable) ────────────────────────
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ── PATH ──────────────────────────────────────────────────────────
typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)

if [[ $_os == macos ]] && [[ -d /opt/homebrew ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  # Homebrew-installed man pages
  export MANPATH="/opt/homebrew/share/man:$MANPATH"
fi

export PATH
