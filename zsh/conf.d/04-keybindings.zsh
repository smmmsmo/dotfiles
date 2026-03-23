# ══════════════════════════════════════════════════════════════════
# Key Bindings
# ══════════════════════════════════════════════════════════════════
#
# Uses emacs mode (bindkey -e), which is the default for most
# terminals. This gives you familiar shortcuts:
#   Ctrl-A / Ctrl-E  -> beginning / end of line
#   Ctrl-W           -> delete word backward
#   Ctrl-R           -> reverse history search (overridden by fzf)
#   Ctrl-X Ctrl-E    -> open current command in $EDITOR
#
# If you prefer vim-style modal editing, change to `bindkey -v`
# and consider the zsh-vi-mode plugin for better vim emulation.
#
# Terminal escape codes vary by terminal emulator. The codes below
# work in Ghostty, iTerm2, Alacritty, and most modern terminals.
# If a binding doesn't work, use `cat -v` then press the key
# to see what escape code your terminal sends.
#
# ── Quick Reference ──────────────────────────────────────────────
#   Ctrl-A         beginning of line
#   Ctrl-E         end of line
#   Ctrl-W         delete word backward
#   Alt-D          delete word forward
#   Alt-F / Alt-B  word forward / backward
#   Ctrl-X Ctrl-E  edit command in $EDITOR
#   Ctrl-Space     accept autosuggestion
#   Up / Down      history substring search
#   Ctrl-P / N     history substring search (alternative)
#   Ctrl-/         toggle fzf preview
# ══════════════════════════════════════════════════════════════════

bindkey -e   # emacs mode

# If the command line is empty, make Tab complete local files/directories
# instead of listing every command on PATH. Otherwise keep normal zsh
# completion behavior.
zle -C complete-local-files complete-word _files
_tab_complete_smart() {
  if [[ -z $BUFFER ]]; then
    zle complete-local-files
  else
    zle expand-or-complete
  fi
}
zle -N _tab_complete_smart
bindkey '^I' _tab_complete_smart

# ── Word navigation ──────────────────────────────────────────────
# Ctrl+Arrow keys (terminal-dependent escape codes)
bindkey '^[[1;5C' forward-word     # Ctrl-Right
bindkey '^[[1;5D' backward-word    # Ctrl-Left
# Alt+F / Alt+B (standard emacs word movement)
bindkey '^[f'     forward-word
bindkey '^[b'     backward-word

# ── Home / End ───────────────────────────────────────────────────
bindkey '^[[H'  beginning-of-line  # Home key
bindkey '^[[F'  end-of-line        # End key
bindkey '^A'    beginning-of-line  # Ctrl-A
bindkey '^E'    end-of-line        # Ctrl-E

# ── Delete word ──────────────────────────────────────────────────
bindkey '^W'    backward-kill-word # Ctrl-W (delete word left)
bindkey '^[d'   kill-word          # Alt-D  (delete word right)

# ── Edit command in $EDITOR ──────────────────────────────────────
# Press Ctrl-X Ctrl-E to open the current command line in your
# editor. Useful for writing complex multi-line commands.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ── History substring search bindings ────────────────────────────
# These are defined as a function and called AFTER the
# history-substring-search plugin is sourced in 06-plugins.zsh,
# because the widget must exist before we can bind to it.
_bind_history_search() {
  bindkey '^[[A' history-substring-search-up    # Up arrow
  bindkey '^[[B' history-substring-search-down  # Down arrow
  bindkey '^P'   history-substring-search-up    # Ctrl-P
  bindkey '^N'   history-substring-search-down  # Ctrl-N
}
