#!/bin/bash
# ============================================================================
# Environment Setup Validation Script
# ============================================================================
# Validates that all prerequisites are installed and properly configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

# Print functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_check() {
    echo -e "${BLUE}⏳${NC} Checking $1..."
}

print_pass() {
    echo -e "${GREEN}✅${NC} $1"
    ((PASS++))
}

print_fail() {
    echo -e "${RED}❌${NC} $1"
    ((FAIL++))
}

print_warn() {
    echo -e "${YELLOW}⚠️${NC}  $1"
    ((WARN++))
}

print_info() {
    echo -e "${BLUE}ℹ️${NC}  $1"
}

# Check command exists
check_command() {
    local cmd=$1
    local name=$2
    local min_version=$3

    print_check "$name"

    if command -v "$cmd" &> /dev/null; then
        local version=$("$cmd" --version 2>&1 | head -n 1)
        print_pass "$name is installed: $version"
        return 0
    else
        print_fail "$name is not installed"
        if [ -n "$min_version" ]; then
            print_info "Required version: $min_version or higher"
        fi
        return 1
    fi
}

# Check Node.js version
check_node_version() {
    print_check "Node.js version"

    if command -v node &> /dev/null; then
        local version=$(node -v | sed 's/v//')
        local major=$(echo "$version" | cut -d. -f1)

        if [ "$major" -ge 20 ]; then
            print_pass "Node.js version $version (>= 20.x required)"
        else
            print_warn "Node.js version $version (>= 20.x recommended)"
        fi
    else
        print_fail "Node.js not found"
    fi
}

# Check Python version
check_python_version() {
    print_check "Python version"

    if command -v python3 &> /dev/null; then
        local version=$(python3 --version | awk '{print $2}')
        local major=$(echo "$version" | cut -d. -f1)
        local minor=$(echo "$version" | cut -d. -f2)

        if [ "$major" -eq 3 ] && [ "$minor" -ge 11 ]; then
            print_pass "Python version $version (>= 3.11 required)"
        else
            print_warn "Python version $version (>= 3.11 recommended)"
        fi
    else
        print_fail "Python 3 not found"
    fi
}

# Check Docker version
check_docker_version() {
    print_check "Docker version"

    if command -v docker &> /dev/null; then
        local version=$(docker --version | awk '{print $3}' | sed 's/,//')
        print_pass "Docker version $version"

        # Check if Docker daemon is running
        if docker info &> /dev/null; then
            print_pass "Docker daemon is running"
        else
            print_fail "Docker daemon is not running"
        fi
    else
        print_fail "Docker not found"
    fi
}

# Check Docker Compose
check_docker_compose() {
    print_check "Docker Compose"

    if docker compose version &> /dev/null; then
        local version=$(docker compose version | awk '{print $4}')
        print_pass "Docker Compose version $version"
    elif command -v docker-compose &> /dev/null; then
        local version=$(docker-compose --version | awk '{print $4}' | sed 's/,//')
        print_pass "Docker Compose version $version"
    else
        print_fail "Docker Compose not found"
    fi
}

# Check Git
check_git() {
    print_check "Git"

    if command -v git &> /dev/null; then
        local version=$(git --version | awk '{print $3}')
        print_pass "Git version $version"

        # Check Git config
        if git config user.name &> /dev/null && git config user.email &> /dev/null; then
            print_pass "Git is configured ($(git config user.name) <$(git config user.email)>)"
        else
            print_warn "Git user name or email not configured"
            print_info "Run: git config --global user.name 'Your Name'"
            print_info "Run: git config --global user.email 'your@email.com'"
        fi
    else
        print_fail "Git not found"
    fi
}

# Check project files
check_project_files() {
    print_header "Project Files"

    local files=(
        "package.json:Package configuration"
        "requirements.txt:Python dependencies"
        ".devcontainer/devcontainer.json:DevContainer config"
        ".devcontainer/Dockerfile:DevContainer image"
        ".devcontainer/docker-compose.yml:Docker Compose config"
        ".env.example:Environment template"
        "Makefile:Make commands"
    )

    for file_info in "${files[@]}"; do
        IFS=':' read -r file desc <<< "$file_info"
        print_check "$desc"

        if [ -f "$file" ]; then
            print_pass "$desc exists"
        else
            print_fail "$desc missing: $file"
        fi
    done
}

# Check npm dependencies
check_npm_dependencies() {
    print_header "Node.js Dependencies"

    if [ -f "package.json" ]; then
        if [ -d "node_modules" ]; then
            print_pass "node_modules directory exists"

            # Check if dependencies are up to date
            if [ "package.json" -nt "node_modules" ]; then
                print_warn "package.json is newer than node_modules - run 'npm install'"
            else
                print_pass "Dependencies appear up to date"
            fi
        else
            print_warn "node_modules not found - run 'npm install'"
        fi
    fi
}

# Check Python dependencies
check_python_dependencies() {
    print_header "Python Dependencies"

    if command -v pip3 &> /dev/null; then
        print_pass "pip3 is available"

        if [ -f "requirements.txt" ]; then
            print_info "Use 'pip install -r requirements.txt' to install dependencies"
        fi
    else
        print_fail "pip3 not found"
    fi
}

# Check environment variables
check_environment() {
    print_header "Environment Configuration"

    if [ -f ".env" ]; then
        print_pass ".env file exists"
    else
        print_warn ".env file not found"
        print_info "Copy .env.example to .env and configure it"
    fi
}

# Check VS Code
check_vscode() {
    print_header "VS Code (Optional)"

    if command -v code &> /dev/null; then
        local version=$(code --version | head -n 1)
        print_pass "VS Code is installed: $version"

        # Check Dev Containers extension
        if code --list-extensions | grep -q "ms-vscode-remote.remote-containers"; then
            print_pass "Dev Containers extension is installed"
        else
            print_warn "Dev Containers extension not installed"
            print_info "Install: code --install-extension ms-vscode-remote.remote-containers"
        fi
    else
        print_warn "VS Code not found (optional for local development)"
    fi
}

# Main execution
main() {
    clear
    print_header "🔍 DevContainer Framework Setup Validation"

    print_header "Core Tools"
    check_command "node" "Node.js"
    check_node_version
    check_command "npm" "npm"
    check_command "python3" "Python 3"
    check_python_version
    check_command "pip3" "pip3"
    check_command "docker" "Docker"
    check_docker_version
    check_docker_compose
    check_git

    print_header "Optional Tools"
    check_command "make" "Make" || true
    check_command "curl" "curl" || true
    check_command "jq" "jq" || true

    check_vscode
    check_project_files
    check_npm_dependencies
    check_python_dependencies
    check_environment

    # Summary
    print_header "📊 Validation Summary"
    echo -e "${GREEN}✅ Passed: $PASS${NC}"
    echo -e "${YELLOW}⚠️  Warnings: $WARN${NC}"
    echo -e "${RED}❌ Failed: $FAIL${NC}"

    echo ""

    if [ $FAIL -eq 0 ]; then
        echo -e "${GREEN}🎉 Your environment is ready!${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Run 'npm install' to install Node.js dependencies"
        echo "  2. Run 'pip install -r requirements.txt' for Python dependencies"
        echo "  3. Copy .env.example to .env and configure it"
        echo "  4. Run 'make start' to start services"
        echo "  5. Run 'make health' to verify everything works"
        echo ""
        exit 0
    else
        echo -e "${RED}⚠️  Some requirements are missing${NC}"
        echo ""
        echo "Please install missing tools and re-run this script."
        echo ""
        exit 1
    fi
}

# Run main function
main
