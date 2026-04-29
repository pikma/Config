files="bashrc gitconfig inputrc tmux.conf vim vimrc"
cd $HOME
for f in $files; do
  ln -s "~/.myConfig/$f" "~/.$f" && echo "Created symlink ~/.$f"
done

mkdir -p ~/.config
ln -s ~/.myConfig/jj -T ~/.config/jj

ln -s ~/.myConfig/nvim -T ~/.config/nvim
