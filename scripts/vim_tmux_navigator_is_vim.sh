#!/bin/bash

# Workaround for issue https://github.com/christoomey/vim-tmux-navigator/issues/195
# where vim is running in a subshell.
#
# Usage: Update vim-tmux-navigator config in .tmux.conf with:
# is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
#    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$' \
#    || vim-tmux-navigator-is-vim.sh #{pane_tty}"

tmux_pane_tty=$1
found_vim=0

find_vim_in_child_processes() {
    read state pid comm < <(ps -o state= -o pid= -o comm= --ppid $1)
    [ $? -eq 0 ] || return 1    # ps exit code 1, no child process

    echo $state | grep -qE '^[TXZ]' && return 1

    echo $comm | grep -iqE '(\S+\/)?g?(view|n?vim?x?)(diff)?$'
    if [ $? -eq 0 ]; then
        found_vim=1
        return 0
    fi
    find_vim_in_child_processes $pid
}

# Get processes running in tty $tmux_pane_tty and recursively try to find vim
# in a child process.
while [ $found_vim -eq 0 ] && read state pid
do
    find_vim_in_child_processes $pid
done < <(ps -o state= -o pid= -t $tmux_pane_tty | grep -E '^[^TXZ ]')

[ $found_vim -eq 1 ]
exit $?
