# Dotfiles

## TODO

- [x] add nvim config
- [ ] configured kitty
- [x] Save brew deps

## Tested distros

- Ubuntu
- Deepin
- Manjaro
- Fedora
- Kubuntu

That might works fine in MacOS too

## Steps to reproduce

### Clone repo

Clonning into `,config` with existing files

```bash
cd ~/.config
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/ZeiZel/dotfiles
git pull origin master --allow-unrelated-histories
```

Then delete trash-commit 

### Setup zsh?

If you on Mac or Manjaro (or another linux-distro), skip this.

```bash
sudo [dnf|apt] install zsh
sudo chsh -s $(which zsh)
```

### Install nix

Nix with flakes and more cool feautures are best package manager for us, because we can create the same env with few commands (^ ^)

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Install Kitty

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

### Install brew + deps

Install homebrew to your PC (check instructions at end of operation)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Created by [this guide](https://gist.github.com/JoeyBurzynski/cbab8361c59a720d60f83c20e8b21e20)

If have no Brewfile and repo

```bash
brew tap Homebrew/bundle
brew bundle dump
```

To install all brew-deps

```bash
brew bundle
```

### For working zsh

Create a hard symlink:

```shell
cp -r .oh-my-zsh/ ~/.oh-my-zsh
ln .zshrc ~/.zshrc
ln .tmux.conf ~/.tmux.conf
```

### Installing Tmux

Enter the Tmux

```bash
tmux
```

Install plugins with `ctrl + a` (aka leader) + `shift + i`

### For working nvim

Run `:MasonInstall` and `:Lazy install` (all packages is ensured)
