# ======================================================================
#  ~/.zshrc
# ======================================================================

# ── Performance: skip compinit on non-login shells ───────────────
skip_global_compinit=1

# ── OS detection (used throughout this file) ─────────────────────
case "$(uname -s)" in
  Darwin) _os=macos ;;
  Linux)  _os=linux ;;
  *)      _os=other ;;
esac

# ══════════════════════════════════════════════════════════════════
# ENVIRONMENT
# ══════════════════════════════════════════════════════════════════
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor — prefer nvim > vim > vi
if   command -v nvim &>/dev/null; then export EDITOR=nvim VISUAL=nvim
elif command -v vim  &>/dev/null; then export EDITOR=vim  VISUAL=vim
else                                    export EDITOR=vi   VISUAL=vi
fi

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Pager — use bat if available, otherwise less
if command -v bat &>/dev/null; then
  export PAGER="bat --paging=always"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="tokyonight_night"
else
  export PAGER="less -RFX"
  export MANPAGER="less -RFX"
fi

# PATH — deduplicated
typeset -U path PATH
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)
# macOS: add Homebrew paths
if [[ $_os == macos ]] && [[ -d /opt/homebrew ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi
# Antigravity (if installed)
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && path=("$HOME/.antigravity/antigravity/bin" $path)
export PATH

# ══════════════════════════════════════════════════════════════════
# SHELL OPTIONS
# ══════════════════════════════════════════════════════════════════
setopt auto_cd               # type a dir name to cd into it
setopt auto_pushd            # cd pushes to dir stack automatically
setopt pushd_ignore_dups     # no duplicates in dir stack
setopt pushd_silent          # quiet pushd/popd
setopt cdable_vars           # cd $VAR works without `cd`

setopt complete_in_word      # complete from cursor, not end of word
setopt always_to_end         # move cursor to end after completion
setopt list_packed           # compact completion list

setopt extended_glob         # extended globbing (#, ~, ^)
setopt glob_dots             # include dotfiles in globs

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space     # commands starting with space are not saved
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify           # edit recalled history before executing
setopt append_history
setopt share_history         # share history across sessions (implies inc_append_history)

setopt interactive_comments  # allow # comments in interactive shell
setopt no_beep               # silence the terminal bell
setopt prompt_subst          # allow dynamic prompt
setopt long_list_jobs        # show PID in job notifications

# ══════════════════════════════════════════════════════════════════
# HISTORY
# ══════════════════════════════════════════════════════════════════
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

# ══════════════════════════════════════════════════════════════════
# COMPLETION
# ══════════════════════════════════════════════════════════════════

# fpath must be set BEFORE compinit so completions are picked up
if [[ $_os == macos ]] && [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
elif [[ $_os == linux ]] && [[ -d /usr/share/zsh/site-functions ]]; then
  fpath=(/usr/share/zsh/site-functions $fpath)
fi

autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# Rebuild compinit once per day for speed
if [[ -n "$ZSH_CACHE_DIR/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$ZSH_CACHE_DIR/zcompdump"
else
  compinit -C -d "$ZSH_CACHE_DIR/zcompdump"
fi

zstyle ':completion:*' menu select                          # interactive menu
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # fuzzy match
zstyle ':completion:*' group-name ''                        # group by category
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{red}No matches: %d%f'
zstyle ':completion:*:corrections' format '%F{green}%d (errors: %e)%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion::complete:*' gain-privileges 1          # sudo completions
zstyle ':completion:*' squeeze-slashes true

# ══════════════════════════════════════════════════════════════════
# KEY BINDINGS
# ══════════════════════════════════════════════════════════════════
bindkey -e   # emacs mode (Ctrl-A/E, Ctrl-R, etc.)

# Word navigation (works in most terminals)
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[f'     forward-word
bindkey '^[b'     backward-word

# Home / End
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^A'    beginning-of-line
bindkey '^E'    end-of-line

# Delete word backward/forward
bindkey '^W'    backward-kill-word
bindkey '^[d'   kill-word

# Open current line in $EDITOR (Ctrl-X Ctrl-E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# History substring search bindings (set after plugin is sourced below)
_bind_history_search() {
  bindkey '^[[A' history-substring-search-up    # Up arrow
  bindkey '^[[B' history-substring-search-down  # Down arrow
  bindkey '^P'   history-substring-search-up
  bindkey '^N'   history-substring-search-down
}

# ══════════════════════════════════════════════════════════════════
# FZF — fuzzy finder integration
# ══════════════════════════════════════════════════════════════════
if command -v fzf &>/dev/null; then
  # Use fd as the default find command (respects .gitignore, faster)
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
  fi

  # Preview with bat, colors, layout — Tokyo Night palette
  export FZF_DEFAULT_OPTS="
    --height=50%
    --layout=reverse
    --border=rounded
    --info=inline
    --prompt='> '
    --pointer='>'
    --marker='*'
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-u:preview-half-page-up'
    --bind 'ctrl-d:preview-half-page-down'
    --color=bg+:#283457,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
    --color=fg:#c0caf5,header:#7aa2f7,info:#bb9af7,pointer:#7dcfff
    --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7"

  if command -v bat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
  fi

  if command -v eza &>/dev/null; then
    export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=1 --color=always {}'"
  else
    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
  fi

  # Source fzf shell integration (cross-platform)
  if [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  elif command -v fzf &>/dev/null && fzf --zsh &>/dev/null; then
    # fzf 0.48+ has built-in shell integration
    eval "$(fzf --zsh)"
  else
    # Fallback: search common install locations
    for _fzf_root in /opt/homebrew/opt/fzf /usr/local/opt/fzf /usr/share/fzf; do
      if [[ -d "$_fzf_root/shell" ]]; then
        source "$_fzf_root/shell/key-bindings.zsh"  2>/dev/null
        source "$_fzf_root/shell/completion.zsh"    2>/dev/null
        break
      fi
    done
  fi
fi

# ══════════════════════════════════════════════════════════════════
# PLUGINS  (sourced late so they can override earlier bindings)
#
# Searches both macOS (homebrew) and Linux (system) plugin paths.
# ══════════════════════════════════════════════════════════════════

# Helper: source the first file found from a list of paths
_source_first() {
  for _f in "$@"; do
    if [[ -f "$_f" ]]; then
      source "$_f"
      return 0
    fi
  done
  return 1
}

# zsh-autosuggestions — ghost text from history
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

# zsh-syntax-highlighting — fish-like syntax coloring
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

# zsh-history-substring-search — up/down to search history by prefix
if _source_first \
  /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh; then
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  _bind_history_search
fi

# ══════════════════════════════════════════════════════════════════
# PROMPT — starship (with vcs_info fallback)
# ══════════════════════════════════════════════════════════════════
autoload -Uz colors && colors
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '
  precmd() { vcs_info }
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f ${vcs_info_msg_0_}%# '
fi

# ══════════════════════════════════════════════════════════════════
# ALIASES — Navigation
# ══════════════════════════════════════════════════════════════════
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'          # go back to previous dir
alias d='dirs -v'          # show dir stack (numbered)
for i in {1..9}; do alias "$i"="cd +$i"; done  # 1-9 to jump dir stack

# ── Listing (eza > ls) ────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first --color=always'
  alias l='eza --icons --group-directories-first -1'
  alias ll='eza --icons --group-directories-first -lah --git'
  alias la='eza --icons --group-directories-first -lah --git -a'
  alias lt='eza --icons --group-directories-first --tree --level=2'
  alias ltt='eza --icons --group-directories-first --tree --level=3'
  alias lttt='eza --icons --group-directories-first --tree --level=4'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah'
  alias la='ls -lAh'
  alias l='ls -CF'
fi

# ── cat > bat ─────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'               # bat with paging
  alias batp='bat --paging=always'
fi

# ══════════════════════════════════════════════════════════════════
# ALIASES — Git
# ══════════════════════════════════════════════════════════════════
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcam='git commit --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --decorate --graph --all'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gp='git pull --rebase --autostash'
alias gps='git push'
alias gpf='git push --force-with-lease'   # safer than --force
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gf='git fetch --all --prune'
alias gm='git merge --no-ff'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gcp='git cherry-pick'
alias greset='git reset --soft HEAD~1'     # undo last commit, keep changes staged
alias gclean='git clean -fd'
alias gwip='git add -A && git commit -m "WIP: $(date +%H:%M)"'

# ══════════════════════════════════════════════════════════════════
# ALIASES — Docker
# ══════════════════════════════════════════════════════════════════
alias dk='docker'
alias dkc='docker compose'
alias dkcu='docker compose up -d'
alias dkcd='docker compose down'
alias dkps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkim='docker images'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkprune='docker system prune -af --volumes'

# ══════════════════════════════════════════════════════════════════
# ALIASES — Node / npm
# ══════════════════════════════════════════════════════════════════
alias ni='npm install'
alias nid='npm install --save-dev'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'

# ══════════════════════════════════════════════════════════════════
# ALIASES — Python
# ══════════════════════════════════════════════════════════════════
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null'

# ══════════════════════════════════════════════════════════════════
# ALIASES — Misc (cross-platform)
# ══════════════════════════════════════════════════════════════════
alias mkdirp='mkdir -p'
alias cp='cp -iv'                   # interactive + verbose
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias du='du -sh'
alias path='echo -e ${PATH//:/\\n}'  # pretty-print PATH
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias zshrc='${EDITOR} ~/.zshrc'
alias nvimrc='${EDITOR} ~/.config/nvim'
alias ghosttyrc='${EDITOR} ~/.config/ghostty/config'
alias starshiprc='${EDITOR} ~/.config/starship.toml'
alias dot='cd ~/GITHUB/dotfiles'
alias hosts='sudo ${EDITOR} /etc/hosts'
alias ip='curl -s https://ipinfo.io/ip'
alias ports='lsof -i -P -n | grep LISTEN'

# Cross-platform local IP
if [[ $_os == macos ]]; then
  alias localip='ipconfig getifaddr en0'
else
  alias localip='hostname -I | awk "{print \$1}"'
fi

# ── macOS-only aliases ────────────────────────────────────────────
if [[ $_os == macos ]]; then
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo "DNS flushed"'
  alias brewup='brew update && brew upgrade && brew cleanup && echo "Homebrew updated"'
fi

# ══════════════════════════════════════════════════════════════════
# FUNCTIONS
# ══════════════════════════════════════════════════════════════════

# mkcd — mkdir and cd in one step
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# extract — universal archive extractor
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <file>"
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a valid file"
    return 1
  fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"   ;;
    *.tar.gz)   tar xzf "$1"   ;;
    *.tar.xz)   tar xJf "$1"   ;;
    *.tar.zst)  tar --zstd -xf "$1" ;;
    *.bz2)      bunzip2 "$1"   ;;
    *.rar)      unrar x "$1"   ;;
    *.gz)       gunzip "$1"    ;;
    *.tar)      tar xf "$1"    ;;
    *.tbz2)     tar xjf "$1"   ;;
    *.tgz)      tar xzf "$1"   ;;
    *.zip)      unzip "$1"     ;;
    *.Z)        uncompress "$1";;
    *.7z)       7z x "$1"      ;;
    *.deb)      ar x "$1"      ;;
    *.xz)       unxz "$1"      ;;
    *.zst)      unzstd "$1"    ;;
    *) echo "extract: '$1' — unknown archive format" && return 1 ;;
  esac
}

# fcd — fzf-powered cd into any subdirectory
fcd() {
  local dir preview
  if command -v eza &>/dev/null; then
    preview='eza --icons --tree --level=1 --color=always {}'
  else
    preview='ls -la {}'
  fi
  dir=$(fd --type d --hidden --exclude .git 2>/dev/null \
        | fzf --preview "$preview" --prompt '> ') && cd "$dir"
}

# fkill — interactively kill a process via fzf
fkill() {
  local pid
  pid=$(ps aux | fzf --header='Select process to kill' --prompt='> ' \
        | awk '{print $2}')
  [[ -n "$pid" ]] && kill -${1:-9} "$pid" && echo "Killed PID $pid"
}

# fhist — fuzzy search and re-run a command from history
fhist() {
  local cmd
  cmd=$(fc -l 1 | fzf --tac --prompt='> ' --preview='echo {}' \
        | sed 's/ *[0-9]* *//')
  [[ -n "$cmd" ]] && print -z "$cmd"  # put into readline buffer
}

# fenv — fuzzy search environment variables
fenv() {
  env | sort | fzf --prompt='> ' --preview='echo {}'
}

# gbr — fzf-powered git branch switcher
gbr() {
  local branch
  branch=$(git branch -a --color=always \
           | grep -v '\->' \
           | fzf --ansi --preview 'git log --oneline --color=always {}' \
                 --prompt='branch: ' \
           | sed 's/remotes\/origin\///' | tr -d ' *')
  [[ -n "$branch" ]] && git switch "$branch"
}

# gshow — fzf git log browser with diff preview
gshow() {
  git log --oneline --color=always "$@" \
  | fzf --ansi --no-sort --reverse \
        --preview 'git show --color=always {1}' \
        --bind 'enter:execute(git show --color=always {1} | less -R)' \
        --prompt='commit: '
}

# up — go up N directories
up() {
  local n="${1:-1}"
  local d=""
  for ((i=0; i<n; i++)); do d="../$d"; done
  cd "$d" || return
}

# cheat — quick command cheat sheet (requires curl)
cheat() { curl -s "cheat.sh/$1" | ${PAGER:-less} }

# sizeof — human-readable size of a file or dir
sizeof() { du -sh "${1:-.}" | cut -f1 }

# tre — tree with eza (with depth argument)
tre() { eza --icons --tree --level="${1:-2}" "${@:2}" }

# port — what's listening on a port?
port() { lsof -i ":${1}" }

# hidden — toggle hidden files in Finder (macOS only)
if [[ $_os == macos ]]; then
  hidden() {
    local state
    state=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)
    if [[ "$state" == "YES" || "$state" == "true" || "$state" == "1" ]]; then
      defaults write com.apple.finder AppleShowAllFiles NO
      echo "Hidden files: OFF"
    else
      defaults write com.apple.finder AppleShowAllFiles YES
      echo "Hidden files: ON"
    fi
    killall Finder
  }
fi

# ══════════════════════════════════════════════════════════════════
# TOOL INTEGRATIONS
# ══════════════════════════════════════════════════════════════════

# zoxide — smarter cd with frecency
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"  # replaces `cd` with zoxide
fi

# direnv — per-directory environment variables
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi
