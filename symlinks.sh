mkdir -p ~/.config
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
stow .

