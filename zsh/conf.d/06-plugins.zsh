# ══════════════════════════════════════════════════════════════════
# Plugins
# ══════════════════════════════════════════════════════════════════
#
# Three plugins are used, sourced directly from system/Homebrew
# paths without a plugin manager. This avoids the overhead of
# zinit/antigen/oh-my-zsh while keeping things simple.
#
# No plugin manager is used because:
#   - Only 3 plugins are needed (not worth the abstraction)
#   - System packages (brew) handle installation and updates
#   - Direct sourcing is faster and more transparent
#
# SOURCE ORDER MATTERS:
#   1. autosuggestions — must come before syntax-highlighting
#   2. syntax-highlighting — must be LAST plugin that modifies
#      the line editor (ZLE), per its documentation
#   3. history-substring-search — must come after syntax-highlighting
#      so it can override the up/down bindings properly
#
# Install all three:
#   brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
# ══════════════════════════════════════════════════════════════════

# ── Helper: source the first file found from a list of paths ─────
# Tries each path in order, sources the first one that exists.
# Returns 0 if found, 1 if none exist. Used to handle the fact
# that plugins live in different paths on macOS vs Linux.
_source_first() {
  for _f in "$@"; do
    if [[ -f "$_f" ]]; then
      source "$_f"
      return 0
    fi
  done
  return 1
}

# ── zsh-autosuggestions ──────────────────────────────────────────
# Shows ghost text from history as you type. Press Ctrl+Space or
# right arrow to accept the suggestion.
#
# Strategy: first try history, then fall back to completion engine.
# BUFFER_MAX_SIZE prevents expensive lookups on very long lines.
# ASYNC=true prevents the suggestion lookup from blocking input.
if _source_first \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
  ZSH_AUTOSUGGEST_USE_ASYNC=true
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,underline"
  bindkey '^ ' autosuggest-accept     # Ctrl+Space accepts suggestion
  bindkey '^]' autosuggest-accept     # fallback accept
fi

# ── zsh-syntax-highlighting ──────────────────────────────────────
# Colorizes commands as you type (like fish shell). Red = invalid
# command, green = valid, yellow = string, etc.
#
# Highlighters enabled:
#   main     — command/argument coloring
#   brackets — matching bracket highlighting
#   pattern  — custom pattern-based highlights
#   cursor   — cursor position highlighting
if _source_first \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
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
fi

# ── zsh-history-substring-search ─────────────────────────────────
# Type a partial command then press Up/Down to search history for
# commands containing that substring. Much better than the default
# prefix-only history search.
#
# FUZZY=1 enables fuzzy matching (e.g., "gti" matches "git").
# _bind_history_search is defined in 04-keybindings.zsh.
if _source_first \
  /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh; then
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  _bind_history_search
fi
