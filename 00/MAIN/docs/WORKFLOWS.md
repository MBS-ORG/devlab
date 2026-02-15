# 🔄 Workflow Patterns

## Daily Development Workflow

### Morning Routine
```bash
# 1. Start Codespace (or open local container)
gh codespace create --repo YOUR-REPO

# 2. Container auto-starts all services
# 3. Navigate to workspace
cd /workspace

# 4. Pull latest changes
git pull origin main

# 5. Install dependencies (auto-runs but can manual)
npm install

# 6. Start development
npm run dev
```

### During Development
```bash
# Run tests
npm test

# Lint code
npm run lint

# Build project
npm run build

# Check container health
npm run health-check

# View logs
docker-compose logs -f
```

### End of Day
```bash
# Commit work
git add .
git commit -m "feat: implement feature X"
git push

# Codespace auto-stops after inactivity
# Or manually stop:
gh codespace stop
```

## Pull Request Workflow

### Creating a PR
```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes in isolated container
# 3. Run tests locally
npm test

# 4. Push branch
git push origin feature/new-feature

# 5. Create PR (triggers CI)
gh pr create --title "New Feature" --body "Description"
```

### Reviewing a PR
```bash
# Option 1: Review in new Codespace
gh codespace create --repo YOUR-REPO --branch feature/new-feature

# Option 2: Review locally
gh pr checkout PR_NUMBER
```

### CI/CD Automation
```yaml
# Automatically triggered on PR:
# 1. Build dev container
# 2. Run linters
# 3. Run tests
# 4. Security scan
# 5. Build check
# 6. Report results
```

## Hotfix Workflow

### Emergency Fix
```bash
# 1. Create Codespace from production branch
gh codespace create --repo YOUR-REPO --branch production

# 2. Create hotfix branch
git checkout -b hotfix/critical-bug

# 3. Fix issue
# 4. Test thoroughly
npm test
npm run integration-test

# 5. Deploy (auto-triggers on merge)
git push origin hotfix/critical-bug
gh pr create --base production
```

## Team Collaboration Workflow

### Pair Programming
```bash
# Developer 1: Start Live Share session
# In VS Code: Start Collaboration Session

# Developer 2: Join session
# In VS Code: Join Collaboration Session

# Both developers work in same container
# Changes sync in real-time
```

### Code Review Sessions
```bash
# Reviewer: Open PR in Codespace
gh codespace create --repo YOUR-REPO --ref pr/123

# Run tests, explore code
# Leave comments inline
# Approve or request changes
```

## Onboarding Workflow

### New Team Member
```bash
# Day 1:
# 1. Fork repository
# 2. Click "Code" → "Codespaces" → "Create"
# 3. Wait 30-60 seconds
# 4. Environment ready with:
#    - All tools installed
#    - Dependencies resolved
#    - Services running
#    - Extensions configured

# 5. Start contributing immediately
npm run dev
```

## Deployment Workflow

### Staging Deployment
```bash
# Triggered on merge to develop branch
# 1. Build container
# 2. Run full test suite
# 3. Deploy to staging
# 4. Run smoke tests
# 5. Notify team
```

### Production Deployment
```bash
# Triggered on merge to main branch
# 1. Build production container
# 2. Run all tests
# 3. Security scan
# 4. Deploy to production
# 5. Health check
# 6. Rollback if issues
```

## Maintenance Workflows

### Weekly Tasks
```bash
# Run on schedule (Sunday nights):
# 1. Rebuild dev container images
# 2. Update dependencies
# 3. Security scans
# 4. Clean up old containers
# 5. Generate reports
```

### Dependency Updates
```bash
# Automated via Dependabot:
# 1. Detects outdated dependencies
# 2. Creates PR with updates
# 3. Runs tests automatically
# 4. Merge if passing
```

## Advanced Patterns

### Multi-Branch Development
```bash
# Scenario: Work on multiple features simultaneously

# Feature 1 in Codespace 1
gh codespace create --repo YOUR-REPO --branch feature-1

# Feature 2 in Codespace 2  
gh codespace create --repo YOUR-REPO --branch feature-2

# No conflicts, clean isolation
```

### Debugging Production Issues
```bash
# 1. Replicate prod environment
docker-compose -f docker-compose.prod.yml up

# 2. Enable debug mode
export DEBUG=true

# 3. Attach debugger
node --inspect-brk=0.0.0.0:9229 dist/main.js

# 4. Connect VS Code debugger
# 5. Step through code
```

### Performance Testing
```bash
# Run load tests in container
npm run load-test

# Monitor resources
docker stats

# Profile application
node --prof dist/main.js
```

## Troubleshooting Workflows

### Container Won't Start
```bash
# 1. Check logs
gh codespace logs

# 2. Rebuild container
# In VS Code: Rebuild Container

# 3. Check Docker
docker ps -a
docker logs <container-id>
```

### Service Connection Issues
```bash
# 1. Check service health
bash .devcontainer/scripts/health-check.sh

# 2. Restart services
docker-compose restart

# 3. Check networking
docker network inspect codespace-network
```

### Slow Performance
```bash
# 1. Check resource usage
docker stats

# 2. Clean up volumes
docker volume prune

# 3. Use prebuilt image
# Update devcontainer.json to use ghcr.io image
```
