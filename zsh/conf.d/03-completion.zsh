# ══════════════════════════════════════════════════════════════════
# Completion System
# ══════════════════════════════════════════════════════════════════
#
# Zsh's completion system (compsys) is one of its most powerful
# features. It provides context-aware completions for commands,
# arguments, file paths, and more.
#
# How it works:
#   1. fpath  — directories where completion functions (_git, _docker, etc.) live
#   2. compinit — loads and initializes the completion system
#   3. zstyle — configures how completions look and behave
#
# The fpath and zsh-completions plugin MUST be set up BEFORE
# compinit runs, otherwise those completions won't be registered.
#
# Docs: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# ══════════════════════════════════════════════════════════════════

# ── fpath: completion function search paths ──────────────────────
# Platform-specific paths where Homebrew/system packages install
# their completion files (e.g., _docker, _git, _brew).
if [[ $_os == macos ]] && [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
elif [[ $_os == linux ]] && [[ -d /usr/share/zsh/site-functions ]]; then
  fpath=(/usr/share/zsh/site-functions $fpath)
fi

# zsh-completions plugin — adds completions for ~300 extra commands
# (docker subcommands, cargo, rustup, fd, rg, and many more).
# Install: brew install zsh-completions
for _zc_dir in \
  /opt/homebrew/share/zsh-completions \
  /usr/share/zsh/plugins/zsh-completions/src \
  /usr/share/zsh-completions; do
  if [[ -d "$_zc_dir" ]]; then
    fpath=("$_zc_dir" $fpath)
    break
  fi
done
unset _zc_dir

# ── compinit: initialize the completion system ───────────────────
# compinit scans all fpath dirs and registers completion functions.
# This is slow (~100ms), so we cache the result in a zcompdump file
# and only rebuild it once every 24 hours.
#
# The (#qN.mh+24) glob qualifier checks if zcompdump is older than
# 24 hours. If it is, we do a full rebuild. Otherwise, we use -C
# to skip the security check and load the cached dump instantly.
autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

if [[ -n "$ZSH_CACHE_DIR/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_CACHE_DIR/zcompdump"
else
  compinit -C -d "$ZSH_CACHE_DIR/zcompdump"
fi

# ── zstyle: completion display and behavior rules ────────────────
# These rules control how the completion menu looks and how
# matching works. They're applied in order of specificity.

# Interactive menu: use arrow keys to navigate completions
zstyle ':completion:*' menu select

# Fuzzy matching (3 levels, tried in order):
#   1. Case-insensitive:  'git' matches 'Git', 'GIT'
#   2. Partial-word:      'f.b' matches 'foo.bar' (split on . _ -)
#   3. Substring:         'bar' matches 'foobar'
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group completions by type (files, commands, options, etc.)
zstyle ':completion:*' group-name ''

# Format strings for different completion states
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings'     format '%F{red}No matches: %d%f'
zstyle ':completion:*:corrections'  format '%F{green}%d (errors: %e)%f'

# Show descriptions alongside completions (e.g., git checkout shows branch info)
zstyle ':completion:*' verbose yes

# Colorize file completions using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Cache completions for expensive lookups (e.g., apt, pip)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Color PIDs in kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Allow completions to work through sudo
zstyle ':completion::complete:*' gain-privileges 1

# Treat // as / (don't complete from root on double slash)
zstyle ':completion:*' squeeze-slashes true
