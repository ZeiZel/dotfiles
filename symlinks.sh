mkdir -p ~/.config
mkdir -p "~/Library/Application Support/nushell"

ln -s ~/.dotfiles/zshrc/.zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

stow --target=~/.config .
stow --target="~/Library/Application Support/nushell" nushell
