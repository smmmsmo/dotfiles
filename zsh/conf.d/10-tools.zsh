# ══════════════════════════════════════════════════════════════════
# Tool Integrations
# ══════════════════════════════════════════════════════════════════
#
# eval-based hooks placed LAST so they can override builtins and
# see all config that was loaded earlier.

# ── zoxide — frecency-based cd ────────────────────────────────────
# --cmd cd replaces the built-in cd with zoxide's smarter version.
# `cd` with no args still goes home; `cdi` opens an fzf picker.
# Install: brew install zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# ── direnv — per-directory environment variables ─────────────────
# Automatically loads/unloads .envrc when you cd in and out.
# Install: brew install direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# ── mise — dev tool version manager ──────────────────────────────
# Manages node, python, ruby, go, rust versions per project
# via .tool-versions or .mise.toml.
# Install: brew install mise   or   curl https://mise.run | sh
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ── thefuck — auto-correct previous command ───────────────────────
# Type `fuck` (or press Ctrl-F) after a typo to correct and re-run.
# Install: brew install thefuck
if command -v thefuck &>/dev/null; then
  eval "$(thefuck --alias)"
  bindkey '^F' _run_thefuck 2>/dev/null || true
fi

# ── atuin — shell history sync (optional) ────────────────────────
# Replaces Ctrl-R with a TUI that syncs history across machines.
# Only activated if installed — doesn't break anything if absent.
# Install: brew install atuin
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# ── Terminal title: set to current directory ──────────────────────
# Updates the terminal/tab title to show the current directory
# (works in most xterm-compatible terminals and iTerm2).
_set_terminal_title() {
  local title="${PWD/#$HOME/~}"
  print -Pn "\e]0;${title}\a"
}
add-zsh-hook chpwd _set_terminal_title
_set_terminal_title   # set on startup too
