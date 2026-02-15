#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Check prerequisites
command -v docker >/dev/null 2>&1 || { echo "❌ Docker not found. Install from https://docker.com"; exit 1; }
command -v code >/dev/null 2>&1 || { echo "❌ VS Code not found. Install from https://code.visualstudio.com"; exit 1; }

# Install Dev Containers extension
code --install-extension ms-vscode-remote.remote-containers

# Copy environment template
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Created .env file"
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open this folder in VS Code"
echo "  2. Click 'Reopen in Container' when prompted"
echo "  3. Wait for container to build (~5 minutes first time)"
echo "  4. Start coding!"
