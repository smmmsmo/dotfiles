# ══════════════════════════════════════════════════════════════════
# Functions
# ══════════════════════════════════════════════════════════════════

# ── File & directory utilities ───────────────────────────────────

# n — nvim in current dir when no args given
n() { command nvim "${@:-.}" }

# mkcd — mkdir + cd in one step
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# compress / decompress
compress()   { tar -czf "${1%/}.tar.gz" "${1%/}" }
alias decompress='tar -xzf'

# extract — universal archive extractor
extract() {
  if [[ -z "$1" ]]; then echo "Usage: extract <file>"; return 1; fi
  if [[ ! -f "$1" ]]; then echo "extract: '$1' is not a valid file"; return 1; fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"          ;;
    *.tar.gz)   tar xzf "$1"          ;;
    *.tar.xz)   tar xJf "$1"          ;;
    *.tar.zst)  tar --zstd -xf "$1"   ;;
    *.bz2)      bunzip2 "$1"          ;;
    *.rar)      unrar x "$1"          ;;
    *.gz)       gunzip "$1"           ;;
    *.tar)      tar xf "$1"           ;;
    *.tbz2)     tar xjf "$1"          ;;
    *.tgz)      tar xzf "$1"          ;;
    *.zip)      unzip "$1"            ;;
    *.Z)        uncompress "$1"       ;;
    *.7z)       7z x "$1"             ;;
    *.deb)      ar x "$1"             ;;
    *.xz)       unxz "$1"             ;;
    *.zst)      unzstd "$1"           ;;
    *) echo "extract: '$1' — unknown format"; return 1 ;;
  esac
}

# up — go up N directories (default 1)
up() {
  local n="${1:-1}" d=""
  for ((i=0; i<n; i++)); do d="../$d"; done
  cd "$d" || return
}

# sizeof — human-readable size of a file or directory
sizeof() { du -sh "${1:-.}" | cut -f1 }

# tre — tree view using eza
tre() { eza --icons --tree --level="${1:-2}" "${@:2}" }

# port — show what's listening on a given port
port() { lsof -i ":${1}" }

# mcd — create and cd, then print absolute path
mcd() { mkcd "$1" && pwd }

# ── FZF tools ────────────────────────────────────────────────────
# All require fzf.

# fcd — fuzzy cd into any subdirectory
fcd() {
  local dir preview
  if command -v eza &>/dev/null; then
    preview='eza --icons --tree --level=1 --color=always {}'
  else
    preview='ls -la {}'
  fi
  dir=$(fd --type d --hidden --exclude .git 2>/dev/null \
        | fzf --preview "$preview" --prompt '❯ ') && cd "$dir"
}

# fkill — fuzzy kill a process
fkill() {
  local pid
  pid=$(ps aux | fzf --header='Select process to kill' --prompt='❯ ' | awk '{print $2}')
  [[ -n "$pid" ]] && kill -"${1:-9}" "$pid" && echo "Killed PID $pid"
}

# fhist — fuzzy re-run from history (puts command in buffer, not exec)
fhist() {
  local cmd
  cmd=$(fc -l 1 | fzf --tac --prompt='❯ ' --preview='echo {}' | sed 's/ *[0-9]* *//')
  [[ -n "$cmd" ]] && print -z "$cmd"
}

# fenv — fuzzy search environment variables
fenv() { env | sort | fzf --prompt='❯ ' --preview='echo {}' }

# eff — fzf pick a file, open in $EDITOR
eff() {
  local file
  file="$(ff)"
  [[ -n "$file" ]] && "$EDITOR" "$file"
}

# fman — fuzzy man page search
fman() {
  man -k . 2>/dev/null \
    | fzf --prompt='man ❯ ' \
          --preview 'echo {} | awk "{print \$1}" | xargs man 2>/dev/null | head -80' \
    | awk '{print $1}' \
    | xargs man
}

# ── Git helpers ──────────────────────────────────────────────────

# gbr — fuzzy branch switch
gbr() {
  local branch
  branch=$(git branch -a --color=always \
           | grep -v '\->' \
           | fzf --ansi --preview 'git log --oneline --color=always {}' --prompt='branch ❯ ' \
           | sed 's/remotes\/origin\///' | tr -d ' *')
  [[ -n "$branch" ]] && git switch "$branch"
}

# gshow — fuzzy git log browser with diff preview
gshow() {
  git log --oneline --color=always "$@" \
  | fzf --ansi --no-sort --reverse \
        --preview 'git show --color=always {1}' \
        --bind 'enter:execute(git show --color=always {1} | less -R)' \
        --prompt='commit ❯ '
}

# groot — cd to repo root
groot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) \
    || { echo "Not in a git repo"; return 1; }
  cd "$root"
}

# gignore — add pattern to .gitignore, create file if needed
gignore() {
  [[ -z "$1" ]] && { echo 'Usage: gignore <pattern>'; return 1; }
  echo "$1" >> .gitignore && echo "Added '$1' to .gitignore"
}

# ── Development ──────────────────────────────────────────────────

# serve — quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8000}" }

# json — pretty-print JSON (pipe, file, or string)
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

# cheat — quick cheat sheet from cheat.sh
cheat() { curl -s "cheat.sh/$1" | ${PAGER:-less} }

# dotenv — load a .env file into the current shell
dotenv() {
  local file="${1:-.env}"
  [[ ! -f "$file" ]] && { echo "dotenv: '$file' not found"; return 1; }
  set -o allexport
  source "$file"
  set +o allexport
  echo "Loaded $file"
}

