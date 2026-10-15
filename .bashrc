# ~/.bashrc — bash counterpart of ~/.zshrc
# Safe to copy to a Linux server. Each modern tool is used only when it
# is installed; otherwise the plain command stays in place.
# Login shells load this via ~/.bash_profile (which also loads ~/.profile).

# Re-source with `reload`. A second accidental source returns here.
if [[ -n "${DOTFILES_BASHRC_LOADED:-}" && -z "${DOTFILES_BASHRC_RELOAD:-}" ]]; then
  return
fi
DOTFILES_BASHRC_LOADED=1

_have() {
  command -v "$1" >/dev/null 2>&1
}

# --------------------------------------------------
# 1. Homebrew (Apple Silicon + Intel). No-op on Linux.
# --------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --------------------------------------------------
# 2. Environment
# --------------------------------------------------
if _have nvim; then
  export EDITOR=nvim
  export VISUAL=nvim
elif _have vim; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=vi
  export VISUAL=vi
fi

if _have bat; then
  export PAGER=bat
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
else
  [[ "${PAGER:-}" == bat ]] && export PAGER=less
  unset MANPAGER MANROFFOPT
fi

# Only force a locale the machine actually has.
if locale -a 2>/dev/null | grep -qiE '^en_US\.(utf-?8)$'; then
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
fi

