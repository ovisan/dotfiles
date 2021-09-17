export EDITOR='vim'

set -x SKIM_DEFAULT_OPTIONS
# enable color support of ls and also add handy aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# History completion"
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'
# keybindings for history autocomplete

alias hs='history | grep '
# alias ll='ls -lah'
alias ll='lsd -lah'
alias ls='lsd'

# git aliases
alias gs='git status '
alias ga='git add '
alias gp='git push '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gck='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gaddf='git diff-tree --no-commit-id --name-only -r '

alias got='git '
alias get='git '

