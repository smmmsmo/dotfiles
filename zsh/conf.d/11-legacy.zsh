# ══════════════════════════════════════════════════════════════════
# Legacy Config — Restored from backup (21-MAR-2026)
# ══════════════════════════════════════════════════════════════════
#
# Features migrated from the old monolithic .zshrc that were not
# present in the new modular config. Includes:
#   - Tool shortcuts (opencode, claude, rails)
#   - nvim/open helpers
#   - Compression utilities
#   - Drive/ISO utilities
#   - SSH port forwarding
#   - Media transcoding (video/image)
#   - Git worktree helpers
#   - Tmux dev layouts
#   - FZF file picker
#   - Startup directory
# ══════════════════════════════════════════════════════════════════

# ── History Option ───────────────────────────────────────────────
setopt EXTENDED_HISTORY         # save timestamp and duration with each entry

# ── Legacy environment/hooks from old .zshrc ─────────────────────
export SUDO_EDITOR=nvim
export SUDO_ASKPASS="$HOME/.local/bin/sudo-askpass"
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Load omarchy/mise bin env
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# mise dev tool manager (node, python, java, etc.)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ── Tool Shortcuts ───────────────────────────────────────────────
alias c='opencode'
alias cx='printf "\033[2J\033[3J\033[H" && claude --allow-dangerously-skip-permissions'
alias r='rails'
alias d='docker'
alias gh='gh'

# Git aliases (old style)
alias gp='git push'
alias gpu='git pull'
alias gcad='git commit -a --amend'

# Tmux — attach to existing session or create new one named "Work"
alias tw='tmux attach || tmux new -s Work'

# FZF file picker with bat preview
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# ── nvim — open current dir if no args given ─────────────────────
n() {
  if [ "$#" -eq 0 ]; then
    command nvim .
  else
    command nvim "$@"
  fi
}

# ── open — xdg-open silently in background ───────────────────────
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# ── eff — edit file selected via fzf ─────────────────────────────
eff() {
  local file
  file="$(ff)"
  [[ -n "$file" ]] && "$EDITOR" "$file"
}

# ══════════════════════════════════════════════════════════════════
# Compression Utilities
# ══════════════════════════════════════════════════════════════════

# compress — create a .tar.gz archive from a file or directory
# Usage: compress my-folder
compress() {
  tar -czf "${1%/}.tar.gz" "${1%/}"
}

alias decompress="tar -xzf"

# ══════════════════════════════════════════════════════════════════
# Drive & ISO Utilities
# ══════════════════════════════════════════════════════════════════

