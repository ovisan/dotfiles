eval "$(starship init zsh)"
source <(fzf --zsh)
alias ls="eza"
alias ll="eza -lah"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
alias gp="git push"

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth:erasedups:ignoredups:ignorespace
# removes duplicates from history preserving order each time a terminal is started
awk '!x[$0]++' ~/.zsh_history > ~/.zsh.tmp && mv -f ~/.zsh.tmp ~/.zsh_history

# append to the history file, don't overwrite it
setopt histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=10000000                 # big big history
export HISTFILESIZE=10000000             # big big history
setopt histappend                     # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
alias hs='history | grep '


# History completion"
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
