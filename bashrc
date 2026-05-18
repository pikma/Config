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
PS1='\D{%m%d-%H%M}:${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(mpwd | $CONFIG_DIR/scripts/shorten_dir_name.sh)\[\033[00m\]\$ '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# PS1="${debian_chroot:+($debian_chroot)}\u@\h:\$(~/Documents/Programmation/Scripts/mpwd.sh | ~/Documents/Programmation/Scripts/shortPwd)\$ "
PATH=~/.local/bin:~/bin:~/.cargo/bin:$PATH:$CONFIG_DIR/scripts

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

if $(which nvim > /dev/null); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Counts the number of directory components in a path.
# e.g., "foo/bar" -> 2, "foo" -> 1, "." -> 0, "" -> 0.
_tmux_count_path_components() {
  local path="$1"
  if [[ "$path" == "." || -z "$path" ]]; then
    echo 0
    return
  fi
  # Strip leading/trailing slashes to avoid empty parts
  path=${path#/}
  path=${path%/}
  local IFS='/'
  local -a parts
  read -r -a parts <<< "$path"
  echo "${#parts[@]}"
}

# Extracts the last N components from a path.
# e.g., "/a/b/c/d" with N=2 -> "c/d".
_tmux_extract_path_suffix() {
  local path="$1"
  local n="$2"
  local suffix=""
  while [[ $n -gt 0 ]]; do
    local base
    base=$(basename "$path")
    path=$(dirname "$path")
    if [[ -z "$suffix" ]]; then
      suffix="$base"
    else
      suffix="$base/$suffix"
    fi
    ((n--))
  done
  echo "$suffix"
}

# Extracts the prefix of a path by removing the last N components.
# e.g., "/a/b/c/d" with N=2 -> "/a/b".
_tmux_extract_path_prefix() {
  local path="$1"
  local n="$2"
  while [[ $n -gt 0 ]]; do
    path=$(dirname "$path")
    ((n--))
  done
  echo "$path"
}

# Helper to detect Git repository.
# Args:
#   $1: Absolute canonical directory path.
# Outputs:
#   Line 1: Git repo root path.
#   Line 2: Git repo display name.
_tmux_get_repo_git() {
  local dir="$1"
  local git_root
  git_root=$(cd "$dir" && git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$git_root" ]]; then
    echo "$git_root"
    echo "$(basename "$git_root")"
  fi
}

# Default repository detector (Git only for home).
# Can be overridden by work configuration.
# Output Format:
#   Line 1: Absolute path to the repository root.
#   Line 2: Display name of the repository.
#   (Empty if not in a repository).
_tmux_get_repo() {
  _tmux_get_repo_git "$1"
}

# Calculates the tmux window name based on the current directory and repository status.
# Preserves symlinks.
# Args:
#   $1: Optional unresolved PWD (defaults to $PWD).
#   $2: Optional canonical PWD (defaults to realpath of $1).
# Outputs:
#   The calculated tmux window name.
_tmux_get_window_name() {
  local pwd_unresolved="${1:-$PWD}"
  local pwd_canonical="${2:-$(realpath "$pwd_unresolved")}"

  # Detect repository using the (possibly overridden) helper
  local repo_info
  repo_info=$(_tmux_get_repo "$pwd_canonical")

  local repo_root=""
  local repo_name=""
  if [[ -n "$repo_info" ]]; then
    local -a info_parts
    mapfile -t info_parts <<< "$repo_info"
    repo_root="${info_parts[0]}"
    repo_name="${info_parts[1]}"
  fi

  local base_name=""
  local relative_path=""
  local repo_root_unresolved=""
  local n=0

  if [[ -n "$repo_root" ]]; then
    # In repo
    local relative_path_resolved
    relative_path_resolved=$(realpath -m --relative-to="$repo_root" "$pwd_canonical")
    n=$(_tmux_count_path_components "$relative_path_resolved")

    if [[ $n -eq 0 ]]; then
      repo_root_unresolved="$pwd_unresolved"
      relative_path="."
    else
      relative_path=$(_tmux_extract_path_suffix "$pwd_unresolved" "$n")
      repo_root_unresolved=$(_tmux_extract_path_prefix "$pwd_unresolved" "$n")
    fi

    # Determine base_name (unresolved repo name)
    local resolved_root_basename
    resolved_root_basename=$(basename "$repo_root")
    if [[ "$resolved_root_basename" == "$repo_name" ]]; then
      # Standard repo (Git/JJ): repo name is the root dir name
      base_name=$(basename "$repo_root_unresolved")
    else
      # CitC (or similar): repo name is different from root dir name (e.g. client vs google3)
      # We assume the repo name corresponds to the parent directory of the root
      base_name=$(basename "$(dirname "$repo_root_unresolved")")
    fi
  else
    # Not in a repo
    local home_unresolved="$HOME"

    if [[ "$pwd_unresolved" == "$home_unresolved" ]]; then
      base_name="~"
      relative_path="."
    elif [[ "$pwd_unresolved" == "$home_unresolved"/* ]]; then
      base_name="~"
      relative_path="${pwd_unresolved#$home_unresolved/}"
    else
      # Root
      if [[ "$pwd_unresolved" == "/" ]]; then
        base_name="/"
        relative_path="."
      else
        base_name=""
        relative_path="${pwd_unresolved#/}"
      fi
    fi
  fi

  local window_name=""
  if [[ "$relative_path" == "." ]]; then
    window_name="$base_name"
  else
    local current_dir
    current_dir=$(basename "$relative_path")
    local intermediate_path
    intermediate_path=$(dirname "$relative_path")

    if [[ "$intermediate_path" == "." ]]; then
      window_name="$base_name/$current_dir"
    else
      # Shorten intermediate path
      local shortened_intermediate
      shortened_intermediate=$(echo "$intermediate_path" | "$CONFIG_DIR/scripts/shorten_dir_name.sh")
      window_name="$base_name/$shortened_intermediate/$current_dir"
    fi
  fi

  echo "$window_name"
}

# Automatically renames the tmux window based on the current repo or directory.
update_tmux_window() {
  if [ -n "$TMUX" ]; then
    local window_name
    window_name=$(_tmux_get_window_name)
    tmux rename-window "$window_name"
  fi
}

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

# Interactive go up the directory tree.
cd..(){
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux)
  cd "$DIR"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

source <(COMPLETE=bash jj)

if [ ! -f ~/.myConfig/bash_custom_google.sh ]; then
  PROMPT_COMMAND="update_tmux_window; $PROMPT_COMMAND"
fi
