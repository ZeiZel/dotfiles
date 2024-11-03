# Dotfiles

## TODO

- [x] add nvim config
- [ ] configured kitty
- [x] Save brew deps

## Install brew + deps

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

## For working zsh

Create a hard symlink:

```shell
 ln .zshrc ~/.zshrc
 ln .tmux ~/.tmuc.conf
```

## Installing Tmux

Enter the Tmux

```bash
tmux
```

Install plugins with `ctrl + a` (aka leader) + `shift + i`

## For working nvim

Run `:MasonInstall` and `:Lazy install` (all packages is ensured)
