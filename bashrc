# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set the location of the configuration folder
CONFIG_DIR=$HOME/.myConfig

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
export PROMPT_COMMAND="history -a; history -r"
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# Set the prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(mpwd | shorten_dir_name)\[\033[00m\]\$ '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# PS1="${debian_chroot:+($debian_chroot)}\u@\h:\$(~/Documents/Programmation/Scripts/mpwd.sh | ~/Documents/Programmation/Scripts/shortPwd)\$ "
PATH=~/bin:$PATH:$CONFIG_DIR/scripts

# alias for doing a recursive grep in C source
alias cgr="find . -name '*.h' -or -name '*.c' -or -name '*.cpp' -or -name '*.cc' | xargs grep --color "

alias h?="history | grep"

# Source highlighting in less
alias source-hilight="source-hilight --style-file=/usr/share/source-ghighlight/esc.style"
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '


export EDITOR=vim

# other files
for f in  $(ls ~/.myConfig/bash_custom*); do
  source $f
done

# Size of the history
HISTFILESIZE=20000000
HISTSIZE=20000000
# Ignore commands that start with a space and duplicate commands in the history
HISTIGNORE="&:[ ]*:exit"

# Vim super-power mode
set -o vi

# Otherwise the sorting order can be wrong when sorting numbers.
export LC_ALL=C

# f(){ if [ "$PWD" != "$LPWD" ];then LPWD="$PWD"; tmux rename-window ${PWD//*\//}; fi }; export PROMPT_COMMAND=f;

