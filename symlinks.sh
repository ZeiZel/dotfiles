mkdir -p ~/.config
mkdir -p "$HOME/Library/Application Support/nushell"

ln -s ~/.dotfiles/zshrc/.zshrc ~/.zshrc
ln -sf "$HOME/.dotfiles/nushell" "$HOME/Library/Application Support/nushell"

stow .
