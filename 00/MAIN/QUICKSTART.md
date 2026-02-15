# 🚀 Quick Start Guide

Get up and running with the Ultra-Automated DevContainer Framework in minutes!

---

## 📋 Prerequisites Check

Before starting, ensure you have:

```bash
# Run the validation script
./scripts/validate-setup.sh
```

This checks for:
- ✅ Node.js 20+
- ✅ Python 3.11+
- ✅ Docker & Docker Compose
- ✅ Git configured

---

## ⚡ Option 1: GitHub Codespaces (Recommended)

**Fastest way to get started - everything is pre-configured!**

### Steps:

1. **Click the Codespaces button** in your GitHub repository
   - Or click: `Code` → `Codespaces` → `Create codespace on main`

2. **Wait 2-3 minutes** while the prebuild completes
   - Container builds automatically
   - All dependencies installed
   - Services start automatically

3. **Start coding!** Everything is ready:
   ```bash
   # Check service health
   make health

   # Run tests
   npm test

   # Start development
   npm run dev
   ```

### What's Included:
- ✅ All development tools pre-installed
- ✅ VS Code extensions automatically loaded
- ✅ Services running (PostgreSQL, Redis, etc.)
- ✅ Git configured and ready

---

## 💻 Option 2: Local Dev Container

**Best for offline development and full control**

### Steps:

1. **Install Prerequisites:**
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [VS Code](https://code.visualstudio.com/)
   - [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. **Clone the Repository:**
   ```bash
   git clone <your-repo-url>
   cd CI-CD
   ```

3. **Open in VS Code:**
   ```bash
   code .
   ```

4. **Reopen in Container:**
   - VS Code will prompt: "Reopen in Container"
   - Or use Command Palette: `Dev Containers: Reopen in Container`

5. **Wait for Container Build:**
   - First build takes ~5-10 minutes
   - Subsequent builds use cache (30-60 seconds)

6. **Verify Setup:**
   ```bash
   make validate  # Validate environment
   make health    # Check services
   ```

---

## 🖥️ Option 3: Local Development (No Container)

**For developers who prefer local setup**

### Steps:

1. **Clone Repository:**
   ```bash
   git clone <your-repo-url>
   cd CI-CD
   ```

2. **Install Dependencies:**
   ```bash
   # Node.js dependencies
   npm install

   # Python dependencies
   pip install -r requirements.txt
   ```

3. **Configure Environment:**
   ```bash
   # Copy environment template
   cp .env.example .env

   # Edit .env with your settings
   nano .env
   ```

4. **Start Services:**
   ```bash
   # Using Docker Compose
   make start

   # Or manually
   docker-compose -f .devcontainer/docker-compose.yml up -d
   ```

5. **Verify Setup:**
   ```bash
   make health
   ```

---

## 🎯 First Steps After Setup

### 1. Explore the Framework

```bash
# View all available commands
make help

# Check environment
make validate

# View service status
make status

# View logs
make logs
```

### 2. Run Tests

```bash
# Run all tests
make test-all

# JavaScript tests only
npm test

# Python tests only
cd python_app && pytest
```

### 3. Start Development

```bash
# Start Node.js application
npm run dev

# Start Python application
cd python_app && uvicorn main:app --reload

# Run both (in separate terminals)
```

### 4. Explore Sample Applications

**Node.js/Express:**
- Location: `src/`
- Start: `npm run dev`
- Test: `npm test`
- Access: http://localhost:3000

**Python/FastAPI:**
- Location: `python_app/`
- Start: `cd python_app && uvicorn main:app --reload`
- Test: `cd python_app && pytest`
- Access: http://localhost:8000
- Docs: http://localhost:8000/docs

---

## 🔧 Essential Commands

### Service Management
```bash
make start          # Start all services
make stop           # Stop all services
make restart        # Restart all services
make logs           # View all logs
make status         # Check service status
```

### Development
```bash
make validate       # Validate setup
make health         # Health checks
make test-all       # Run all tests
make lint-fix       # Lint and fix code
make format         # Format code
make security       # Security scans
```

### Database
```bash
make db-connect     # Connect to PostgreSQL
make db-migrate     # Run migrations
make db-seed        # Seed database
make db-reset       # Reset database
```

### Cleanup
```bash
make clean          # Clean build artifacts
make clean-all      # Clean everything
```

---

## 📊 Monitoring & Observability (Optional)

### Start Monitoring Stack:
```bash
docker-compose \
  -f .devcontainer/docker-compose.yml \
  -f docker-compose.monitoring.yml \
  up -d
```

### Access Dashboards:
- **Grafana**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686

---

## 🐛 Troubleshooting

### Container won't start
```bash
# Check Docker is running
docker info

# Rebuild container
docker-compose -f .devcontainer/docker-compose.yml build --no-cache

# Clean and restart
make clean-all
make start
```

### Services unhealthy
```bash
# Check service logs
make logs

# Restart specific service
docker-compose -f .devcontainer/docker-compose.yml restart postgres

# Run health checks
make health
```

### Tests failing
```bash
# Install dependencies
npm ci
pip install -r requirements.txt

# Clear caches
npm run clean
rm -rf node_modules package-lock.json
npm install
```

### Port conflicts
```bash
# Check what's using ports
lsof -i :3000
lsof -i :5432

# Stop services
make stop

# Restart services
make start
```

---

## 📚 Next Steps

1. **Read Documentation:**
   - [ARCHITECTURE.md](./docs/ARCHITECTURE.md) - System design
   - [WORKFLOWS.md](./docs/WORKFLOWS.md) - CI/CD workflows
   - [CONTRIBUTING.md](./CONTRIBUTING.md) - Contribution guide

2. **Explore Examples:**
   - Check `src/` for Node.js examples
   - Check `python_app/` for Python examples
   - Review tests in `__tests__/` directories

3. **Customize:**
   - Modify `.devcontainer/devcontainer.json`
   - Update `docker-compose.yml` for your needs
   - Add your own services and tools

4. **Deploy:**
   - Push to trigger CI/CD
   - Use GitHub Actions for automation
   - Deploy to your preferred platform

---

## 💡 Pro Tips

- Use `make help` to see all available commands
- Run `make validate` before committing
- Use `make format` to auto-format code
- Check `make security` for vulnerabilities
- Enable pre-commit hooks: `npm run prepare`

---

## 🆘 Need Help?

- 📖 Read [TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)
- 🐛 Open an [Issue](https://github.com/YOUR-ORG/YOUR-REPO/issues)
- 💬 Check [Discussions](https://github.com/YOUR-ORG/YOUR-REPO/discussions)
- 📝 Read [CONTRIBUTING.md](./CONTRIBUTING.md)

---

**Happy Coding! 🎉**
