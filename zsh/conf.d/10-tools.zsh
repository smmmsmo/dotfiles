# ══════════════════════════════════════════════════════════════════
# Tool Integrations
# ══════════════════════════════════════════════════════════════════
#
# External tools that need to hook into the shell via `eval`.
# These are placed LAST because they may override builtins (e.g.,
# zoxide replaces `cd`) and need all other config to be loaded first.
#
# Each tool is guarded with `command -v` so the config works on
# systems where the tool isn't installed.
# ══════════════════════════════════════════════════════════════════

# ── zoxide — smarter cd with frecency ────────────────────────────
# Tracks which directories you visit most frequently and recently,
# then lets you jump to them with partial names.
#
# --cmd cd: replaces the built-in `cd` command with zoxide, so
# `cd foo` uses frecency matching. `cd` with no args still goes to ~.
# `cdi` opens an interactive fzf picker of your frecency database.
#
# Install: brew install zoxide
# Docs: https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# ── direnv — per-directory environment variables ─────────────────
# Automatically loads/unloads environment variables when you cd
# into a directory containing a .envrc file. Useful for:
#   - Project-specific PATH additions
#   - Database URLs per project
#   - Node/Python version switching (via nvm/pyenv integration)
#
# Create a .envrc file in any project directory:
#   echo 'export DATABASE_URL=postgres://...' > .envrc
#   direnv allow
#
# Install: brew install direnv
# Docs: https://direnv.net
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi
