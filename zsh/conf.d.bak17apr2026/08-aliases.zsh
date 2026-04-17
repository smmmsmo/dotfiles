# ══════════════════════════════════════════════════════════════════
# Aliases
# ══════════════════════════════════════════════════════════════════
#
# Aliases are organized by category. Each section uses modern CLI
# tool replacements when available, with fallbacks to standard tools.
#
# Design principles:
#   - All tool-replacing aliases are guarded with `command -v` so
#     the config works on systems without those tools installed
#   - Original commands are still accessible via `\command` or
#     `command command` (e.g., \grep for real grep)
#   - Aliases that shadow builtins (rm, cp, mv) add safety flags
#   - Short aliases (g, gs, dk) are for frequently-used commands
#
# To see what an alias expands to: `which <alias>` or `alias <name>`
# ══════════════════════════════════════════════════════════════════

# ── Navigation ───────────────────────────────────────────────────
# Quick directory traversal. Combined with auto_pushd (02-options.zsh),
# every cd pushes to the dir stack. Use `d` to see the stack,
# then type a number (1-9) to jump to that entry.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'          # go back to previous dir
alias d='dirs -v'          # show dir stack (numbered)
for i in {1..9}; do alias "$i"="cd +$i"; done  # 1-9 to jump dir stack

# ── Listing (eza > ls) ───────────────────────────────────────────
# eza is a modern replacement for ls with git integration, icons,
# and tree view. --group-directories-first keeps dirs at the top.
# Install: brew install eza
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --git --group-directories-first --icons=auto'
  alias la='eza -lah --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='eza --tree --level=2 --long --icons --git -a'
else
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lah'
  alias l='ls -CF'
fi

# ── cat > bat ────────────────────────────────────────────────────
# bat adds syntax highlighting and line numbers to file viewing.
# `cat` is aliased to bat without paging (drop-in replacement).
# Use `batp` when you want paged output (scrollable).
# Install: brew install bat
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'               # bat with paging
  alias batp='bat --paging=always'
fi

# ── Modern CLI tool replacements ─────────────────────────────────
# These alias traditional unix tools to modern Rust replacements
# that are faster, have better defaults, and produce nicer output.
#
# ripgrep (rg) — faster grep that respects .gitignore
# Install: brew install ripgrep
if command -v rg &>/dev/null; then
  alias rg='rg --smart-case'          # case-insensitive when pattern is lowercase
  alias rgs='rg --smart-case --hidden' # also search hidden files
fi

# lazygit — interactive git TUI (full staging, rebasing, etc.)
# Install: brew install lazygit
command -v lazygit &>/dev/null && alias lg='lazygit'

# btop — modern system monitor (replaces top/htop)
# Install: brew install btop
command -v btop &>/dev/null && alias top='btop'

# dust — visual disk usage analyzer (replaces du for exploration)
# Note: `du` alias is left alone since scripts depend on it.
# Install: brew install dust
command -v dust &>/dev/null && alias usage='dust'

# procs — modern process viewer with color and search
# Note: `ps` alias is left alone since scripts depend on it.
# Install: brew install procs
command -v procs &>/dev/null && alias psa='procs'

# zoxide shorthands — j/ji as shorter alternatives to cd/cdi
# zoxide is initialized in 10-tools.zsh and replaces cd.
# `j` is a common convention from autojump/z/fasd.
if command -v zoxide &>/dev/null; then
  alias j='cd'       # works because zoxide replaces cd
  alias ji='cdi'     # interactive zoxide (fzf-powered directory picker)
fi

# ══════════════════════════════════════════════════════════════════
# Git Aliases
# ══════════════════════════════════════════════════════════════════
#
# Short aliases for everyday git operations. These follow a
# consistent naming convention:
#   g   = git
#   gs  = git status
#   ga  = git add
#   gc  = git commit
#   gd  = git diff
#   gl  = git log
#   gpu = git pull
#   gps = git push
#
# Some notable choices:
#   - `gpu` uses --rebase --autostash (cleaner history, auto-stashes dirty work)
#   - `gpf` uses --force-with-lease (safer than --force, prevents overwriting
#     someone else's work)
#   - `gwip` creates a timestamped WIP commit for quick saves
#   - `greset` does a SOFT reset (keeps changes staged, not destructive)
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
alias gpu='git pull --rebase --autostash'
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
# Docker Aliases
# ══════════════════════════════════════════════════════════════════
# Short aliases for docker and docker compose. `dkps` formats
# output as a clean table showing only name, status, and ports.
if command -v docker &>/dev/null; then
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
fi

# ══════════════════════════════════════════════════════════════════
# Tmux Aliases
# ══════════════════════════════════════════════════════════════════
# Short aliases for session management. `t` with no args lists
# sessions. `ta` attaches (or creates) a named session. `tks`
# kills a specific session, `tka` kills the entire server.
alias t='tmux ls 2>/dev/null || echo "no sessions"'
alias ta='tmux new-session -A -s'    # attach or create: ta work
alias td='tmux detach'
alias tks='tmux kill-session -t'     # kill one: tks work
alias tka='tmux kill-server'         # kill everything
alias tw='tmux attach || tmux new -s Work'
alias tmuxrc='${EDITOR} ~/.config/tmux/tmux.conf'

# ══════════════════════════════════════════════════════════════════
# Node / npm Aliases
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
# Python Aliases
# ══════════════════════════════════════════════════════════════════
# `venv` creates a .venv in the current directory.
# `activate` finds and activates the nearest virtualenv.
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null'

# ══════════════════════════════════════════════════════════════════
# Misc Aliases (cross-platform)
# ══════════════════════════════════════════════════════════════════
# Safety flags: cp/mv/rm are interactive + verbose by default.
# Use \rm, \cp, \mv to bypass these when you need raw speed.
alias mkdir='mkdir -pv'             # auto-create parents + verbose
alias cp='cp -iv'                   # interactive + verbose
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias du='du -sh'
alias path='echo -e ${PATH//:/\\n}'  # pretty-print PATH

# ── Config editing shortcuts ─────────────────────────────────────
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias zshrc='${EDITOR} ~/.zshrc'
alias nvimrc='${EDITOR} ~/.config/nvim'
alias ghosttyrc='${EDITOR} ~/.config/ghostty/config'
alias starshiprc='${EDITOR} ~/.config/starship.toml'
alias dot='cd ~/GITHUB/dotfiles'
alias hosts='sudo ${EDITOR} /etc/hosts'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# ── Network ──────────────────────────────────────────────────────
alias ip='curl -s https://ipinfo.io/ip'
alias ports='lsof -i -P -n | grep LISTEN'
alias ping='ping -c 5'
command -v wget &>/dev/null && alias wget='wget -c'

# Cross-platform local IP
if [[ $_os == macos ]]; then
  alias localip='ipconfig getifaddr en0'
else
  alias localip='hostname -I | awk "{print \$1}"'
fi

# ── macOS-only ───────────────────────────────────────────────────
if [[ $_os == macos ]]; then
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo "DNS flushed"'
  alias brewup='brew update && brew upgrade && brew cleanup && echo "Homebrew updated"'
fi
