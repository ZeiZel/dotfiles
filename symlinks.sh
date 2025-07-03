mkdir -p ~/.config
rm ~/.zshrc
ln -s ~/.dotfiles/zshrc/.zshrc ~/.zshrc
stow .

