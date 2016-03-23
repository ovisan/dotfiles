# Setting the name for screen compatibility
# export PATH=${PATH}:${HOME}/go/bin

test -s ~/.alias && . ~/.alias || true
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth:erasedups:ignoredups:ignorespace
# removes duplicates from history preserving order each time a terminal is started
awk '!x[$0]++' .bash_history > .bash.tmp && mv -f .bash.tmp .bash_history

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#docker aliases
alias dockerStopAll='docker stop $(docker ps -a -q)'
alias dockerClean='docker rm $(docker ps -a -q)'
alias dockerCleanDanglingVolumes='docker volume rm $(docker volume ls -qf dangling=true)'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#sound alias
alias vol='pavucontrol'

#gopath and bin to PATH alias
alias gp='export GOPATH=$(pwd) && export PATH=$PATH:$GOPATH/bin && go get -u github.com/nsf/gocode'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=10000000                 # big big history
export HISTFILESIZE=10000000             # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
alias hs='history | grep '
alias install='sudo zypper install '

# History completion"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

setxkbmap -option caps:none

#w$(parse_git_branch) Add git branch if its present to PS1
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1='\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\w $(parse_git_branch)]:\[\e[0m\]\[\e[00;37m\] \[\e[0m\]'

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
PATH=/usr/local/terraform:/home/dev/terraform:$PATH
