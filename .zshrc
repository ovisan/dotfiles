# --------------------------------------------------
# 1. Basic Options
# --------------------------------------------------
setopt AUTO_CD                  # Type directory name to cd into it
setopt HIST_IGNORE_DUPS         # Don't save duplicate history entries
setopt HIST_IGNORE_SPACE        # Don't save commands that start with space
setopt SHARE_HISTORY            # Share history between sessions
setopt EXTENDED_HISTORY         # Save timestamp + duration
setopt HIST_VERIFY              # Show command before executing from history
setopt CORRECT                  # Autocorrect commands
setopt NO_BEEP                  # Disable terminal beep

# History size
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# --------------------------------------------------
# 2. Homebrew (Apple Silicon + Intel support)
# --------------------------------------------------
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --------------------------------------------------
# 3. Modern CLI Tools Integration
# --------------------------------------------------

# Starship prompt (must be near the top)
eval "$(starship init zsh)"

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder)
if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# --------------------------------------------------
# 4. Better Defaults for Common Commands
# --------------------------------------------------

# Use eza instead of ls
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git'
alias la='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=3 --icons -a'

# Use bat instead of cat
alias cat='bat --style=plain --paging=never'
alias batp='bat --paging=always'

# Use fd instead of find
alias find='fd'

# Use ripgrep instead of grep
alias grep='rg'

# Better top
alias top='btop'

# --------------------------------------------------
# 5. Useful Productivity Aliases
# --------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

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
alias gl='git log --oneline --graph --decorate -20'
alias lg='lazygit'

# System
alias reload='source ~/.zshrc'
alias zshconfig='code ~/.zshrc'          # or 'nano ~/.zshrc' / 'cursor ~/.zshrc'
alias brewup='brew update && brew upgrade && brew cleanup'
alias path='echo $PATH | tr ":" "\n"'
alias ports='lsof -i -P | grep LISTEN'
alias myip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'

# File operations
alias c='clear'
alias h='history'
alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Quick open
alias o='open .'
alias show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# --------------------------------------------------
# 6. fzf Advanced Configuration
# --------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza --tree --level=2 {} 2>/dev/null'
  --preview-window=right:50%:wrap
  --bind 'ctrl-/:toggle-preview'
"

# --------------------------------------------------
# 7. Environment Variables
# --------------------------------------------------
export EDITOR='code'          # or 'cursor', 'nvim', 'nano'
export VISUAL="$EDITOR"
export PAGER='bat'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Make less better
export LESS='-R -F -X'

# --------------------------------------------------
# 8. Optional: Oh My Zsh plugins (lightweight)
# --------------------------------------------------
# Uncomment the next lines if you use Oh My Zsh
# export ZSH="$HOME/.oh-my-zsh"
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# Manual autosuggestions + syntax highlighting (recommended, faster)
# Install first: brew install zsh-autosuggestions zsh-syntax-highlighting
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --------------------------------------------------
# 9. Key Bindings
# --------------------------------------------------
bindkey '^[[A' history-search-backward   # Up arrow
bindkey '^[[B' history-search-forward    # Down arrow
bindkey '^[[1;5C' forward-word           # Ctrl + Right
bindkey '^[[1;5D' backward-word          # Ctrl + Left

# --------------------------------------------------
# 10. Custom Functions
# --------------------------------------------------

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick note
note() {
  echo "$*" >> ~/notes/$(date +%Y-%m-%d).md
}

# --------------------------------------------------
# End of .zshrc
# --------------------------------------------------
