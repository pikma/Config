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
