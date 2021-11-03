# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set the location of the configuration folder
CONFIG_DIR=$HOME/.myConfig

HISTFILESIZE=5000000000
HISTSIZE=5000000000
# Avoid duplicates
HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

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
PS1='\D{%m%d-%H%M}:${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(mpwd | shorten_dir_name)\[\033[00m\]\$ '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# PS1="${debian_chroot:+($debian_chroot)}\u@\h:\$(~/Documents/Programmation/Scripts/mpwd.sh | ~/Documents/Programmation/Scripts/shortPwd)\$ "
PATH=~/.local/bin:~/bin:$PATH:$CONFIG_DIR/scripts

# Homebrew stuff
export PATH=$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH

# Mac OS stuff
export PATH=$HOME/Library/Python/3.6/bin:$PATH

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
  if [[ -r $f ]]; then
    source $f
  else
    echo "Cannot source $f: file is not readable."
  fi
done

# Vim super-power mode
set -o vi

# Otherwise the sorting order can be wrong when sorting numbers.
# export LC_ALL=C

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# For CUDA
# (http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cudnn/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# This was necessary to build the cuda samples, but it might be a problem with
# the samples themselves, I'm not sure it's needed for other programs.
# export LIBRARY_PATH=/usr/lib/nvidia-375:$LIBRARY_PATH
# This one is not supposed to be needed, it's only for the installation that
# uses a run.sh file instead of the .deb file (I used the .deb).
# export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# To ensure that iPython works in a virtualenv:
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use neovim if installed.
# if type nvim > /dev/null 2>&1; then
    # alias vim='nvim'
# fi
