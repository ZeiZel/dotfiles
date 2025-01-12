#!/bin/bash

# checking root
if [[ $EUID -eq 0 ]]; then
    echo "Please run this script not from superuser-do"
    exit 1
fi

printf "\n%.0s" {1..3}
echo "_____    _ _____    _"
echo "|__  /___(_)__  /___| |"
echo "  / // _ \ | / // _ \ |"
echo " / /|  __/ |/ /|  __/ |"
echo "/____\___|_/____\___|_|"
printf "\n%.0s" {1..2}

read -p "$(tput setaf 6)Do you want to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Cancel installing."
    exit 1
fi

# Clonning dotfiles to .config 
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
cd ~/.config || exit 1
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/ZeiZel/dotfiles
git pull origin master --allow-unrelated-histories

# Create symlinks to files 
for file in .zshrc .tmux.conf; do
    if [ -e ~/"$file" ]; then
        while true; do
            read -p "$(tput setaf 4)$file already exists. Do you want to Replace or Merge it? (r/m): $(tput sgr0)" choice
            case $choice in
                r)
                    ln -sf ~/.config/"$file" ~/"$file"
                    echo "Replaced $file."
                    break
                    ;;
                m)
                    cat ~/.config/"$file" >> ~/"$file"
                    echo "Merged $file."
                    break
                    ;;
                *)
                    echo "Invalid choice. Please try again."
                    ;;
            esac
        done
    else
        ln -s ~/.config/"$file" ~/"$file"
    fi
done

# Install Kitty
read -p "$(tput setaf 6)Do you want to insatll Kitty? (y/n): $(tput sgr0)" install_kitty
if [ "$install_kitty" = "y" ]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "Kitty skipped."
fi

# Installing Nix
read -p "$(tput setaf 6)Do you want to install Nix? (y/n): $(tput sgr0)" install_nix
if [ "$install_nix" = "y" ]; then
    sh <(curl -L https://nixos.org/nix/install) --daemon
else
    echo "Skipping Nix installation."
fi

# Using Nix Flakes to manage dependencies
if command -v nix &> /dev/null; then
    echo "Installing dependencies using Nix Flakes..."

    # Creating flake.nix file if it doesn't exist
    if [ ! -f ~/.config/flake.nix ]; then
        cat > ~/.config/flake.nix <<EOF
{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-darwin"; # Or another system type if needed
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations."${USER}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    };
}
EOF
    fi

    # Creating home.nix file if it doesn't exist
    if [ ! -f ~/.config/home.nix ]; then
        cat > ~/.config/home.nix <<EOF
{ config, pkgs, ... }:
{
  # List of packages to install
  home.packages = with pkgs; [
    bashInteractive
    bc
    coreutils
    fd
    ffmpegthumbnailer
    fzf
    gawk
    gitAndTools.gh
    glab
    gnused
    imagemagick
    jq
    neovim
    poppler_utils
    ripgrep
    p7zip
    tmux
    zoxide
    lazygit
  ];

  # Additional settings if needed
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.tmux.enable = true;
}
EOF
    fi

    # Applying changes through Nix Flakes
    nix flake update
    nix build .#homeConfigurations.${USER}
    ./result/switch
else
    echo "Nix is not installed. Packages were not installed."
fi

# Check if Nix is installed
if command -v nix &> /dev/null; then
    echo "Nix is already installed. Skipping Homebrew installation."
else
    # Installing Homebrew
    read -p "$(tput setaf 6)Do you want to install Homebrew? (y/n): $(tput sgr0)" install_brew
    if [ "$install_brew" = "y" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Skipping Homebrew installation."
    fi

    # Installing Homebrew packages
    if command -v brew &> /dev/null; then
        while ! brew bundle; do
            echo "Retrying Homebrew package installation..."
            brew bundle
        done
    else
        echo "Homebrew packages were not installed!"
    fi
fi

# Check and install ZSH
if ! command -v zsh &> /dev/null; then
    echo "No zsh. Install?"
    read -p "(y/n): " install_zsh
    if [ "$install_zsh" = "y" ]; then
        if command -v dnf &> /dev/null; then
            sudo dnf install zsh
        elif command -v apt &> /dev/null; then
            sudo apt install zsh
        else
            echo "Cant detect package maanger. Please install zsh manually."
        fi
        
        sudo chsh -s $(which zsh)
    else
        echo "Zsh installation skipped."
    fi
fi

# Install Oh My Zsh, plugins, and set zsh as default shell
if command -v zsh >/dev/null; then
	printf "${NOTE} Installing Oh My Zsh and plugins...\n"
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
  		sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
	else
		echo "Directory .oh-my-zsh already exists. Skipping re-installation." 2>&1 | tee -a "$LOG"
	fi

	# Check if the directories exist before cloning the repositories
	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
	else
    	echo "Directory zsh-autosuggestions already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
	else
    	echo "Directory zsh-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-zsh-plugin" ]; then
    	git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin || true
	else
    	echo "Directory zsh-syntax-highlighting already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi
	
	# Check if ~/.zshrc and .zprofile exists, create a backup, and copy the new configuration
	if [ -f "$HOME/.zshrc" ]; then
    	cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
	fi

	if [ -f "$HOME/.zprofile" ]; then
    	cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup" || true
	fi

    printf "${NOTE} Changing default shell to zsh...\n"

	while ! chsh -s $(which zsh); do
    echo "${ERROR} Authentication failed. Please enter the correct password."
    sleep 1	
	done
	printf "\n"
	printf "${NOTE} Shell changed successfully to zsh.\n" 2>&1 | tee -a "$LOG"

fi

# Install TMUX (tmux installed in previous steps, at next we need to: enter `tmux`, run `source ~/.tmux.conf` and `prefix+I` to install deps)
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

# Install Hyprland by JaKooLit 
read -p "$(tput setaf 6)Do you want to install Hyprland? (y/n): $(tput sgr0)" install_hyprland
if [ "$install_hyprland" = "y" ]; then
    if command -v pacman &> /dev/null; then
        link="https://github.com/JaKooLit/Arch-Hyprland.git"
    elif command -v dnf &> /dev/null; then
        link="https://github.com/JaKooLit/Fedora-Hyprland.git"
	elif command -v apt &> /dev/null; then
		link=https://github.com/JaKooLit/Debian-Hyprland.git
    else
        echo "Please, visit https://github.com/JaKooLit to watch config for youe distro."
        exit 1
    fi

    git clone --depth=1 "$link" ~/Hyprland
    cd ~/Hyprland || exit 1
    chmod +x install.sh
    ./install.sh
fi

echo "Install ended!"
