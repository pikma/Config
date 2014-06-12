files="bashrc gitconfig inputrc tmux.conf vim vimrc"
cd $HOME
for f in $files; do
  ln -s "~/.myConfig/$f" ".$f"
  echo "Created symlink .$f"
done

