# ══════════════════════════════════════════════════════════════════
# ~/.zshrc — Modular Loader
# ══════════════════════════════════════════════════════════════════
#
# This file sources all config modules from conf.d/ in numeric
# order. Each module handles one concern (environment, options,
# completion, etc.).
#
# Source order matters:
#   01-environment  — PATH, EDITOR, XDG dirs (needed by everything)
#   02-options      — setopt calls, history config
#   03-completion   — fpath, compinit, zstyle rules
#   04-keybindings  — bindkey mappings
#   05-fzf          — fuzzy finder config and shell integration
#   06-plugins      — autosuggestions, syntax-highlighting, history-search
#   07-prompt       — starship init
#   08-aliases      — all aliases (navigation, git, docker, tools)
#   09-functions    — shell functions (extract, fzf helpers, etc.)
#   10-tools        — zoxide, direnv (eval hooks, loaded last)
#
# To add new config, create a new .zsh file in conf.d/ with the
# appropriate numeric prefix. Files are sourced in glob order.
#
# See REFERENCE.md in this directory for a full cheatsheet of
# all aliases, functions, keybindings, and options.
# ══════════════════════════════════════════════════════════════════

# ── Performance: skip global compinit (we run our own) ───────────
skip_global_compinit=1

# ── OS detection (available to all modules via $_os) ─────────────
case "$(uname -s)" in
  Darwin) _os=macos ;;
  Linux)  _os=linux ;;
  *)      _os=other ;;
esac

# ── Source all modules in order ──────────────────────────────────
# Resolve the real path of ~/.zshrc (following symlinks) to find
# conf.d/ relative to the actual file location in the dotfiles repo.
# This works whether ~/.zshrc is a symlink or a real file.
_zsh_conf_dir="${${:-$HOME/.zshrc}:A:h}/conf.d"
if [[ -d "$_zsh_conf_dir" ]]; then
  for _conf in "$_zsh_conf_dir"/*.zsh(N); do
    source "$_conf"
  done
  unset _conf
fi
unset _zsh_conf_dir