export LESS='-R -F -X -i -j.5'
[[ -f "$HOME/.ripgreprc" ]] && export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
[[ -f "$HOME/.config/bat/config" ]] && export BAT_CONFIG_PATH="$HOME/.config/bat/config"
_have eza && export EZA_ICON_SPACING=2
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# rustup (zsh loads this from ~/.zprofile)
if [[ -f "$HOME/.cargo/env" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

# Move dir to the front of PATH and drop duplicates (safe to reload).
_path_prepend() {
  local dir=$1 entry result="" old_ifs=$IFS
  [[ -d "$dir" ]] || return 0
  result="$dir"
  IFS=':'
  for entry in $PATH; do
    [[ -z "$entry" || "$entry" == "$dir" ]] && continue
    result="${result}:${entry}"
  done
  IFS=$old_ifs
  PATH="$result"
}

# grok installer
_path_prepend "$HOME/.grok/bin"

# bun
if [[ -d "$HOME/.bun" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  _path_prepend "$BUN_INSTALL/bin"
fi
unset -f _path_prepend

# --------------------------------------------------
# Interactive only from here
# --------------------------------------------------
case $- in
  *i*) ;;
  *)
    unset DOTFILES_BASHRC_RELOAD
    return
    ;;
esac

# --------------------------------------------------
# 3. Options (zsh setopt equivalents that bash can express)
# --------------------------------------------------
# AUTO_CD, directory spelling. Bash has no command-spelling CORRECT.
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
  shopt -s autocd dirspell globstar
fi
shopt -s checkwinsize cdspell extglob interactive_comments
shopt -s histappend cmdhist lithist histverify

# History size and sharing. erasedups ≈ HIST_IGNORE_ALL_DUPS.
HISTSIZE=200000
HISTFILESIZE=200000
HISTFILE="${HOME}/.bash_history"
HISTCONTROL=ignorespace:erasedups
HISTTIMEFORMAT='%F %T '

# NO_BEEP, case-insensitive menu completion
bind 'set bell-style none' 2>/dev/null || true
bind 'set completion-ignore-case on' 2>/dev/null || true
bind 'set show-all-if-ambiguous on' 2>/dev/null || true
bind 'set mark-symlinked-directories on' 2>/dev/null || true
bind 'set skip-completed-text on' 2>/dev/null || true
bind 'set colored-stats on' 2>/dev/null || true
bind 'set colored-completion-prefix on' 2>/dev/null || true

# --------------------------------------------------
# 4. Prompt tools and fzf
# --------------------------------------------------
if _have fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif _have fdfind; then
  # Debian/Ubuntu package name
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.git/*"'
  export FZF_ALT_C_COMMAND='find . -type d -not -path "*/.git/*"'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza -la --icons {} 2>/dev/null || ls -la {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons {} 2>/dev/null || ls -la {}'"

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

_dotfiles_load_fzf() {
  local dir loaded=0
  _have fzf || return 0
  if fzf --bash >/dev/null 2>&1; then
    eval "$(fzf --bash)"
    return 0
  fi
  for dir in /usr/share/fzf /usr/share/fzf/shell /usr/share/doc/fzf/examples "$HOME/.fzf/shell"; do
    if [[ -r "$dir/key-bindings.bash" ]]; then
      # shellcheck disable=SC1091
      source "$dir/key-bindings.bash"
      if [[ -r "$dir/completion.bash" ]]; then
        # shellcheck disable=SC1091
        source "$dir/completion.bash"
      fi
      loaded=1
      break
    fi
  done
  if [[ "$loaded" -eq 0 && -r "$HOME/.fzf.bash" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/.fzf.bash"
  fi
}
_dotfiles_load_fzf

# --------------------------------------------------
# 5. Aliases — better defaults
# --------------------------------------------------
# Listing. eza when present; GNU or BSD ls otherwise.
if _have eza; then
  alias ls='eza --icons --group-directories-first'
  # -la so hidden files show (e.g. pure-dotfile dirs like this repo root)
  alias ll='eza -la --icons --group-directories-first --git --header'
  alias la='eza -la --icons --group-directories-first --git --header'
  alias lt='eza --tree --level=2 --icons --group-directories-first'
  alias lta='eza --tree --level=3 --icons -a --group-directories-first'
  alias lll='eza -la --icons --group-directories-first --git --header --total-size'
else
  if command ls --color=auto -d . >/dev/null 2>&1; then
    alias ls='ls --color=auto'
  elif command ls -G -d . >/dev/null 2>&1; then
    alias ls='ls -G'
  fi
  alias ll='ls -alF'
  alias la='ls -A'
  alias lt='ls -R'
fi

# Fuzzy-find a file and open it in $EDITOR
_have fzf && alias fe='fzf --bind "enter:become($EDITOR {})"'

# Core tools
if _have bat; then
  alias cat='bat --style=plain --paging=never'
  alias batp='bat --paging=always'
fi
if _have fd; then
  alias find='fd'
elif _have fdfind; then
  alias find='fdfind'
fi
_have rg && alias grep='rg'
_have btop && alias top='btop'
_have dust && alias du='dust'
if _have nvim; then
  alias vim='nvim'
  alias vi='nvim'
  alias v='nvim'
fi

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
_have lazygit && alias lg='lazygit'

# Files / explorers
if _have yazi; then
  alias y='yazi'
  alias yy='yazi'
  alias ranger='yazi'   # muscle-memory redirect
fi

# Multiplexers
alias t='tmux'
alias ta='tmux attach || tmux new'
alias tn='tmux new -s'
alias tl='tmux ls'
if _have zellij; then
  alias zj='zellij'
  alias za='zellij attach -c'
fi

# Containers / k8s (if present)
_have podman && alias docker='podman'
_have kubectl && alias k='kubectl'

# System
alias reload='DOTFILES_BASHRC_RELOAD=1 source ~/.bashrc'
alias bashconfig='$EDITOR ~/.bashrc'
alias zshconfig='$EDITOR ~/.zshrc'
_have brew && alias brewup='brew update && brew upgrade && brew cleanup'
alias path='echo $PATH | tr ":" "\n"'
if _have lsof; then
  if _have rg; then
    alias ports='lsof -i -P | rg LISTEN'
  else
    alias ports='lsof -i -P | grep LISTEN'
  fi
fi
alias myip='curl -s ifconfig.me && echo'
localip() {
  if [[ "$(uname -s)" == Darwin ]]; then
    ipconfig getifaddr en0
    return
  fi
  if hostname -I >/dev/null 2>&1; then
    hostname -I | awk '{print $1}'
    return
  fi
  ip -4 addr show scope global 2>/dev/null | awk '/inet / {print $2; exit}'
}
alias c='clear'
alias h='history'
alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
o() {
  if [[ "$(uname -s)" == Darwin ]]; then
    open "${1:-.}"
  elif _have xdg-open; then
    xdg-open "${1:-.}"
  else
    echo "no opener for ${1:-.}" >&2
    return 1
  fi
}
if [[ "$(uname -s)" == Darwin ]]; then
  alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
  alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
fi
alias week='date +%V'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# --------------------------------------------------
# 6. Key bindings
# --------------------------------------------------
set -o emacs
bind '"\e[A": history-search-backward' 2>/dev/null || true
bind '"\e[B": history-search-forward' 2>/dev/null || true
bind '"\e[1;5C": forward-word' 2>/dev/null || true
bind '"\e[1;5D": backward-word' 2>/dev/null || true
bind '"\e[H": beginning-of-line' 2>/dev/null || true
bind '"\e[F": end-of-line' 2>/dev/null || true
bind '"\e[3~": delete-char' 2>/dev/null || true
bind '"\C-u": unix-line-discard' 2>/dev/null || true

# --------------------------------------------------
# 7. Functions
# --------------------------------------------------
# zsh AUTO_PUSHD + PUSHD_IGNORE_DUPS + PUSHD_SILENT
_dotfiles_auto_pushd() {
  local before=$1 entry
  [[ "$PWD" == "$before" ]] && return 0
  for entry in "${DIRSTACK[@]}"; do
    [[ "$entry" == "$before" ]] && return 0
  done
  builtin pushd -n -- "$before" >/dev/null || true
}

mkcd() {
  command mkdir -p "$1" && cd "$1"
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
    cwd="$(command cat -- "$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
  fi
}
_have yazi && alias yc='yazi-cd'

# Fuzzy project switcher under ~/code
proj() {
  local dir preview='ls -la {}'
  _have fzf || return 1
  if _have eza; then
    preview='eza -la --icons {}'
  fi
  if _have fd; then
    dir=$(fd --type d --max-depth 2 --min-depth 1 . "$HOME/code" 2>/dev/null | fzf --preview "$preview")
  elif _have fdfind; then
    dir=$(fdfind --type d --max-depth 2 --min-depth 1 . "$HOME/code" 2>/dev/null | fzf --preview "$preview")
  else
    dir=$(find "$HOME/code" -mindepth 1 -maxdepth 2 -type d 2>/dev/null | fzf --preview "$preview")
  fi
  [[ -n "$dir" ]] && cd "$dir"
}

# Quick note
note() {
  command mkdir -p "$HOME/notes"
  echo "$*" >> "$HOME/notes/$(date +%Y-%m-%d).md"
}

# --------------------------------------------------
# 8. Completions
# --------------------------------------------------
# Homebrew bash-completion, then the usual Linux paths.
# Snippets in those dirs often need Bash 4 (for example `complete -o nosort`).
_dotfiles_source_completion() {
  [[ ${BASH_VERSINFO[0]} -ge 4 ]] || return 0
  local f
  local -a candidates=()
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    candidates+=(
      "${HOMEBREW_PREFIX}/share/bash-completion/bash_completion"
      "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    )
  fi
  candidates+=(
    /opt/homebrew/share/bash-completion/bash_completion
    /usr/local/share/bash-completion/bash_completion
    /usr/share/bash-completion/bash_completion
    /opt/homebrew/etc/profile.d/bash_completion.sh
    /usr/local/etc/profile.d/bash_completion.sh
    /etc/bash_completion
    /usr/share/bash-completion/bash_completion.sh
  )
  for f in "${candidates[@]}"; do
    if [[ -r "$f" ]]; then
      # shellcheck disable=SC1090
      source "$f"
      return 0
    fi
  done
}
_dotfiles_source_completion

if [[ -r "${HOME}/.grok/completions/bash/grok.bash" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.grok/completions/bash/grok.bash"
fi

# --------------------------------------------------
# 9. Prompt, zoxide, shared history
# zoxide stays on PROMPT_COMMAND; starship runs first so it still sees $?.
# --------------------------------------------------
if _have starship; then
  eval "$(starship init bash)"
fi

# zsh-autosuggestions and zsh-syntax-highlighting are zsh-only.
# ble.sh is the bash equivalent; load it when it is installed.
for _ble in \
  "${HOMEBREW_PREFIX:-}/share/blesh/ble.sh" \
  /opt/homebrew/share/blesh/ble.sh \
  /usr/share/blesh/ble.sh \
  "${HOME}/.local/share/blesh/ble.sh"
do
  if [[ -f "$_ble" ]]; then
    # shellcheck disable=SC1090
    source "$_ble"
    break
  fi
done
unset _ble

_dotfiles_history_sync() {
  history -a
  history -n
}

_dotfiles_prompt_append() {
  local fn=$1 item current
  if [[ "$(declare -p PROMPT_COMMAND 2>/dev/null)" == declare\ -a* ]]; then
    for item in "${PROMPT_COMMAND[@]}"; do
      [[ "$item" == "$fn" ]] && return 0
    done
    PROMPT_COMMAND+=("$fn")
    return 0
  fi
  current="${PROMPT_COMMAND-}"
  case ";${current};" in
    *";${fn};"*) return 0 ;;
  esac
  if [[ -z "$current" ]]; then
    PROMPT_COMMAND="$fn"
  else
    PROMPT_COMMAND="${current};${fn}"
  fi
}

if _have zoxide; then
  eval "$(zoxide init bash --cmd cd)"
  __zoxide_cd() {
    local before=$PWD
    builtin cd -- "$@" || return
    _dotfiles_auto_pushd "$before"
  }
else
  cd() {
    local before=$PWD
    builtin cd -- "$@" || return
    _dotfiles_auto_pushd "$before"
  }
fi

_dotfiles_prompt_append _dotfiles_history_sync
unset DOTFILES_BASHRC_RELOAD

# --------------------------------------------------
# End of .bashrc
# --------------------------------------------------