# httpstat — curl with timing breakdown
httpstat() {
  curl -o /dev/null -s -w \
    "   dns: %{time_namelookup}s\n  conn: %{time_connect}s\n   tls: %{time_appconnect}s\n  send: %{time_pretransfer}s\n  wait: %{time_starttransfer}s\n total: %{time_total}s\n  size: %{size_download} bytes\nstatus: %{http_code}\n" \
    "$@"
}

# ── Port forwarding ──────────────────────────────────────────────

# fip — forward remote ports to localhost
fip() {
  (( $# < 2 )) && { echo 'Usage: fip <host> <port1> [port2] ...'; return 1; }
  local host="$1"; shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" \
      && echo "Forwarding localhost:$port → $host:$port"
  done
}

# dip — stop forwarding for a port
dip() {
  (( $# == 0 )) && { echo 'Usage: dip <port1> [port2] ...'; return 1; }
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" \
      && echo "Stopped forwarding port $port" \
      || echo "No forwarding on port $port"
  done
}

# lip — list active port forwards
lip() { pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards" }

# ── Linux: ISO / drive utilities ────────────────────────────────
if [[ $_os == linux ]] \
  && command -v lsblk &>/dev/null \
  && command -v omarchy-drive-select &>/dev/null \
  && command -v wipefs &>/dev/null \
  && command -v parted &>/dev/null \
  && command -v partprobe &>/dev/null \
  && command -v udevadm &>/dev/null \
  && command -v mkfs.exfat &>/dev/null
then
  iso2sd() {
    if (( $# < 1 )); then
      echo 'Usage: iso2sd <input_file> [output_device]'; return 1
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

  format-drive() {
    if (( $# != 2 )); then
      echo 'Usage: format-drive <device> <name>'; return 1
    fi
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    read -rq "confirm?Are you sure? (y/N): "; echo
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
fi

# ── Media (ffmpeg / imagemagick) ─────────────────────────────────
if command -v ffmpeg &>/dev/null; then
  transcode-video-1080p() {
    ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"
  }
  transcode-video-4K() {
    ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}-optimized.mp4"
  }
  # gif2mp4 — convert an animated GIF to a small mp4
  gif2mp4() {
    ffmpeg -i "$1" -vf "fps=15,scale=trunc(iw/2)*2:trunc(ih/2)*2" \
      -c:v libx264 -pix_fmt yuv420p -movflags faststart "${1%.*}.mp4"
  }
fi

if command -v magick &>/dev/null; then
  img2jpg()        { local img="$1"; shift; magick "$img" "$@" -quality 95 -strip "${img%.*}-converted.jpg"; }
  img2jpg-small()  { local img="$1"; shift; magick "$img" "$@" -resize 1080x\> -quality 95 -strip "${img%.*}-small.jpg"; }
  img2jpg-medium() { local img="$1"; shift; magick "$img" "$@" -resize 1800x\> -quality 95 -strip "${img%.*}-medium.jpg"; }
  img2png()        {
    local img="$1"; shift
    magick "$img" "$@" -strip \
      -define png:compression-filter=5 \
      -define png:compression-level=9 \
      -define png:compression-strategy=1 \
      -define png:exclude-chunk=all \
      "${img%.*}-optimized.png"
  }
fi

# ── Git worktrees ────────────────────────────────────────────────

# gwa — create a new worktree + branch
gwa() {
  [[ -z "$1" ]] && { echo 'Usage: gwa <branch-name>'; return 1; }
  local branch="$1"
  local path="../$(basename "$PWD")--${branch}"
  git worktree add -b "$branch" "$path"
  command -v mise &>/dev/null && mise trust "$path"
  cd "$path"
}

# gwd — remove the current worktree and its branch
gwd() {
  if ! command -v gum &>/dev/null; then
    echo "gwd requires 'gum'. Install: brew install gum"; return 1
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

# gwl — list worktrees with status
gwl() { git worktree list }

# ── Tmux layouts ─────────────────────────────────────────────────

# tdl — Tmux Dev Layout: editor left, AI right
tdl() {
  [[ -z $1 ]] && { echo 'Usage: tdl <ai_command> [<second_ai>]'; return 1; }
  [[ -z $TMUX ]] && { echo "Must be inside tmux."; return 1; }
  local current_dir="$PWD" ai="$1" ai2="$2"
  local editor_pane="$TMUX_PANE" ai_pane ai2_pane
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

# tdlm — one tdl window per subdirectory
tdlm() {
  [[ -z $1 ]] && { echo 'Usage: tdlm <ai_command> [<second_ai>]'; return 1; }
  [[ -z $TMUX ]] && { echo "Must be inside tmux."; return 1; }
  local ai="$1" ai2="$2" base_dir="$PWD" first=true
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

# tsl — Tmux Swarm Layout: same command in N panes side by side
tsl() {
  [[ -z $1 || -z $2 ]] && { echo 'Usage: tsl <pane_count> <command>'; return 1; }
  [[ -z $TMUX ]] && { echo "Must be inside tmux."; return 1; }
  local count="$1" cmd="$2" current_dir="$PWD"
  local -a panes
  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  panes+=("$TMUX_PANE")
  while (( ${#panes[@]} < count )); do
    local new_pane
    new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done
  for pane in "${panes[@]}"; do tmux send-keys -t "$pane" "$cmd" C-m; done
  tmux select-pane -t "${panes[0]}"
}

# ── macOS ─────────────────────────────────────────────────────────
if [[ $_os == macos ]]; then
  # hidden — toggle hidden files in Finder
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

  # ql — Quick Look a file from the terminal
  ql() { qlmanage -p "$@" &>/dev/null & }

  # notify — send a macOS notification
  # Usage: notify "Build complete"
  notify() { osascript -e "display notification \"$*\" with title \"Terminal\"" }
fi
