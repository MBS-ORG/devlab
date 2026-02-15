#!/bin/bash
# ============================================================================
# Ultra-Automated Dev Container - Installation Script
# ============================================================================
# Installs and configures the development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# Main Installation
# ============================================================================

print_header "Ultra-Automated Dev Container - Installation"

echo "This script will install and configure your development environment."
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# ============================================================================
# Check Prerequisites
# ============================================================================

print_header "Checking Prerequisites"

MISSING_DEPS=0

# Check Docker
if command_exists docker; then
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    print_success "Docker installed: v${DOCKER_VERSION}"
else
    print_error "Docker not found"
    print_info "Install from: https://docker.com/get-started"
    MISSING_DEPS=1
fi

# Check Docker Compose
if command_exists docker-compose; then
    COMPOSE_VERSION=$(docker-compose --version | cut -d' ' -f4 | cut -d',' -f1)
    print_success "Docker Compose installed: v${COMPOSE_VERSION}"
else
    print_warning "Docker Compose not found (Docker Desktop includes it)"
fi

# Check VS Code
if command_exists code; then
    print_success "VS Code installed"
else
    print_warning "VS Code not found"
    print_info "Install from: https://code.visualstudio.com"
    print_info "VS Code is optional but recommended for best experience"
fi

# Check Git
if command_exists git; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    print_success "Git installed: v${GIT_VERSION}"
else
    print_error "Git not found"
    print_info "Install Git for your platform"
    MISSING_DEPS=1
fi

# Check for Docker daemon running
if docker info >/dev/null 2>&1; then
    print_success "Docker daemon is running"
else
    print_error "Docker daemon is not running"
    print_info "Start Docker Desktop or the Docker daemon"
    MISSING_DEPS=1
fi

echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    print_error "Missing required dependencies. Please install them and run this script again."
    exit 1
fi

# ============================================================================
# Install VS Code Extensions
# ============================================================================

if command_exists code; then
    print_header "Installing VS Code Extensions"

    EXTENSIONS=(
        "ms-vscode-remote.remote-containers"
        "ms-vscode-remote.vscode-remote-extensionpack"
        "ms-azuretools.vscode-docker"
        "github.copilot"
        "eamodio.gitlens"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
    )

    for ext in "${EXTENSIONS[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            print_info "Already installed: $ext"
        else
            echo "Installing: $ext"
            code --install-extension "$ext" --force || print_warning "Failed to install $ext"
        fi
    done

    print_success "VS Code extensions installed"
else
    print_warning "Skipping VS Code extensions (VS Code not found)"
fi

# ============================================================================
# Setup Environment Files
# ============================================================================

print_header "Setting Up Environment Files"

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        print_success "Created .env file from .env.example"
        print_info "Please update .env with your specific values"
    else
        print_warning ".env.example not found, skipping .env creation"
    fi
else
    print_info ".env already exists, skipping"
fi

# ============================================================================
# Make Scripts Executable
# ============================================================================

print_header "Setting Script Permissions"

find .devcontainer/scripts -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find scripts -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
chmod +x *.sh 2>/dev/null || true

print_success "Script permissions set"

# ============================================================================
# Initialize Git Configuration
# ============================================================================

print_header "Git Configuration"

if [ -d .git ]; then
    print_info "Git repository detected"

    # Set recommended Git settings
    git config --local core.autocrlf input
    git config --local core.eol lf
    print_success "Git line endings configured (LF)"

    # Set pull strategy if not set
    if ! git config pull.rebase >/dev/null 2>&1; then
        git config --local pull.rebase false
        print_success "Git pull strategy set to merge"
    fi
else
    print_warning "Not a Git repository, skipping Git configuration"
fi

# ============================================================================
# Docker Pre-pull Images (Optional)
# ============================================================================

print_header "Docker Images"

read -p "Do you want to pre-pull Docker images? (Recommended, ~2-5 mins) [Y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    print_info "Pulling Docker images..."

    # Pull base images
    docker pull postgres:16-alpine &
    docker pull redis:7-alpine &
    docker pull docker.elastic.co/elasticsearch/elasticsearch:8.11.0 &
    docker pull rabbitmq:3-management-alpine &
    docker pull minio/minio:latest &

    # Wait for all pulls to complete
    wait

    print_success "Docker images pulled"
else
    print_info "Skipping image pre-pull"
fi

# ============================================================================
# Test Docker Compose Configuration
# ============================================================================

print_header "Validating Docker Compose Configuration"

if docker-compose -f .devcontainer/docker-compose.yml config >/dev/null 2>&1; then
    print_success "Docker Compose configuration is valid"
else
    print_error "Docker Compose configuration has errors"
    docker-compose -f .devcontainer/docker-compose.yml config
    exit 1
fi

# ============================================================================
# Create Necessary Directories
# ============================================================================

print_header "Creating Directories"

mkdir -p backups
mkdir -p logs
mkdir -p tmp

print_success "Directories created"

# ============================================================================
# Installation Summary
# ============================================================================

print_header "Installation Summary"

print_success "Installation completed successfully!"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "  ${GREEN}Option 1: Open in VS Code with Dev Containers${NC}"
echo "  $ code ."
echo "  (Click 'Reopen in Container' when prompted)"
echo ""
echo "  ${GREEN}Option 2: Start services manually${NC}"
echo "  $ make start          # Start all services"
echo "  $ make health         # Check service health"
echo "  $ make logs           # View logs"
echo ""
echo "  ${GREEN}Option 3: Use Docker Compose directly${NC}"
echo "  $ docker-compose -f .devcontainer/docker-compose.yml up -d"
echo ""
echo -e "${BLUE}Helpful Commands:${NC}"
echo "  $ make help           # Show all available commands"
echo "  $ make status         # Show service status"
echo "  $ make clean          # Clean up resources"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  - README.md           - Overview and features"
echo "  - QUICKSTART.md       - 5-minute quick start"
echo "  - docs/               - Detailed documentation"
echo ""
print_success "Happy coding! 🚀"
echo ""

# ============================================================================
# Optional: Start Services
# ============================================================================

read -p "Do you want to start the services now? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Starting services..."
    make start || docker-compose -f .devcontainer/docker-compose.yml up -d
else
    print_info "Services not started. Run 'make start' when ready."
fi
