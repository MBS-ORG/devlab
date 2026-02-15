# 🔧 Troubleshooting Guide

## Common Issues & Solutions

### Issue: Container Build Fails

**Symptoms**: Error during `docker build` or Codespace creation

**Possible Causes**:
1. Network issues downloading dependencies
2. Dockerfile syntax errors
3. Missing base image
4. Insufficient disk space

**Solutions**:
```bash
# Check Docker is running
docker info

# Clear build cache
docker builder prune -a

# Check disk space
df -h

# Rebuild with no cache
docker build --no-cache -t devcontainer .

# Check network
curl -I https://registry.npmjs.org
```

### Issue: Services Won't Start

**Symptoms**: PostgreSQL, Redis, or other services not responding

**Possible Causes**:
1. Port conflicts
2. Insufficient memory
3. Volume permission issues

**Solutions**:
```bash
# Check service logs
docker-compose logs postgres

# Restart services
docker-compose restart

# Check port usage
lsof -i :5432

# Increase memory limit
# Edit docker-compose.yml memory settings

# Fix volume permissions
sudo chown -R 1000:1000 ./data
```

### Issue: Slow Container Performance

**Symptoms**: Sluggish response, high CPU/memory usage

**Possible Causes**:
1. Bind mount performance on Windows/macOS
2. Too many running containers
3. Resource limits too low

**Solutions**:
```bash
# Use named volumes for dependencies
# Already configured in docker-compose.yml

# Stop unused containers
docker ps -a
docker stop $(docker ps -aq)

# Increase resource limits
# Edit devcontainer.json hostRequirements

# Use cached mounts
# Add :cached to volume mounts
```

### Issue: Port Forwarding Not Working

**Symptoms**: Can't access services on localhost

**Possible Causes**:
1. Ports not forwarded
2. Service not listening on 0.0.0.0
3. Firewall blocking

**Solutions**:
```bash
# Check forwarded ports
gh codespace ports

# Forward port manually
gh codespace ports forward 3000:3000

# Check service bindings
netstat -tulpn | grep :3000

# Update devcontainer.json
# Add port to "forwardPorts" array
```

### Issue: Extensions Not Working

**Symptoms**: VS Code extensions missing or broken

**Possible Causes**:
1. Extension not compatible with remote
2. Missing dependencies
3. Extension not in devcontainer.json

**Solutions**:
```bash
# Rebuild container
# VS Code: Dev Containers: Rebuild Container

# Add extension to devcontainer.json
# "extensions": ["publisher.extension-id"]

# Check extension compatibility
# Visit extension page on marketplace

# Install manually
code --install-extension publisher.extension-id
```

### Issue: Git Authentication Fails

**Symptoms**: Can't push/pull from Git

**Possible Causes**:
1. SSH keys not mounted
2. Git credentials not configured
3. GitHub token expired

**Solutions**:
```bash
# Check SSH keys
ls -la ~/.ssh

# Add SSH key mount to devcontainer.json
# Already configured

# Configure Git credentials
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Use GitHub CLI
gh auth login

# Check token
gh auth status
```

### Issue: Database Connection Fails

**Symptoms**: App can't connect to PostgreSQL

**Possible Causes**:
1. Database not ready
2. Wrong connection string
3. Network configuration

**Solutions**:
```bash
# Wait for database
until pg_isready -h postgres; do sleep 1; done

# Check connection string
echo $DATABASE_URL

# Test connection
psql $DATABASE_URL -c "SELECT 1"

# Check database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Issue: Disk Space Full

**Symptoms**: Can't write files, builds fail

**Possible Causes**:
1. Docker images accumulating
2. Old containers not cleaned
3. Large log files

**Solutions**:
```bash
# Check disk usage
df -h

# Clean Docker system
docker system prune -a --volumes

# Remove unused images
docker image prune -a

# Clean npm cache
npm cache clean --force

# Check large files
du -sh /* | sort -h
```

### Issue: Environment Variables Not Set

**Symptoms**: App config missing, services unavailable

**Possible Causes**:
1. .env file not copied
2. Variables not in devcontainer.json
3. Syntax errors in .env

**Solutions**:
```bash
# Check environment
printenv

# Copy .env.example
cp .env.example .env

# Add to devcontainer.json
# "containerEnv": { "VAR": "value" }

# Rebuild container
# Variables set on creation
```

## Debugging Tips

### Enable Verbose Logging
```bash
# Docker
export DOCKER_BUILDKIT_PROGRESS=plain

# npm
npm install --verbose

# Node.js
DEBUG=* node app.js
```

### Inspect Containers
```bash
# List all containers
docker ps -a

# Inspect container
docker inspect <container-id>

# Execute commands in container
docker exec -it <container-id> bash

# View logs
docker logs <container-id> --tail 100 -f
```

### Network Debugging
```bash
# Check connectivity
ping postgres
curl http://elasticsearch:9200

# List networks
docker network ls

# Inspect network
docker network inspect codespace-network

# Test DNS
nslookup postgres
```

## Getting Help

### Internal Resources
- Architecture documentation: `docs/ARCHITECTURE.md`
- Workflow guide: `docs/WORKFLOWS.md`
- Team wiki: [Internal Link]

### External Resources
- [Dev Containers Docs](https://containers.dev/)
- [GitHub Codespaces Docs](https://docs.github.com/codespaces)
- [Docker Docs](https://docs.docker.com/)

### Reporting Issues
```bash
# Collect diagnostic info
bash .devcontainer/scripts/diagnostics.sh > diagnostics.txt

# Create issue
gh issue create --title "Bug: Description" --body @diagnostics.txt
```

### Emergency Contacts
- DevOps Team: devops@company.com
- Platform Support: platform@company.com
- On-call: [PagerDuty Link]
