# ══════════════════════════════════════════════════════════════════
# Prompt — Starship
# ══════════════════════════════════════════════════════════════════
#
# Starship is a fast, cross-shell prompt written in Rust. It shows:
#   - Current directory
#   - Git branch, status, and ahead/behind counts
#   - Language versions (node, python, rust, etc.) when relevant
#   - Command execution time (for slow commands)
#   - Exit code of the last command
#
# The prompt is configured separately in ~/.config/starship.toml
# (managed in this dotfiles repo at starship/.config/starship.toml).
#
# A vcs_info fallback is provided in case starship is not installed
# (e.g., on a remote server you SSH into). It shows a basic
# user@host:~/path (branch) prompt with git branch info.
#
# Install: brew install starship
# Docs: https://starship.rs
# ══════════════════════════════════════════════════════════════════

autoload -Uz colors && colors

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback: basic prompt with git branch via vcs_info
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '
  precmd() { vcs_info }
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f ${vcs_info_msg_0_}%# '
fi
