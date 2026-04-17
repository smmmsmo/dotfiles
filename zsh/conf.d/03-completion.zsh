# ══════════════════════════════════════════════════════════════════
# Completion System
# ══════════════════════════════════════════════════════════════════
#
# Order: fpath setup → compinit → zstyle rules
# fpath MUST be complete before compinit runs.

# ── fpath: system and Homebrew completion paths ──────────────────
if [[ $_os == macos ]] && [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
elif [[ $_os == linux ]] && [[ -d /usr/share/zsh/site-functions ]]; then
  fpath=(/usr/share/zsh/site-functions $fpath)
fi

# zsh-completions: ~300 extra completions (cargo, fd, rg, etc.)
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

# ── compinit: cached initialization ──────────────────────────────
# Rebuild the zcompdump at most once every 24 hours.
autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

if [[ -n "$ZSH_CACHE_DIR/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_CACHE_DIR/zcompdump"
else
  compinit -C -d "$ZSH_CACHE_DIR/zcompdump"
fi

# Compile zcompdump for faster future loads
[[ "$ZSH_CACHE_DIR/zcompdump.zwc" -nt "$ZSH_CACHE_DIR/zcompdump" ]] \
  || zcompile "$ZSH_CACHE_DIR/zcompdump" &!

# ── zstyle: behavior and appearance ──────────────────────────────

# Interactive menu with arrow-key navigation
zstyle ':completion:*' menu select

# Fuzzy matching in three increasing levels:
#   1. case-insensitive   → Git matches git, GIT
#   2. partial-word       → f.b matches foo.bar (split on . _ -)
#   3. substring          → bar matches foobar
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Group results by type (files, commands, options…)
zstyle ':completion:*' group-name ''
zstyle ':completion:*' sort false

# Section headers
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings'     format '%F{red}No matches: %d%f'
zstyle ':completion:*:corrections'  format '%F{green}%d (errors: %e)%f'
zstyle ':completion:*:messages'     format '%F{purple}%d%f'

# Show extra info alongside completions (branch names, descriptions)
zstyle ':completion:*' verbose yes

# Colorize file completions via LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Cache for expensive lookups (pip, apt, etc.)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# PID colors in kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Complete after sudo
zstyle ':completion::complete:*' gain-privileges 1

# // → / (no spurious root completion on double slash)
zstyle ':completion:*' squeeze-slashes true

# Don't complete uninteresting users (system accounts)
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
  clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
  gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust \
  ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
  named netdump news nfsnobody nobody 'ntp|ntpd' operator pcap \
  postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm \
  rsync shutdown squid sshd sync uucp vcsa xfs '_*'

# Ignore .pyc, .o, ~ files in normal file completion
zstyle ':completion:*:*:*:*:files' ignored-patterns '*?.pyc' '*?.o' '*~'

# cd uses only directories
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Show dots when computing completions (feels snappier)
zstyle ':completion:*' show-completer true
