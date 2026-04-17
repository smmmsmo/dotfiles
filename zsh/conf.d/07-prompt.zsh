# ══════════════════════════════════════════════════════════════════
# Prompt — Starship
# ══════════════════════════════════════════════════════════════════
#
# Configured via ~/.config/starship.toml.
# Falls back to a minimal vcs_info prompt when starship is absent
# (useful on remote servers / fresh installs).
#
# Install: brew install starship   or   curl -sS https://starship.rs/install.sh | sh

autoload -Uz colors && colors

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '
  zstyle ':vcs_info:*' enable git
  precmd() { vcs_info }
  # user@host:~/path (branch) %/#
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f ${vcs_info_msg_0_}%(?.%F{green}.%F{red})%(!.#.❯)%f '
  # Right-prompt: exit code of last command when non-zero
  RPROMPT='%(?..%F{red}✘ %?%f)'
fi
