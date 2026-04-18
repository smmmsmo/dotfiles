# ══════════════════════════════════════════════════════════════════
# FZF — Fuzzy Finder Integration
# ══════════════════════════════════════════════════════════════════
#
#   Ctrl-T  → insert a file path (fd backend, bat preview)
#   Ctrl-R  → search history (replaces default reverse search)
#   Alt-C   → cd into a directory (eza tree preview)
#
# Install: brew install fzf fd
# ══════════════════════════════════════════════════════════════════

command -v fzf &>/dev/null || return

# ── Clipboard command (cross-platform) ───────────────────────────
if [[ $_os == macos ]]; then
  _fzf_clip='pbcopy'
elif command -v wl-copy &>/dev/null; then
  _fzf_clip='wl-copy'
elif command -v xclip &>/dev/null; then
  _fzf_clip='xclip -selection clipboard'
elif command -v xsel &>/dev/null; then
  _fzf_clip='xsel --clipboard --input'
else
  _fzf_clip=''
fi

# ── Backend ──────────────────────────────────────────────────────
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

# ── Appearance (Tokyo Night) ──────────────────────────────────────
# Use --opt=value throughout; fzf's tokenizer handles this form
# unambiguously across all versions (avoids space-separated parsing).
# The clipboard bind uses --bind "key:action" because the action
# contains spaces; inner double-quotes protect {} from being parsed
# as closing the outer ${_fzf_clip:+...} expansion.
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer=▶
  --marker=✓
  --bind=ctrl-/:toggle-preview
  --bind=ctrl-u:preview-half-page-up
  --bind=ctrl-d:preview-half-page-down
  --bind=ctrl-a:select-all
  ${_fzf_clip:+--bind "ctrl-y:execute-silent(echo {+} | $_fzf_clip)"}
  --bind=?:toggle-preview
  --color=bg+:#283457,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#7aa2f7,info:#bb9af7,pointer:#7dcfff
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7
  --color=border:#283457"

# ── Ctrl-T: file picker ───────────────────────────────────────────
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="
    --preview='bat --color=always --line-range :200 {}'
    --preview-window=right:55%:wrap"
fi

# ── Ctrl-R: history picker ────────────────────────────────────────
# Show the full command in the preview window.
# --sort is intentionally omitted: fzf defaults to chronological order for
# history which is more useful. --exact is omitted: fuzzy is the whole point.
export FZF_CTRL_R_OPTS="
  --preview='echo {}'
  --preview-window=down:3:wrap
  ${_fzf_clip:+--bind "ctrl-y:execute-silent(echo -n {2..} | $_fzf_clip)+abort"}"

# ── Alt-C: directory picker ───────────────────────────────────────
if command -v eza &>/dev/null; then
  export FZF_ALT_C_OPTS="
    --preview='eza --icons --tree --level=2 --color=always {}'
    --preview-window=right:45%"
else
  export FZF_ALT_C_OPTS="--preview='ls -la {}'"
fi

# ── Shell integration ─────────────────────────────────────────────
# fzf 0.48+ ships `fzf --zsh`; older installs need a sourced file.
if [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh" 2>/dev/null
elif fzf --zsh &>/dev/null; then
  eval "$(fzf --zsh)" 2>/dev/null
else
  for _fzf_root in /opt/homebrew/opt/fzf /usr/local/opt/fzf /usr/share/fzf; do
    if [[ -d "$_fzf_root/shell" ]]; then
      source "$_fzf_root/shell/key-bindings.zsh" 2>/dev/null
      source "$_fzf_root/shell/completion.zsh"   2>/dev/null
      break
    fi
  done
  unset _fzf_root
fi
