eval "$(starship init zsh)"
source <(fzf --zsh)
alias ls="eza"
alias ll="eza -lah"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
alias gp="git push"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000

HISTFILE=~/.zsh_history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=10000000                 # big big history
export HISTFILESIZE=10000000             # big big history
setopt appendhistory                     # append to history, don't overwrite it
setopt SHARE_HISTORY

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
alias hs='history | grep '


# History completion"
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
