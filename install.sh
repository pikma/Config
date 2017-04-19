echo $(dirname $0)

exit

sudo apt-get update && \
sudo apt-get install \
  clang-3.5 \
  clang-format-3.5 \
  compizconfig-settings-manager \
  compiz-plugins-default \
  gnome-tweak-tool \
  haskell-platform \
  r-base-core \
  synaptic \
  tmux \
  vim-gnome \
  git \
  ipython \
  texlive-latex-base \
  texlive-science \
  texlive-latex-recommended \
  synaptic \
  pgpgpg
echo "\n\n===================================="
echo "Need to manually install:"
echo "  Google Chrome: http://google.com/chrome"
echo "  Anaconda (Jupyter Notebook): https://www.continuum.io/downloads"

# Load the gnome-terminal settings:
gconftool-2 --load "$(dirname "$0")/gnome_terminal_conf.xml"
