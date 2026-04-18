# ══════════════════════════════════════════════════════════════════
# Key Bindings
# ══════════════════════════════════════════════════════════════════
#
# Emacs mode: Ctrl-A/E (line nav), Ctrl-W (word delete),
# Ctrl-R (history), Ctrl-X Ctrl-E (edit in $EDITOR).
#
# To discover escape codes for a key: press Ctrl-V then the key,
# or run `cat -v` and press it.

bindkey -e   # emacs mode

# ── Tab: smart completion ─────────────────────────────────────────
# Empty buffer → complete local files; otherwise → normal completion.
# Registered here so fzf (05-fzf.zsh) can save it as
# fzf_default_completion. Re-bound after fzf in 06-plugins.zsh.
zle -C complete-local-files complete-word _files
_tab_complete_smart() {
  if [[ -z $BUFFER ]]; then
    zle complete-local-files
  else
    zle expand-or-complete
  fi
}
zle -N _tab_complete_smart

# ── Word navigation ──────────────────────────────────────────────
bindkey '^[[1;5C' forward-word       # Ctrl-Right
bindkey '^[[1;5D' backward-word      # Ctrl-Left
bindkey '^[f'     forward-word       # Alt-F
bindkey '^[b'     backward-word      # Alt-B

# ── Home / End ───────────────────────────────────────────────────
bindkey '^[[H'    beginning-of-line  # Home
bindkey '^[[F'    end-of-line        # End
bindkey '^A'      beginning-of-line  # Ctrl-A
bindkey '^E'      end-of-line        # Ctrl-E

# ── Delete ───────────────────────────────────────────────────────
bindkey '^W'      backward-kill-word # Ctrl-W  — delete word left
bindkey '^[d'     kill-word          # Alt-D   — delete word right
bindkey '^[[3~'   delete-char        # Delete key (forward-delete)
bindkey '^H'      backward-delete-char # Backspace in some terminals

# ── Copy / paste helpers ─────────────────────────────────────────
# Ctrl-Y yank (paste), Ctrl-K kill to end of line
bindkey '^K'      kill-line
bindkey '^Y'      yank

# ── Undo / redo ──────────────────────────────────────────────────
bindkey '^_'      undo               # Ctrl-/  (undo)
bindkey '^[^_'    redo               # Alt-Ctrl-/ (redo)

# ── Edit command in $EDITOR ──────────────────────────────────────
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line    # Ctrl-X Ctrl-E

# ── Push line (park current command, run another, restore) ───────
# Ctrl-Q parks the current command, lets you run something else,
# then the parked command comes back automatically.
bindkey '^Q' push-line-or-edit

# ── Surround / quote current word ────────────────────────────────
# Alt-' wraps the current word in single quotes.
autoload -Uz modify-current-argument
_single_quote_word() { modify-current-argument "'${ARG//\'/\\'\\''}'"; }
_double_quote_word() { modify-current-argument "\"${ARG}\""; }
zle -N _single_quote_word
zle -N _double_quote_word
bindkey "^['" _single_quote_word    # Alt-'  — single-quote word
bindkey '^["' _double_quote_word    # Alt-"  — double-quote word

# ── Paste URL safely ─────────────────────────────────────────────
# bracketed-paste-magic handles safe pasting of multi-line content.
# url-quote-magic is intentionally NOT bound to self-insert — it causes
# noticeable typing lag in modern terminals and conflicts with paste magic.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# ── History substring search bindings ────────────────────────────
# Called from 06-plugins.zsh AFTER the plugin is sourced,
# because the widget must exist before we bind to it.
_bind_history_search() {
  bindkey '^[[A' history-substring-search-up    # Up
  bindkey '^[[B' history-substring-search-down  # Down
  bindkey '^P'   history-substring-search-up    # Ctrl-P
  bindkey '^N'   history-substring-search-down  # Ctrl-N
}
