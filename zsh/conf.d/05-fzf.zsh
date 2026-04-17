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

# ── Backend ──────────────────────────────────────────────────────
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

# ── Appearance (Tokyo Night) ──────────────────────────────────────
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-u:preview-half-page-up'
  --bind 'ctrl-d:preview-half-page-down'
  --bind 'ctrl-a:select-all'
  --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
  --bind '?:toggle-preview'
  --color=bg+:#283457,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#7aa2f7,info:#bb9af7,pointer:#7dcfff
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7
  --color=border:#283457"

# ── Ctrl-T: file picker ───────────────────────────────────────────
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="
    --preview 'bat --color=always --line-range :200 {}'
    --preview-window 'right:55%:wrap'"
fi

# ── Ctrl-R: history picker ────────────────────────────────────────
# Show the full command in the preview window; sort by recency.
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window 'down:3:wrap'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --sort
  --exact"

# ── Alt-C: directory picker ───────────────────────────────────────
if command -v eza &>/dev/null; then
  export FZF_ALT_C_OPTS="
    --preview 'eza --icons --tree --level=2 --color=always {}'
    --preview-window 'right:45%'"
else
  export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
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
