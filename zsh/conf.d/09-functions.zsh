# ══════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════
#
# Shell functions for tasks that are too complex for aliases.
# Unlike aliases, functions can:
#   - Accept arguments ($1, $2, etc.)
#   - Contain control flow (if/for/case)
#   - Use local variables
#   - Combine multiple commands with logic
#
# Functions are organized into categories:
#   1. File & directory utilities
#   2. FZF-powered interactive tools
#   3. Git helpers
#   4. Development tools
#   5. macOS-specific
#
# Usage examples are shown in comments above each function.
# ══════════════════════════════════════════════════════════════════

# ── File & directory utilities ───────────────────────────────────

# mkcd — mkdir and cd in one step
# Usage: mkcd my-new-project
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# extract — universal archive extractor
# Handles every common archive format. No need to remember which
# flag goes with which tool.
# Usage: extract archive.tar.gz
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <file>"
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a valid file"
    return 1
  fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"   ;;
    *.tar.gz)   tar xzf "$1"   ;;
    *.tar.xz)   tar xJf "$1"   ;;
    *.tar.zst)  tar --zstd -xf "$1" ;;
    *.bz2)      bunzip2 "$1"   ;;
    *.rar)      unrar x "$1"   ;;
    *.gz)       gunzip "$1"    ;;
    *.tar)      tar xf "$1"    ;;
    *.tbz2)     tar xjf "$1"   ;;
    *.tgz)      tar xzf "$1"   ;;
    *.zip)      unzip "$1"     ;;
    *.Z)        uncompress "$1";;
    *.7z)       7z x "$1"      ;;
    *.deb)      ar x "$1"      ;;
    *.xz)       unxz "$1"      ;;
    *.zst)      unzstd "$1"    ;;
    *) echo "extract: '$1' — unknown archive format" && return 1 ;;
  esac
}

# up — go up N directories
# Usage: up 3  (equivalent to cd ../../..)
up() {
  local n="${1:-1}"
  local d=""
  for ((i=0; i<n; i++)); do d="../$d"; done
  cd "$d" || return
}

# sizeof — human-readable size of a file or directory
# Usage: sizeof node_modules
sizeof() { du -sh "${1:-.}" | cut -f1 }

# tre — tree view using eza (with configurable depth)
# Usage: tre 3 src/  (show 3 levels deep in src/)
tre() { eza --icons --tree --level="${1:-2}" "${@:2}" }

# port — show what's listening on a given port
# Usage: port 3000
port() { lsof -i ":${1}" }

# ── FZF-powered interactive tools ───────────────────────────────
# These functions combine fzf with other tools for interactive
# selection. They all require fzf to be installed.

# fcd — fzf-powered cd into any subdirectory
# Uses fd to find directories and eza/ls for preview.
# Usage: fcd
fcd() {
  local dir preview
  if command -v eza &>/dev/null; then
    preview='eza --icons --tree --level=1 --color=always {}'
  else
    preview='ls -la {}'
  fi
  dir=$(fd --type d --hidden --exclude .git 2>/dev/null \
        | fzf --preview "$preview" --prompt '> ') && cd "$dir"
}

# fkill — interactively kill a process via fzf
# Shows all processes, lets you pick one, kills it.
# Usage: fkill        (default: SIGKILL)
# Usage: fkill 15     (send SIGTERM instead)
fkill() {
  local pid
  pid=$(ps aux | fzf --header='Select process to kill' --prompt='> ' \
        | awk '{print $2}')
  [[ -n "$pid" ]] && kill -${1:-9} "$pid" && echo "Killed PID $pid"
}

# fhist — fuzzy search and re-run a command from history
# Selected command is placed in the input buffer (not executed
# immediately) so you can edit it before pressing Enter.
# Usage: fhist
fhist() {
  local cmd
  cmd=$(fc -l 1 | fzf --tac --prompt='> ' --preview='echo {}' \
        | sed 's/ *[0-9]* *//')
  [[ -n "$cmd" ]] && print -z "$cmd"
}

# fenv — fuzzy search environment variables
# Usage: fenv
fenv() {
  env | sort | fzf --prompt='> ' --preview='echo {}'
}

# ── Git helpers ──────────────────────────────────────────────────

# gbr — fzf-powered git branch switcher
# Shows all branches (local + remote) with log preview.
# Selecting a remote branch automatically strips the origin/ prefix.
# Usage: gbr
gbr() {
  local branch
  branch=$(git branch -a --color=always \
           | grep -v '\->' \
           | fzf --ansi --preview 'git log --oneline --color=always {}' \
                 --prompt='branch: ' \
           | sed 's/remotes\/origin\///' | tr -d ' *')
  [[ -n "$branch" ]] && git switch "$branch"
}

# gshow — fzf git log browser with diff preview
# Browse commits with a preview of the diff. Press Enter to view
# the full commit in less.
# Usage: gshow
# Usage: gshow --author=you  (pass extra git log flags)
gshow() {
  git log --oneline --color=always "$@" \
  | fzf --ansi --no-sort --reverse \
        --preview 'git show --color=always {1}' \
        --bind 'enter:execute(git show --color=always {1} | less -R)' \
        --prompt='commit: '
}

# groot — cd to the root of the current git repository
# Works from any nested subdirectory inside a repo.
# Usage: groot
groot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo"; return 1; }
  cd "$root"
}

# ── Development tools ───────────────────────────────────────────

# serve — start a quick HTTP server in the current directory
# Useful for testing static sites, sharing files on the network, etc.
# Usage: serve        (default: port 8000)
# Usage: serve 3000   (custom port)
serve() { python3 -m http.server "${1:-8000}" }

# json — pretty-print JSON using jq
# Accepts input from pipe, file path, or string argument.
# Requires: brew install jq
# Usage: echo '{"a":1}' | json
# Usage: json package.json
# Usage: json '{"a":1}'
json() {
  if [[ -p /dev/stdin ]]; then
    jq '.' < /dev/stdin
  elif [[ -n "$1" && -f "$1" ]]; then
    jq '.' "$1"
  elif [[ -n "$1" ]]; then
    jq '.' <<< "$1"
  else
    echo "Usage: json <file>, json '<string>', or pipe | json"
    return 1
  fi
}

# cheat — quick command cheat sheet from cheat.sh
# Usage: cheat tar
# Usage: cheat python/list
cheat() { curl -s "cheat.sh/$1" | ${PAGER:-less} }

# ── macOS-specific ───────────────────────────────────────────────

# hidden — toggle hidden files in Finder
if [[ $_os == macos ]]; then
  hidden() {
    local state
    state=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
    if [[ "$state" == "YES" || "$state" == "true" || "$state" == "1" ]]; then
      defaults write com.apple.finder AppleShowAllFiles NO
      echo "Hidden files: OFF"
    else
      defaults write com.apple.finder AppleShowAllFiles YES
      echo "Hidden files: ON"
    fi
    killall Finder
  }
fi
