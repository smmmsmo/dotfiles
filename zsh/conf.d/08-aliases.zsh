# ══════════════════════════════════════════════════════════════════
# Aliases
# ══════════════════════════════════════════════════════════════════
#
# All tool-replacing aliases are guarded with `command -v` so the
# config degrades gracefully when a tool isn't installed.
# Bypass any alias with a leading backslash: \ls, \grep, \rm

# ── Navigation ───────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias d='dirs -v'
for i in {1..9}; do alias "$i"="cd +$i"; done

# ── Listing (eza > ls) ───────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh  --git --group-directories-first --icons=auto'
  alias la='eza -lah --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='eza --tree --level=2 --long --icons --git -a'
  alias l='eza -1 --group-directories-first'   # single-column quick list
else
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lah'
  alias l='ls -CF'
fi

# ── cat → bat ────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'
  alias batp='bat --paging=always'
fi

# ── grep → ripgrep ───────────────────────────────────────────────
if command -v rg &>/dev/null; then
  alias rg='rg --smart-case'
  alias rgs='rg --smart-case --hidden'
  alias rgl='rg --smart-case -l'    # list matching files only
fi

# ── Modern CLI replacements ───────────────────────────────────────
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v btop    &>/dev/null && alias top='btop'
command -v dust    &>/dev/null && alias usage='dust'
command -v procs   &>/dev/null && alias psa='procs'
command -v delta   &>/dev/null && alias diff='delta'
command -v duf     &>/dev/null && alias df='duf'     # duf is nicer than df -h
command -v tldr    &>/dev/null && alias help='tldr'  # concise man pages

# ── zoxide shorthands ────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
  alias j='cd'
  alias ji='cdi'
fi

# ══════════════════════════════════════════════════════════════════
# Git
# ══════════════════════════════════════════════════════════════════
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'          # interactive hunk staging
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcam='git commit --amend'
alias gd='git diff'
alias gds='git diff --staged'
alias gdc='git diff HEAD~1'          # diff vs previous commit
alias gl='git log --oneline --decorate --graph --all'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gpu='git pull --rebase --autostash'
alias gps='git push'
alias gpf='git push --force-with-lease'
alias gpsu='git push --set-upstream origin HEAD'  # push new branch + set upstream
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsts='git stash show -p'       # show stash diff
alias gf='git fetch --all --prune'
alias gm='git merge --no-ff'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gcp='git cherry-pick'
alias greset='git reset --soft HEAD~1'
alias gclean='git clean -fd'
alias gwip='git add -A && git commit -m "WIP: $(date +%H:%M)"'
alias gunwip='git log -n 1 --format="%s" | grep -q "^WIP" && git reset HEAD~1'
alias gbD='git branch -D'            # force-delete a local branch
alias gprune='git remote prune origin'  # clean up stale remote-tracking branches

# ══════════════════════════════════════════════════════════════════
# Docker
# ══════════════════════════════════════════════════════════════════
if command -v docker &>/dev/null; then
  alias dk='docker'
  alias dkc='docker compose'
  alias dkcu='docker compose up -d'
  alias dkcd='docker compose down'
  alias dkcr='docker compose restart'
  alias dkcl='docker compose logs -f'
  alias dkps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dkpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dkim='docker images'
  alias dkrm='docker rm'
  alias dkrmi='docker rmi'
  alias dkprune='docker system prune -af --volumes'
  alias dkexec='docker exec -it'     # quickly exec into a container
fi

# ══════════════════════════════════════════════════════════════════
# Tmux
# ══════════════════════════════════════════════════════════════════
alias t='tmux ls 2>/dev/null || echo "no sessions"'
alias ta='tmux new-session -A -s'
alias td='tmux detach'
alias tks='tmux kill-session -t'
alias tka='tmux kill-server'
alias tw='tmux attach || tmux new -s Work'
alias tmuxrc='${EDITOR} ~/.config/tmux/tmux.conf'

# ══════════════════════════════════════════════════════════════════
# Node / npm
# ══════════════════════════════════════════════════════════════════
alias ni='npm install'
alias nid='npm install --save-dev'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'
alias nrw='npm run watch'

# ══════════════════════════════════════════════════════════════════
# Python
# ══════════════════════════════════════════════════════════════════
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null'
alias ipy='python3 -m IPython 2>/dev/null || python3'  # IPython with fallback

# ══════════════════════════════════════════════════════════════════
# Safety & filesystem
# ══════════════════════════════════════════════════════════════════
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
# duf replaces df when available (handled above); keep du for scripts
alias du='du -sh'
alias path='echo -e ${PATH//:/\\n}'
alias sz='du -sh * | sort -rh | head -20'  # top-20 sizes in current dir

# ── Config shortcuts ──────────────────────────────────────────────
alias reload='source ~/.zshrc && echo "✓ zshrc reloaded"'
alias zshrc='${EDITOR} ~/.zshrc'
alias nvimrc='${EDITOR} ~/.config/nvim'
alias ghosttyrc='${EDITOR} ~/.config/ghostty/config'
alias starshiprc='${EDITOR} ~/.config/starship.toml'
alias dot='cd ~/GITHUB/dotfiles'
alias hosts='sudo ${EDITOR} /etc/hosts'
if command -v bat &>/dev/null; then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
else
  alias ff="fzf --preview 'cat {}'"
fi

# ── Network ──────────────────────────────────────────────────────
alias ip='curl -s https://ipinfo.io/ip'
alias ports='lsof -i -P -n | grep LISTEN'
alias ping='ping -c 5'
command -v wget &>/dev/null && alias wget='wget -c'

if [[ $_os == macos ]]; then
  alias localip='ipconfig getifaddr en0'
else
  alias localip='hostname -I | awk "{print \$1}"'
fi

# ── macOS ─────────────────────────────────────────────────────────
if [[ $_os == macos ]]; then
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo "DNS flushed"'
  alias brewup='brew update && brew upgrade && brew cleanup && echo "Homebrew updated"'
  alias brewdump='brew bundle dump --force --file=~/GITHUB/dotfiles/Brewfile && echo "Brewfile updated"'
  alias show='open .'            # reveal current dir in Finder
  alias hide='chflags hidden'    # hide a file from Finder: hide myfile
  alias unhide='chflags nohidden'
fi
