#!/bin/bash

# ============================================
# Dotfiles Bootstrap Script
# Only installs Ansible, then runs playbook
# ============================================

set -e

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

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint|pop)
                echo "debian"
                ;;
            fedora|rhel|centos|rocky|alma)
                echo "redhat"
                ;;
            arch|manjaro|endeavouros)
                echo "arch"
                ;;
            *)
                case "$ID_LIKE" in
                    *debian*|*ubuntu*)
                        echo "debian"
                        ;;
                    *rhel*|*fedora*)
                        echo "redhat"
                        ;;
                    *arch*)
                        echo "arch"
                        ;;
                    *)
                        echo "unknown"
                        ;;
                esac
                ;;
        esac
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)
echo "Detected OS family: $OS_TYPE"

# Install Ansible based on OS
install_ansible() {
    case "$OS_TYPE" in
        darwin)
            echo "Installing Ansible via Homebrew..."
            if ! command -v brew &> /dev/null; then
                echo "Installing Homebrew first..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                if [[ -f /opt/homebrew/bin/brew ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                elif [[ -f /usr/local/bin/brew ]]; then
                    eval "$(/usr/local/bin/brew shellenv)"
                fi
            fi
            brew install ansible
            ;;
        debian)
            echo "Installing Ansible via apt..."
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            sudo apt-add-repository --yes --update ppa:ansible/ansible 2>/dev/null || true
            sudo apt-get install -y ansible
            ;;
        redhat)
            echo "Installing Ansible via dnf..."
            sudo dnf install -y epel-release 2>/dev/null || true
            sudo dnf install -y ansible
            ;;
        arch)
            echo "Installing Ansible via pacman..."
            sudo pacman -Sy --noconfirm ansible
            ;;
        *)
            echo "Unsupported OS. Please install Ansible manually."
            exit 1
            ;;
    esac
}

# Check if Ansible is already installed
if ! command -v ansible &> /dev/null; then
    install_ansible
else
    echo "Ansible is already installed: $(ansible --version | head -1)"
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run Ansible playbook
echo ""
echo "Running Ansible playbook..."
echo ""

cd "$SCRIPT_DIR"

# Run with ask-become-pass for sudo operations
ansible-playbook -i inventory/hosts.ini all.yml --ask-become-pass "$@"

echo ""
echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.zshrc"
