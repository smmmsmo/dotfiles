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
# setopt EXTENDED_HISTORY         # moved to main options/history setup

# ── Legacy environment/hooks from old .zshrc ─────────────────────
# export SUDO_EDITOR=nvim                        # moved to 01-environment.zsh
# export SUDO_ASKPASS="$HOME/.local/bin/sudo-askpass"
# export OMARCHY_PATH="$HOME/.local/share/omarchy"
# export PATH="$OMARCHY_PATH/bin:$PATH"

# Load omarchy/mise bin env
# [[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"  # moved to 01-environment.zsh

# mise dev tool manager (node, python, java, etc.)
# if command -v mise &>/dev/null; then          # moved to 10-tools.zsh
#   eval "$(mise activate zsh)"
# fi

# ── Tool Shortcuts ───────────────────────────────────────────────
# alias c='opencode'  # moved to 08-aliases.zsh
# alias cx='printf "\033[2J\033[3J\033[H" && claude --allow-dangerously-skip-permissions'
# alias r='rails'
# alias d='docker'  # conflicts with dir-stack alias in 08-aliases.zsh
# alias gh='gh'  # no-op alias; command already exists as `gh`

# Git aliases (old style)
# alias gp='git push'  # conflicts with gp='git pull --rebase --autostash'
# alias gpu='git pull'  # replaced by modular alias in 08-aliases.zsh
# alias gcad='git commit -a --amend'  # risky shorthand, low-value

# Tmux — attach to existing session or create new one named "Work"
# alias tw='tmux attach || tmux new -s Work'  # moved to 08-aliases.zsh

# FZF file picker with bat preview
# alias ff="fzf --preview 'bat --style=numbers --color=always {}'"  # moved to 08-aliases.zsh

# ── nvim — open current dir if no args given ─────────────────────
# n() { ... }  # moved to 09-functions.zsh

# ── open — xdg-open silently in background ───────────────────────
# open() {
#   xdg-open "$@" >/dev/null 2>&1 &
# }

# ── eff — edit file selected via fzf ─────────────────────────────
# eff() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# Compression Utilities
# ══════════════════════════════════════════════════════════════════

# compress — create a .tar.gz archive from a file or directory
# Usage: compress my-folder
# compress() { ... }         # moved to 09-functions.zsh
# alias decompress="tar -xzf"

# ══════════════════════════════════════════════════════════════════
# Drive & ISO Utilities
# ══════════════════════════════════════════════════════════════════

# iso2sd — write an ISO image to an SD card / USB drive
# Usage: iso2sd ~/Downloads/ubuntu.iso /dev/sda
# Usage: iso2sd ~/Downloads/ubuntu.iso  (interactive drive selection)
# iso2sd() { ... }  # moved to 09-functions.zsh

# format-drive — wipe and format an entire drive as exFAT
# Usage: format-drive /dev/sda "My Stuff"
# format-drive() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# SSH Port Forwarding Helpers
# ══════════════════════════════════════════════════════════════════

# fip — forward ports from a remote host to localhost
# Usage: fip myserver 3000 5432 8080
# fip() { ... }  # moved to 09-functions.zsh

# dip — disconnect/stop port forwarding
# Usage: dip 3000 5432
# dip() { ... }  # moved to 09-functions.zsh

# lip — list active port forwards
# lip() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# Video Transcoding (requires ffmpeg)
# ══════════════════════════════════════════════════════════════════

# transcode-video-1080p — downscale video to 1080p using H.264
# Usage: transcode-video-1080p input.mp4
# transcode-video-1080p() { ... }  # moved to 09-functions.zsh

# transcode-video-4K — optimize 4K video using H.265
# Usage: transcode-video-4K input.mp4
# transcode-video-4K() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# Image Conversion (requires imagemagick)
# ══════════════════════════════════════════════════════════════════

# img2jpg — convert image to high-quality JPG
# Usage: img2jpg photo.png
# Usage: img2jpg photo.png -rotate 90  (extra magick flags)
# img2jpg() { ... }  # moved to 09-functions.zsh

# img2jpg-small — convert and resize to max 1080px width
# img2jpg-small() { ... }  # moved to 09-functions.zsh

# img2jpg-medium — convert and resize to max 1800px width
# img2jpg-medium() { ... }  # moved to 09-functions.zsh

# img2png — optimize PNG with maximum compression
# img2png() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# Git Worktree Helpers
# ══════════════════════════════════════════════════════════════════

# gwa — create a new worktree + branch from current repo
# Creates worktree in parent dir with naming: reponame--branchname
# Usage: gwa feature-login
# Note: renamed from ga() to avoid conflict with ga='git add' alias
# gwa() { ... }  # moved to 09-functions.zsh

# gwd — remove the current worktree and its branch
# Must be run from within a worktree (not the main repo)
# Note: renamed from gd() to avoid potential conflicts
# gwd() { ... }  # moved to 09-functions.zsh

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
# tdl() { ... }  # moved to 09-functions.zsh

# tdlm — Tmux multi-project layout: one tdl window per subdirectory
# Opens each subdirectory in its own tmux window with tdl layout
# Usage: tdlm c
# Usage: tdlm c cx
# tdlm() { ... }  # moved to 09-functions.zsh

# tsl — Tmux Swarm Layout: same command started in N panes side by side
# Useful for running the same AI/tool in multiple panes
# Usage: tsl 4 opencode
# tsl() { ... }  # moved to 09-functions.zsh

# ══════════════════════════════════════════════════════════════════
# Startup Directory
# ══════════════════════════════════════════════════════════════════

# Always open new shells in ~/GITHUB
# cd ~/GITHUB 2>/dev/null || true  # moved to 10-tools.zsh
