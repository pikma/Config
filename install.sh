sudo apt update && \
sudo apt install \
  clang \
  clang-format \
  tmux \
  vim \
  git \
  silversearcher-ag \
  python3-pip
echo
echo
echo "===================================="
echo "Need to manually install:"
echo "  Google Chrome: http://google.com/chrome"

# Load the gnome-terminal settings:
echo "To load the gnome-terminal settings, run:"
echo "gconftool-2 --load \"$(dirname "$0")/gnome_terminal_conf.xml\""

echo "\nTo install YouCompleteMe, check out https://github.com/ycm-core/YouCompleteMe#installation."
echo "As of 2021-11-05, the commands to run were:"
echo "  apt install build-essential cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm"
echo "  cd ~/.vim/bundle/YouCompleteMe && python3 install.py --all"