# iso2sd — write an ISO image to an SD card / USB drive
# Usage: iso2sd ~/Downloads/ubuntu.iso /dev/sda
# Usage: iso2sd ~/Downloads/ubuntu.iso  (interactive drive selection)
iso2sd() {
  if (( $# < 1 )); then
    echo 'Usage: iso2sd <input_file> [output_device]'
    echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
    return 1
  fi
  local iso="$1" drive="$2"
  if [[ -z $drive ]]; then
    local available_sds=$(lsblk -dpno NAME | grep -E '/dev/sd')
    [[ -z $available_sds ]] && { echo "No SD drives found"; return 1; }
    drive=$(omarchy-drive-select "$available_sds")
    [[ -z $drive ]] && { echo "No drive selected"; return 1; }
  fi
  sudo dd bs=4M status=progress oflag=sync if="$iso" of="$drive"
  sudo eject "$drive"
}

# format-drive — wipe and format an entire drive as exFAT
# Usage: format-drive /dev/sda "My Stuff"
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

# ══════════════════════════════════════════════════════════════════
# SSH Port Forwarding Helpers
# ══════════════════════════════════════════════════════════════════

# fip — forward ports from a remote host to localhost
# Usage: fip myserver 3000 5432 8080
fip() {
  (( $# < 2 )) && { echo 'Usage: fip <host> <port1> [port2] ...'; return 1; }
  local host="$1"; shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

# dip — disconnect/stop port forwarding
# Usage: dip 3000 5432
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

# ══════════════════════════════════════════════════════════════════
# Video Transcoding (requires ffmpeg)
# ══════════════════════════════════════════════════════════════════

# transcode-video-1080p — downscale video to 1080p using H.264
# Usage: transcode-video-1080p input.mp4
transcode-video-1080p() {
  ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"
}

# transcode-video-4K — optimize 4K video using H.265
# Usage: transcode-video-4K input.mp4
transcode-video-4K() {
  ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}-optimized.mp4"
}

# ══════════════════════════════════════════════════════════════════
# Image Conversion (requires imagemagick)
# ══════════════════════════════════════════════════════════════════

# img2jpg — convert image to high-quality JPG
# Usage: img2jpg photo.png
# Usage: img2jpg photo.png -rotate 90  (extra magick flags)
img2jpg() {
  local img="$1"; shift
  magick "$img" "$@" -quality 95 -strip "${img%.*}-converted.jpg"
}

# img2jpg-small — convert and resize to max 1080px width
img2jpg-small() {
  local img="$1"; shift
  magick "$img" "$@" -resize 1080x\> -quality 95 -strip "${img%.*}-small.jpg"
}

# img2jpg-medium — convert and resize to max 1800px width
img2jpg-medium() {
  local img="$1"; shift
  magick "$img" "$@" -resize 1800x\> -quality 95 -strip "${img%.*}-medium.jpg"
}

# img2png — optimize PNG with maximum compression
img2png() {
  local img="$1"; shift
  magick "$img" "$@" -strip \
    -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "${img%.*}-optimized.png"
}

# ══════════════════════════════════════════════════════════════════
# Git Worktree Helpers
# ══════════════════════════════════════════════════════════════════

# gwa — create a new worktree + branch from current repo
# Creates worktree in parent dir with naming: reponame--branchname
# Usage: gwa feature-login
# Note: renamed from ga() to avoid conflict with ga='git add' alias
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
# Must be run from within a worktree (not the main repo)
# Note: renamed from gd() to avoid potential conflicts
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

# ══════════════════════════════════════════════════════════════════
# Tmux Dev Layouts
# ══════════════════════════════════════════════════════════════════

# tdl — Tmux Dev Layout: opens nvim on the left, AI on the right
# Creates a layout with:
#   - Left: editor (nvim)
#   - Bottom-left: small terminal
#   - Right: AI tool (opencode, claude, etc.)
#   - Optional: second AI tool stacked below
#
# Usage: tdl c            (opencode on right)
# Usage: tdl c cx         (two AI panes stacked on right)
tdl() {
  [[ -z $1 ]] && { echo 'Usage: tdl <c|cx|codex|other_ai> [<second_ai>]'; return 1; }
  [[ -z $TMUX ]] && { echo "You must be inside tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1" ai2="$2"

  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Bottom terminal pane (15% height)
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  # Right AI pane (30% width)
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Optional second AI pane (stacked below first)
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

# tdlm — Tmux multi-project layout: one tdl window per subdirectory
# Opens each subdirectory in its own tmux window with tdl layout
# Usage: tdlm c
# Usage: tdlm c cx
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
      local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# tsl — Tmux Swarm Layout: same command started in N panes side by side
# Useful for running the same AI/tool in multiple panes
# Usage: tsl 4 opencode
tsl() {
  [[ -z $1 || -z $2 ]] && { echo 'Usage: tsl <pane_count> <command>'; return 1; }
  [[ -z $TMUX ]] && { echo "You must be inside tmux to use tsl."; return 1; }

  local count="$1" cmd="$2"
  local current_dir="${PWD}"
  local -a panes

  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  panes+=("$TMUX_PANE")

  while (( ${#panes[@]} < count )); do
    local new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done

  tmux select-pane -t "${panes[0]}"
}

# ══════════════════════════════════════════════════════════════════
# Startup Directory
# ══════════════════════════════════════════════════════════════════

# Always open new shells in ~/GITHUB
cd ~/GITHUB 2>/dev/null || true
