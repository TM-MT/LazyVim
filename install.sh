#!/usr/bin/env bash

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
skip() { echo -e "${YELLOW}[SKIP]${RESET}  $*"; }

# ─── Detect OS ────────────────────────────────────────────────────────────────

OS="$(uname -s)"
case "$OS" in
Darwin) PLATFORM="mac" ;;
Linux) PLATFORM="linux" ;;
*)
  echo "Unsupported OS: $OS"
  exit 1
  ;;
esac

info "Detected platform: ${BOLD}${PLATFORM}${RESET}"

# ─── Helper: command exists ───────────────────────────────────────────────────

has() { command -v "$1" &>/dev/null; }

# ─── 1. System dependencies: gcc, git, tar, curl ─────────────────────────────

install_system_deps() {
  local deps=()

  for dep in gcc git tar curl; do
    if has "$dep"; then
      skip "$dep already installed"
    else
      deps+=("$dep")
    fi
  done

  if [[ ${#deps[@]} -eq 0 ]]; then
    return 0
  fi

  info "Installing system packages: ${deps[*]}"

  if [[ "$PLATFORM" == "mac" ]]; then
    if ! has brew; then
      info "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install "${deps[@]}"
  else
    if has apt-get; then
      sudo apt-get update -y
      sudo apt-get install -y "${deps[@]}"
    else
      echo "No supported package manager found. Install manually: ${deps[*]}"
      exit 1
    fi
  fi
}

# ─── 2. Neovim ───────────────────────────────────────────────────────────────

install_neovim() {
  if has nvim; then
    skip "nvim already installed ($(nvim --version | head -1))"
    return 0
  fi

  info "Installing Neovim..."

  if [[ "$PLATFORM" == "mac" ]]; then
    local archive="nvim-macos-arm64.tar.gz"
    curl -LO "https://github.com/neovim/neovim/releases/download/nightly/${archive}"
    tar xzf "$archive"
    sudo mkdir -p /usr/local/bin
    sudo ln -sf "$(pwd)/nvim-macos-arm64/bin/nvim" /usr/local/bin/nvim
    rm -f "$archive"
    success "Neovim installed → /usr/local/bin/nvim"
  else
    local archive="nvim-linux-x86_64.tar.gz"
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/${archive}"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf "$archive"
    rm -f "$archive"

    # Add to PATH for current session and persist via profile
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

    SHELL_RC=""
    if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
      SHELL_RC="$HOME/.bashrc"
    elif [[ -n "$ZSH_VERSION" && -f "$HOME/.zshrc" ]]; then
      SHELL_RC="$HOME/.zshrc"
    elif [[ -f "$HOME/.profile" ]]; then
      SHELL_RC="$HOME/.profile"
    fi

    if [[ -n "$SHELL_RC" ]]; then
      if ! grep -q '/opt/nvim-linux-x86_64/bin' "$SHELL_RC"; then
        # shellcheck disable=SC2016
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >>"$SHELL_RC"
        info "Added Neovim to PATH in $SHELL_RC"
      fi
    fi

    success "Neovim installed → /opt/nvim-linux-x86_64/bin/nvim"
  fi
}

# ─── 3. fzf, ripgrep (rg), fd ────────────────────────────────────────────────

install_cli_tools() {
  if [[ "$PLATFORM" == "mac" ]]; then
    for tool in fzf ripgrep fd; do
      local cmd="$tool"
      [[ "$tool" == "ripgrep" ]] && cmd="rg"
      if has "$cmd"; then
        skip "$tool already installed"
      else
        info "Installing $tool..."
        brew install "$tool"
      fi
    done
  else
    # fzf
    if has fzf; then
      skip "fzf already installed"
    else
      info "Installing fzf..."
      if has apt-get; then
        sudo apt-get install -y fzf
      fi
    fi

    # ripgrep (rg)
    if has rg; then
      skip "ripgrep already installed"
    else
      info "Installing ripgrep..."
      if has apt-get; then
        sudo apt-get install -y ripgrep
      fi
    fi

    # fd / fdfind
    if has fd || has fdfind; then
      skip "fd already installed"
    else
      info "Installing fd-find..."
      if has apt-get; then
        sudo apt-get install -y fd-find
      fi
    fi
  fi
}

# ─── 4. Hack Nerd Font ───────────────────────────────────────────────────────

install_nerd_font() {
  local font_name="Hack"
  local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"

  if [[ "$PLATFORM" == "mac" ]]; then
    local font_dir="$HOME/Library/Fonts"
    if ls "$font_dir"/${font_name}*.ttf &>/dev/null 2>&1; then
      skip "Hack Nerd Font already installed"
      return 0
    fi
    info "Installing Hack Nerd Font..."
    mkdir -p "$font_dir"
    local tmpdir
    tmpdir="$(mktemp -d)"
    curl -L "$font_url" -o "$tmpdir/Hack.zip"
    unzip -o "$tmpdir/Hack.zip" -d "$tmpdir/Hack"
    cp "$tmpdir"/Hack/*.ttf "$font_dir/"
    rm -rf "$tmpdir"
    success "Hack Nerd Font installed"
  else
    local font_dir="$HOME/.local/share/fonts/${font_name}NerdFont"
    if [[ -d "$font_dir" ]] && ls "$font_dir"/*.ttf &>/dev/null 2>&1; then
      skip "Hack Nerd Font already installed"
      return 0
    fi
    info "Installing Hack Nerd Font..."
    mkdir -p "$font_dir"
    local tmpdir
    tmpdir="$(mktemp -d)"
    curl -L "$font_url" -o "$tmpdir/Hack.zip"
    unzip -o "$tmpdir/Hack.zip" -d "$tmpdir/Hack"
    cp "$tmpdir"/Hack/*.ttf "$font_dir/"
    rm -rf "$tmpdir"
    if has fc-cache; then
      fc-cache -fv "$font_dir" &>/dev/null
    fi
    success "Hack Nerd Font installed"
  fi
}

# ─── 5. bash-language-server & shellcheck ────────────────────────────────────

install_bash_lsp() {
  if ! has npm; then
    info "npm not found. Installing Node.js..."
    if [[ "$PLATFORM" == "mac" ]]; then
      brew install node
    else
      if has apt-get; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
      fi
    fi
  fi

  if has bash-language-server; then
    skip "bash-language-server already installed ($(bash-language-server --version 2>/dev/null || echo 'unknown version'))"
  else
    info "Installing bash-language-server..."
    npm i -g bash-language-server
    success "bash-language-server installed"
  fi

  # install shellcheck
  if has shellcheck; then
    skip "shellcheck already installed"
  else
    info "Installing shellcheck..."
    if [[ "$PLATFORM" == "mac" ]]; then
      brew install shellcheck
    else
      if has apt-get; then
        sudo apt-get install -y shellcheck
      fi
    fi
    success "shellcheck installed"
  fi
}

# ─── 6. LazyVim config ───────────────────────────────────────────────────────

setup_lazyvim_config() {
  local config_dir="$HOME/.config/nvim"
  local repo="https://github.com/TM-MT/LazyVim.git"

  if [[ -d "$config_dir/.git" ]]; then
    skip "\$HOME/.config/nvim already exists as a git repo"
    return 0
  fi

  if [[ -d "$config_dir" ]]; then
    info "Backing up existing ~/.config/nvim to ~/.config/nvim.bak ..."
    mv "$config_dir" "${config_dir}.bak"
  fi

  info "Cloning LazyVim config..."
  git clone "$repo" "$config_dir"
  success "LazyVim config cloned to $config_dir"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

echo -e "${BOLD}=== Neovim Environment Setup ===${RESET}\n"

install_system_deps
install_neovim
install_cli_tools
install_nerd_font
install_bash_lsp
setup_lazyvim_config

echo ""
echo -e "${GREEN}${BOLD}✓ All done!${RESET}"
if [[ "$PLATFORM" == "linux" ]] && ! has nvim; then
  echo -e "  Restart your shell or run: ${BOLD}export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"${RESET}"
fi
