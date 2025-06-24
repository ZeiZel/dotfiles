#!/bin/bash

# CHECKING ROOT
if [[ $EUID -eq 0 ]]; then
    echo "Please run this script not from superuser-do"
    exit 1
fi

# LOGO
printf "\n%.0s" {1..3}
echo "_____    _ _____    _"
echo "|__  /___(_)__  /___| |"
echo "  / // _ \ | / // _ \ |"
echo " / /|  __/ |/ /|  __/ |"
echo "/____\___|_/____\___|_|"
printf "\n%.0s" {1..2}

# =========================
# XCode command line tools
# =========================
sudo xcode-select --install

# INSTALLING BREW
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo tee -a "/etc/zshenv" >/dev/null << EOF
eval "\$(/opt/homebrew/bin/brew shellenv)"
EOF

brew install git

# CLONNING CONFIGS 
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
cd ~/.config || exit 1
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/ZeiZel/dotfiles
git pull origin master --allow-unrelated-histories

cd ./config && brew bundle && cd ..

# PYTHON (configure after installing by brew bundle)
pyenv install 3.7.5
pyenv global system
# GitHub - ranger/ranger: A VIM-inspired filemanager for the console https://github.com/ranger/ranger
pip3 install ranger-fm
ranger --copy-config=rifle

# Check and install ZSH
echo "$(which zsh)" | sudo tee -a /etc/shells
chsh -s "$(which zsh)"

# Install Oh My Zsh, plugins, and set zsh as default shell
if command -v zsh >/dev/null; then
	printf "${NOTE} Installing Oh My Zsh and plugins...\n"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
   	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
   	git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin || true
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
   	cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
   	cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup" || true
fi

# copy configs
cd ~/ && rm -rf .tmux.conf .zshrc && cd ~/.config && ln .tmux.conf ~/.tmux.conf && ln zshrc/.zshrc ~/.zshrc

defaults write -g InitialKeyRepeat -float 10.0 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -float 1.0 # normal minimum is 2 (30 ms)
defaults write com.apple.finder CreateDesktop false

# installing nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Configure TMUX (tmux installed in previous steps, at next we need to: enter `tmux`, run `source ~/.tmux.conf` and `prefix+I` to install deps)
if [ ! -d ~/.tmux ]; then
    mkdir -p ~/.tmux
fi
cd ~/.tmux || exit 1
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux start-server
tmux new-session -d -s tpm_install_session
tmux send-keys -t tpm_install_session 'source ~/.tmux.conf' C-m
tmux send-keys -t tpm_install_session 'prefix + I' C-m
tmux wait-for -S prefix + I
tmux kill-session -t tpm_install_session
tmux kill-server

# sharkdp/vivid: A themeable LS_COLORS generator with a rich filetype datebase https://github.com/sharkdp/vivid
# brew formula contains outdated version, installing it manually from GH releases
wget --quiet https://github.com/sharkdp/vivid/releases/download/v0.9.0/vivid-v0.9.0-x86_64-apple-darwin.tar.gz -O /tmp/vivid.tar.gz
tar xzf /tmp/vivid.tar.gz -C /tmp
cp /tmp/vivid-v0.9.0-x86_64-apple-darwin/vivid /usr/local/bin/
rm -rf /tmp/vivid /tmp/vivid.tar.gz

echo "Install ended!"
