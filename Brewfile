# ============================================
# TAPS
# ============================================
tap "jesseduffield/lazygit"
tap "hashicorp/tap"
tap "derailed/k9s"
tap "nikitabobko/tap" if OS.mac?

# ============================================
# CORE UTILITIES
# ============================================
brew "stow"
brew "bat"
brew "btop"
brew "herdr"
brew "yazi"
brew "atuin"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"
brew "fzf-tab"
brew "git"
brew "neovim"
brew "atool"
brew "procs"
brew "eza"
brew "fd"
brew "fzf"
brew "jq"
brew "yq"
brew "ripgrep"
brew "zoxide"
brew "tree"
brew "tldr"
brew "starship"
brew "mas" if OS.mac?

# ============================================
# MODERN CLI REPLACEMENTS
# ============================================
brew "dust"          # Better du - disk usage analyzer
brew "duf"           # Better df - disk free
brew "gping"         # Ping with graph
brew "bottom"        # Better htop/top alternative
brew "hyperfine"     # Benchmarking tool
brew "sd"            # Better sed
brew "choose-rust"   # Better cut/awk for columns (binary: choose)
brew "tokei"         # Code statistics
brew "glow"          # Markdown renderer in terminal
brew "xh"            # Better HTTPie (Rust, faster)
brew "viddy"         # Modern watch replacement
brew "jless"         # JSON viewer/explorer
brew "difftastic"    # Structural diff (AST-aware)
brew "ast-grep"      # Structural code search, linting, and rewriting
brew "broot"         # Interactive tree navigator
brew "navi"          # Interactive cheatsheet
brew "doggo"         # Modern dig replacement (DNS)
brew "bandwhich"     # Network bandwidth monitor
brew "lnav"          # Log file navigator

# ============================================
# GNU TOOLS (macOS replacement)
# ============================================
brew "grep"
brew "gnutls"
brew "gnu-which"
brew "gnu-indent"
brew "gnu-tar"
brew "gnu-sed"
brew "gzip"
brew "diffutils"
brew "findutils"
brew "coreutils"
brew "gawk"
brew "make"
brew "watch"
brew "ed"
brew "bc"

# ============================================
# SHELL & TERMINAL
# ============================================
brew "bash"
brew "zsh"
brew "wget"
brew "curl"
brew "nano"
brew "less"
brew "thefuck"

# ============================================
# GIT & VERSION CONTROL
# ============================================
brew "jesseduffield/lazygit/lazygit"
brew "gh"
brew "glab"
brew "git-lfs"
brew "git-delta"

# ============================================
# DEVOPS & KUBERNETES
# ============================================
brew "kubectl"
brew "kubectx"
brew "minikube"
brew "helm"
brew "derailed/k9s/k9s"
brew "kustomize"
brew "kubeconform"
brew "stern"
brew "lazydocker"
brew "dive"
brew "qemu"

# ============================================
# INFRASTRUCTURE AS CODE
# ============================================
brew "hashicorp/tap/terraform"
brew "ansible"
brew "ansible-lint"

# ============================================
# SECURITY & CI
# ============================================
brew "gitleaks"      # Detect secrets before they reach a remote
brew "trivy"         # Scan repositories, IaC, containers, and dependencies

# ============================================
# CLOUD TOOLS
# ============================================
brew "awscli"

# ============================================
# BACKEND DEVELOPMENT
# ============================================
brew "go"
brew "rustup"
brew "dotnet"
brew "python"
brew "pyenv"
brew "uv"
brew "cargo-nextest"
brew "httpie"
brew "httpyac"
brew "posting"
brew "resterm"
brew "harlequin"
brew "grpcurl"
brew "redis"
brew "postgresql@16"

# ============================================
# NETWORKING & DEBUGGING
# ============================================
brew "trippy"
brew "mtr"
brew "nmap"
brew "tcpdump"

# ============================================
# MEDIA & FILES
# ============================================
brew "ffmpegthumbnailer"
brew "imagemagick"
brew "poppler"
brew "sevenzip"

# ============================================
# CASKS (macOS GUI Applications)
# ============================================
if OS.mac?
  cask "nikitabobko/tap/aerospace"
  cask "docker-desktop"
  cask "maccy"
  cask "flameshot"
  cask "chatgpt"
  cask "claude"
  cask "mos"
  cask "visual-studio-code"
  cask "jetbrains-toolbox"
end

# ============================================
# FONTS
# ============================================
cask "font-jetbrains-mono-nerd-font" if OS.mac?
cask "font-fira-code-nerd-font" if OS.mac?
cask "font-hack-nerd-font" if OS.mac?
