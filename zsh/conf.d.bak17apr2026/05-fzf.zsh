# ══════════════════════════════════════════════════════════════════
# FZF — Fuzzy Finder Integration
# ══════════════════════════════════════════════════════════════════
#
# fzf adds fuzzy search to your shell in three main ways:
#   Ctrl-T  -> insert a file path (searches with fd, previews with bat)
#   Ctrl-R  -> search command history (replaces default reverse search)
#   Alt-C   -> cd into a directory (previews with eza tree)
#
# fd is used as the backend instead of find because:
#   - It respects .gitignore automatically
#   - It's ~5x faster on large directory trees
#   - It has saner defaults (no permission errors, colored output)
#
# Colors use the Tokyo Night palette, matching bat, delta, and
# the terminal theme for visual consistency.
#
# Install: brew install fzf fd
# Docs: https://github.com/junegunn/fzf
# ══════════════════════════════════════════════════════════════════

if command -v fzf &>/dev/null; then

  # ── Backend: use fd instead of find ────────────────────────────
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
  fi

  # ── Appearance and keybindings ─────────────────────────────────
  # Tokyo Night color palette (same colors used in bat, delta, starship)
  export FZF_DEFAULT_OPTS="
    --height=50%
    --layout=reverse
    --border=rounded
    --info=inline
    --prompt='> '
    --pointer='>'
    --marker='*'
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-u:preview-half-page-up'
    --bind 'ctrl-d:preview-half-page-down'
    --color=bg+:#283457,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
    --color=fg:#c0caf5,header:#7aa2f7,info:#bb9af7,pointer:#7dcfff
    --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7"

  # ── Ctrl-T: file picker with bat preview ───────────────────────
  if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
  fi

  # ── Alt-C: directory picker with tree preview ──────────────────
  if command -v eza &>/dev/null; then
    export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=1 --color=always {}'"
  else
    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
  fi

  # ── Source fzf shell integration (cross-platform) ──────────────
  # This registers the Ctrl-T, Ctrl-R, and Alt-C keybindings.
  # fzf 0.48+ has a built-in `fzf --zsh` command that outputs
  # the shell integration script. Older versions need manual sourcing.
  #
  # Note: fzf's option save/restore code captures ALL zsh options
  # (including read-only ones like 'zle') and emits harmless warnings:
  #   "(eval):1: can't change option: zle"
  # The 2>/dev/null on eval suppresses these. This is a known fzf bug.
  if [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh" 2>/dev/null
  elif command -v fzf &>/dev/null && fzf --zsh &>/dev/null; then
    eval "$(fzf --zsh)" 2>/dev/null
  else
    for _fzf_root in /opt/homebrew/opt/fzf /usr/local/opt/fzf /usr/share/fzf; do
      if [[ -d "$_fzf_root/shell" ]]; then
        source "$_fzf_root/shell/key-bindings.zsh"  2>/dev/null
        source "$_fzf_root/shell/completion.zsh"    2>/dev/null
        break
      fi
    done
  fi

fi
