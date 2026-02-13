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

# Repository configuration
REPO_URL="https://github.com/ZeiZel/dotfiles.git"
DOTFILES_DIR="${HOME}/.dotfiles"

# Clone repository if not already present
if [ ! -f "all.yml" ]; then
    echo "Cloning dotfiles repository..."

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo "Installing git first..."
        case "$OS_TYPE" in
            darwin)
                if ! command -v brew &> /dev/null; then
                    echo "Installing Homebrew first..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                    if [[ -f /opt/homebrew/bin/brew ]]; then
                        eval "$(/opt/homebrew/bin/brew shellenv)"
                    elif [[ -f /usr/local/bin/brew ]]; then
                        eval "$(/usr/local/bin/brew shellenv)"
                    fi
                fi
                brew install git
                ;;
            debian)
                sudo apt-get update
                sudo apt-get install -y git
                ;;
            redhat)
                sudo dnf install -y git
                ;;
            arch)
                sudo pacman -Sy --noconfirm git
                ;;
        esac
    fi

    # Clone repository
    if [ -d "$DOTFILES_DIR" ]; then
        echo "Directory $DOTFILES_DIR already exists, using it..."
        cd "$DOTFILES_DIR"
        git pull origin master || true
    else
        git clone "$REPO_URL" "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi
else
    echo "Running from existing dotfiles directory..."
fi

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

# Get the directory where playbook is located (either script dir or cloned repo)
if [ -f "all.yml" ]; then
    SCRIPT_DIR="$(pwd)"
else
    SCRIPT_DIR="$DOTFILES_DIR"
fi

# Install Ansible collections if requirements.yml exists
if [ -f "$SCRIPT_DIR/requirements.yml" ]; then
    echo "Installing Ansible collections..."
    ansible-galaxy collection install -r "$SCRIPT_DIR/requirements.yml" 2>/dev/null || true
fi

# Setup temporary passwordless sudo for Linux
SUDOERS_TEMP="/etc/sudoers.d/ansible-dotfiles-temp"

setup_passwordless_sudo() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo ""
        echo "Setting up temporary passwordless sudo for package installation..."
        echo "This will be automatically removed after installation."

        # Check if sudoers.d is included
        if ! sudo grep -q "^#includedir /etc/sudoers.d" /etc/sudoers && ! sudo grep -q "^@includedir /etc/sudoers.d" /etc/sudoers; then
            echo "WARNING: /etc/sudoers.d might not be included in /etc/sudoers"
        fi

        # Create simple NOPASSWD rule
        echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "$SUDOERS_TEMP" > /dev/null
        sudo chmod 0440 "$SUDOERS_TEMP"

        # Validate the sudoers file
        if sudo visudo -c -f "$SUDOERS_TEMP" &>/dev/null; then
            echo "Temporary sudo configuration created and validated."
        else
            echo "ERROR: Failed to create valid sudoers file"
            sudo rm -f "$SUDOERS_TEMP"
            exit 1
        fi
    fi
}

cleanup_passwordless_sudo() {
    if [[ "$OSTYPE" != "darwin"* ]] && [[ -f "$SUDOERS_TEMP" ]]; then
        echo ""
        echo "Removing temporary sudo configuration..."
        sudo rm -f "$SUDOERS_TEMP"
    fi
}

# Trap to ensure cleanup happens even on error
trap cleanup_passwordless_sudo EXIT

# Run Ansible playbook
echo ""
echo "Running Ansible playbook..."
echo ""

cd "$SCRIPT_DIR"

# Setup passwordless sudo for Linux (macOS doesn't need this)
setup_passwordless_sudo

# Test passwordless sudo on Linux
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo ""
    echo "Testing passwordless sudo..."
    if sudo -n true 2>/dev/null; then
        echo "Passwordless sudo is working correctly."
    else
        echo "ERROR: Passwordless sudo is not working. Please check your configuration."
        exit 1
    fi
fi

# Run ansible playbook (no -K flag needed with passwordless sudo)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: sudo works fine with -K
    ansible-playbook -i inventory/hosts.ini all.yml -K "$@"
else
    # Linux: use passwordless sudo we just configured
    ansible-playbook -i inventory/hosts.ini all.yml "$@"
fi

echo ""
echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.zshrc"
