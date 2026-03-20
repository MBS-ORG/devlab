#!/usr/bin/env bash
# setup-dev-env.sh — Bootstrap a Linux dev machine with common tools.
#
# Tested on: Ubuntu 22.04/24.04, Debian 12
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yourorg/devlab/main/scripts/system/setup-dev-env.sh | bash
#   # or
#   ./setup-dev-env.sh [--skip-docker] [--skip-node] [--skip-python]
#
set -euo pipefail

SKIP_DOCKER=false
SKIP_NODE=false
SKIP_PYTHON=false

for arg in "$@"; do
  case "$arg" in
    --skip-docker) SKIP_DOCKER=true ;;
    --skip-node)   SKIP_NODE=true ;;
    --skip-python) SKIP_PYTHON=true ;;
  esac
done

info()    { echo -e "\e[32m[INFO]\e[0m  $*"; }
warning() { echo -e "\e[33m[WARN]\e[0m  $*"; }
error()   { echo -e "\e[31m[ERROR]\e[0m $*" >&2; exit 1; }

require_root() {
  [[ $EUID -eq 0 ]] || error "This script must be run as root (or with sudo)."
}

# --- Base packages ---
install_base() {
  info "Installing base packages..."
  apt-get update -qq
  apt-get install -y --no-install-recommends \
    build-essential curl wget git ca-certificates gnupg lsb-release \
    jq unzip zip htop tree tmux vim
}

# --- Docker ---
install_docker() {
  if command -v docker &>/dev/null; then
    info "Docker already installed: $(docker --version)"
    return
  fi
  info "Installing Docker..."
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable --now docker
  info "Docker installed: $(docker --version)"
}

# --- Node.js via nvm ---
install_node() {
  if command -v node &>/dev/null; then
    info "Node.js already installed: $(node --version)"
    return
  fi
  info "Installing Node.js (via nvm)..."
  NVM_VERSION="v0.39.7"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default lts/*
  info "Node.js installed: $(node --version)"
}

# --- Python via pyenv ---
install_python() {
  if command -v python3 &>/dev/null && python3 --version | grep -q "3\.1[2-9]"; then
    info "Python already installed: $(python3 --version)"
    return
  fi
  info "Installing Python build deps..."
  apt-get install -y --no-install-recommends \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  info "Installing pyenv..."
  curl -fsSL https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  PYTHON_VERSION="3.12.3"
  pyenv install "$PYTHON_VERSION"
  pyenv global "$PYTHON_VERSION"

  pip install --upgrade pip pipx
  pipx install ruff mypy
  info "Python installed: $(python3 --version)"
}

# --- Main ---
require_root

install_base
"$SKIP_DOCKER" || install_docker
"$SKIP_NODE"   || install_node
"$SKIP_PYTHON" || install_python

echo
info "Dev environment setup complete!"
info "Installed tools:"
command -v git    &>/dev/null && info "  git:    $(git --version)"
command -v docker &>/dev/null && info "  docker: $(docker --version)"
command -v node   &>/dev/null && info "  node:   $(node --version)"
command -v python3 &>/dev/null && info "  python: $(python3 --version)"
