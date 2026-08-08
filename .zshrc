# --------------------------------------------------
# 1. Basic Options
# --------------------------------------------------
setopt AUTO_CD                  # Type directory name to cd into it
setopt AUTO_PUSHD               # Make cd push the old directory onto the stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt CORRECT
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# History size
HISTSIZE=200000
SAVEHIST=200000
HISTFILE=~/.zsh_history

# --------------------------------------------------
# 2. Homebrew (Apple Silicon + Intel)
# --------------------------------------------------
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Homebrew zsh completions
if [[ -d ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions ]]; then
  fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" $fpath)
fi
if [[ -d ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-completions ]]; then
  fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
# Homebrew often leaves share/ group-writable → "insecure directories" from compinit.
# Strip group/other write so completions load without the warning/prompt.
if [[ -d ${HOMEBREW_PREFIX:-/opt/homebrew}/share ]]; then
  chmod -f g-w,o-w "${HOMEBREW_PREFIX:-/opt/homebrew}/share" 2>/dev/null || true
fi
# Speed up compinit: full rebuild at most once a day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*' squeeze-slashes true

# --------------------------------------------------
# 3. Environment
# --------------------------------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='bat'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT='-c'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-R -F -X -i -j.5'
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export BAT_CONFIG_PATH="$HOME/.config/bat/config"
export EZA_ICON_SPACING=2
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --------------------------------------------------
# 4. Modern CLI tools
# --------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# --------------------------------------------------
# 5. Catppuccin Mocha colors for fzf
# --------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza -la --icons {} 2>/dev/null'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons {} 2>/dev/null'"

export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='◆'
  --marker='✓'
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --color=border:#6c7086,label:#cdd6f4
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-a:select-all'
  --bind='ctrl-d:deselect-all'
  --preview-window=right:50%:wrap
"

# --------------------------------------------------
# 6. Aliases — better defaults
# --------------------------------------------------
# Listing
alias ls='eza --icons --group-directories-first'
# -la so hidden files show (e.g. pure-dotfile dirs like this repo root)
alias ll='eza -la --icons --group-directories-first --git --header'
alias la='eza -la --icons --group-directories-first --git --header'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias lta='eza --tree --level=3 --icons -a --group-directories-first'
alias lll='eza -la --icons --group-directories-first --git --header --total-size'

# Fuzzy-find a file and open it in $EDITOR
alias fe='fzf --bind "enter:become($EDITOR {})"'

# Core tools
alias cat='bat --style=plain --paging=never'
alias batp='bat --paging=always'
alias find='fd'
alias grep='rg'
alias top='btop'
alias du='dust'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias d='dirs -v'

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gll='git log --oneline --graph --decorate --all -40'
alias lg='lazygit'

# Files / explorers
alias y='yazi'
alias yy='yazi'
alias ranger='yazi'   # muscle-memory redirect

# Multiplexers
alias t='tmux'
alias ta='tmux attach || tmux new'
alias tn='tmux new -s'
alias tl='tmux ls'
alias zj='zellij'
alias za='zellij attach -c'

# Containers / k8s (if present)
command -v podman >/dev/null && alias docker='podman'
command -v kubectl >/dev/null && alias k='kubectl'

# System
alias reload='source ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'
alias brewup='brew update && brew upgrade && brew cleanup'
alias path='echo $PATH | tr ":" "\n"'
alias ports='lsof -i -P | rg LISTEN'
alias myip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'
alias c='clear'
alias h='history'
alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias o='open .'
alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias week='date +%V'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# --------------------------------------------------
# 7. Autosuggestions + syntax highlighting
# --------------------------------------------------
if [[ -f ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Must be last among plugins that wrap widgets
if [[ -f ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --------------------------------------------------
# 8. Key bindings
# --------------------------------------------------
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^U' backward-kill-line

# --------------------------------------------------
# 9. Functions
# --------------------------------------------------
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [[ ! -f "$1" ]]; then
    echo "'$1' is not a valid file"
    return 1
  fi
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.xz)             unxz "$1" ;;
    *.zip)            unzip "$1" ;;
    *.7z)             7z x "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.Z)              uncompress "$1" ;;
    *)                echo "'$1' cannot be extracted" ;;
  esac
}

# Yazi with cwd change on quit
yazi-cd() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if [[ -f "$tmp" ]]; then
    local cwd
    cwd="$(cat -- "$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
}
alias yc='yazi-cd'

# Fuzzy project switcher under ~/code
proj() {
  local dir
  dir=$(fd --type d --max-depth 2 --min-depth 1 . "$HOME/code" 2>/dev/null | fzf --preview 'eza -la --icons {}')
  [[ -n "$dir" ]] && cd "$dir"
}

# Quick note
note() {
  mkdir -p "$HOME/notes"
  echo "$*" >> "$HOME/notes/$(date +%Y-%m-%d).md"
}

# --------------------------------------------------
# End of .zshrc
# --------------------------------------------------
