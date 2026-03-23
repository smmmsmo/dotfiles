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

# n — open Neovim in the current directory when called without args
n() {
  if [[ $# -eq 0 ]]; then
    command nvim .
  else
    command nvim "$@"
  fi
}

# mkcd — mkdir and cd in one step
# Usage: mkcd my-new-project
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# compress — create a .tar.gz archive from a file or directory
# Usage: compress my-folder
compress() {
  tar -czf "${1%/}.tar.gz" "${1%/}"
}

# Convenience alias for extracting tar.gz archives.
alias decompress="tar -xzf"

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

# eff — pick a file with fzf, then open it in $EDITOR
eff() {
  local file
  file="$(ff)"
  [[ -n "$file" ]] && "$EDITOR" "$file"
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

# iso2sd — write an ISO image to an SD card / USB drive
iso2sd() {
  if (( $# < 1 )); then
    echo 'Usage: iso2sd <input_file> [output_device]'
    echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
    return 1
  fi
  local iso="$1" drive="$2"
  if [[ -z $drive ]]; then
    local available_sds
    available_sds=$(lsblk -dpno NAME | grep -E '/dev/sd')
    [[ -z $available_sds ]] && { echo "No SD drives found"; return 1; }
    drive=$(omarchy-drive-select "$available_sds")
    [[ -z $drive ]] && { echo "No drive selected"; return 1; }
  fi
  sudo dd bs=4M status=progress oflag=sync if="$iso" of="$drive"
  sudo eject "$drive"
}

# format-drive — wipe and format an entire drive as exFAT
format-drive() {
  if (( $# != 2 )); then
    echo 'Usage: format-drive <device> <name>'
    echo "Example: format-drive /dev/sda 'My Stuff'"
    return 1
  fi
  echo "WARNING: This will completely erase all data on $1 and label it '$2'."
  read -rq "confirm?Are you sure? (y/N): "
  echo
  [[ $confirm =~ ^[Yy]$ ]] || return 1
  sudo wipefs -a "$1"
  sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
  sudo parted -s "$1" mklabel gpt
  sudo parted -s "$1" mkpart primary 1MiB 100%
  sudo parted -s "$1" set 1 msftdata on
  local partition="$([[ $1 == *nvme* ]] && echo "${1}p1" || echo "${1}1")"
  sudo partprobe "$1" || true
  sudo udevadm settle || true
  sudo mkfs.exfat -n "$2" "$partition"
  echo "Drive $1 formatted as exFAT and labeled '$2'."
}

# fip — forward ports from a remote host to localhost
fip() {
  (( $# < 2 )) && { echo 'Usage: fip <host> <port1> [port2] ...'; return 1; }
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

# dip — disconnect/stop port forwarding
dip() {
  (( $# == 0 )) && { echo 'Usage: dip <port1> [port2] ...'; return 1; }
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

# lip — list active port forwards
lip() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# transcode-video-1080p — downscale video to 1080p using H.264
transcode-video-1080p() {
  ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"
}

# transcode-video-4K — optimize 4K video using H.265
transcode-video-4K() {
  ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}-optimized.mp4"
}

# img2jpg — convert image to high-quality JPG
img2jpg() {
  local img="$1"
  shift
  magick "$img" "$@" -quality 95 -strip "${img%.*}-converted.jpg"
}

# img2jpg-small — convert and resize to max 1080px width
img2jpg-small() {
  local img="$1"
  shift
  magick "$img" "$@" -resize 1080x\> -quality 95 -strip "${img%.*}-small.jpg"
}

# img2jpg-medium — convert and resize to max 1800px width
img2jpg-medium() {
  local img="$1"
  shift
  magick "$img" "$@" -resize 1800x\> -quality 95 -strip "${img%.*}-medium.jpg"
}

# img2png — optimize PNG with maximum compression
img2png() {
  local img="$1"
  shift
  magick "$img" "$@" -strip \
    -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "${img%.*}-optimized.png"
}

# gwa — create a new worktree + branch from current repo
gwa() {
  [[ -z "$1" ]] && { echo 'Usage: gwa <branch-name>'; return 1; }
  local branch="$1"
  local base="$(basename "$PWD")"
  local path="../${base}--${branch}"
  git worktree add -b "$branch" "$path"
  command -v mise &>/dev/null && mise trust "$path"
  cd "$path"
}

# gwd — remove the current worktree and its branch
gwd() {
  if ! command -v gum &>/dev/null; then
    echo "gd requires 'gum' for confirmation. Install: brew install gum"
    return 1
  fi
  if gum confirm "Remove worktree and branch?"; then
    local cwd="$(pwd)" worktree root branch
    worktree="$(basename "$cwd")"
    root="${worktree%%--*}"
    branch="${worktree#*--}"
    if [[ "$root" != "$worktree" ]]; then
      cd "../$root"
      git worktree remove "$cwd" --force || return 1
      git branch -D "$branch"
    else
      echo "Not in a worktree (no '--' in directory name)"
    fi
  fi
}

# tdl — Tmux Dev Layout: opens nvim on the left, AI on the right
tdl() {
  [[ -z $1 ]] && { echo 'Usage: tdl <c|cx|codex|other_ai> [<second_ai>]'; return 1; }
  [[ -z $TMUX ]] && { echo "You must be inside tmux to use tdl."; return 1; }

  local current_dir="$PWD"
  local editor_pane ai_pane ai2_pane
  local ai="$1" ai2="$2"

  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

# tdlm — Tmux multi-project layout: one tdl window per subdirectory
tdlm() {
  [[ -z $1 ]] && { echo 'Usage: tdlm <ai_command> [<second_ai>]'; return 1; }
  [[ -z $TMUX ]] && { echo "You must be inside tmux to use tdlm."; return 1; }

  local ai="$1" ai2="$2"
  local base_dir="$PWD"
  local first=true

  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# tsl — Tmux Swarm Layout: same command started in N panes side by side
tsl() {
  [[ -z $1 || -z $2 ]] && { echo 'Usage: tsl <pane_count> <command>'; return 1; }
  [[ -z $TMUX ]] && { echo "You must be inside tmux to use tsl."; return 1; }

  local count="$1" cmd="$2"
  local current_dir="$PWD"
  local -a panes

  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  panes+=("$TMUX_PANE")

  while (( ${#panes[@]} < count )); do
    local new_pane
    new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done

  tmux select-pane -t "${panes[0]}"
}

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
