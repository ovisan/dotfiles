# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion  ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export HISTCONTROL=ignoreboth:erasedups:ignoredups:ignorespace # no duplicate entries
export HISTSIZE=10000000                 # big big history
export HISTFILESIZE=10000000             # big big history

# removes duplicates from history preserving order each time a terminal is started
awk '!x[$0]++' .bash_history > .bash.tmp && mv -f .bash.tmp .bash_history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# History completion"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias hs='history | grep '

#w$(parse_git_branch) Add git branch if its present to PS1
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1='\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\w $(parse_git_branch)]:\[\e[0m\]\[\e[00;37m\] \[\e[0m\]'
