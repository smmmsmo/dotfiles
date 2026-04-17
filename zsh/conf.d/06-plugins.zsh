# ══════════════════════════════════════════════════════════════════
# Plugins
# ══════════════════════════════════════════════════════════════════
#
# Three plugins, sourced directly — no plugin manager needed.
#
# SOURCE ORDER IS MANDATORY:
#   1. autosuggestions         — before syntax-highlighting
#   2. syntax-highlighting     — must come before history-substring-search
#   3. history-substring-search — must be sourced last (per its docs)
#
# Install: brew install zsh-autosuggestions zsh-syntax-highlighting \
#                       zsh-history-substring-search

# ── Helper ───────────────────────────────────────────────────────
_source_first() {
  for _f in "$@"; do
    [[ -f "$_f" ]] && { source "$_f"; return 0; }
  done
  return 1
}

# ── zsh-autosuggestions ──────────────────────────────────────────
if _source_first \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
  ZSH_AUTOSUGGEST_USE_ASYNC=true
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89,underline"
  # Accept full suggestion
  # Ctrl-Space is consumed by tmux as its prefix key, so Ctrl-f is the
  # primary binding inside tmux. Ctrl-] and Ctrl-Space work outside tmux.
  bindkey '^f'  autosuggest-accept   # Ctrl-f  (works inside tmux)
  bindkey '^]'  autosuggest-accept   # Ctrl-]
  bindkey '^ '  autosuggest-accept   # Ctrl-Space (outside tmux only)
  # Accept one word at a time (Alt-Right / Alt-L)
  bindkey '^[l' forward-word         # Alt-l — step through suggestion word by word
fi

# ── zsh-syntax-highlighting ──────────────────────────────────────
if _source_first \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
  ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan'
fi

# ── zsh-history-substring-search ─────────────────────────────────
if _source_first \
  /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
then
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
  _bind_history_search   # defined in 04-keybindings.zsh
fi

# ── Restore Tab binding ───────────────────────────────────────────
# fzf (05-fzf.zsh) overrides Tab with fzf-completion.
# Re-bind here so our smart widget is active AND fzf's ** completion works
# (fzf saves our widget as fzf_default_completion).
bindkey '^I' _tab_complete_smart
