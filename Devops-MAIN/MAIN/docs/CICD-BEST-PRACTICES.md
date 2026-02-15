# 🚀 CI/CD Best Practices

## Prebuild Strategy

### When to Prebuild
✅ **DO prebuild on**:
- Push to `main` and `develop`
- Changes to `.devcontainer/`
- Changes to `package.json` or `requirements.txt`
- Nightly schedule

❌ **DON'T prebuild on**:
- Pull requests (too expensive)
- Feature branches (unless high traffic)
- Documentation-only changes

### Optimization Tips
```yaml
# Cache layers aggressively
cacheFrom:
  - ghcr.io/org/repo:cache
  - ghcr.io/org/repo:latest

# Use BuildKit
DOCKER_BUILDKIT=1

# Multi-stage builds
# Copy only necessary artifacts to final stage
```

## Testing Strategy

### Test in Container
```yaml
# Always test in the SAME environment as production
- name: Run tests
  uses: devcontainers/ci@v0.3
  with:
    imageName: ghcr.io/org/repo-devcontainer
    runCmd: |
      npm ci
      npm test
      npm run build
```

### Matrix Testing
```yaml
strategy:
  matrix:
    node: [18, 20, 22]
    os: [ubuntu-latest, windows-latest, macos-latest]
```

## Security Best Practices

### Image Scanning
```yaml
- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'ghcr.io/org/repo:latest'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'  # Fail on vulnerabilities
```

### Secret Management
```yaml
# Use GitHub Secrets
- name: Deploy
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### SBOM Generation
```yaml
- name: Generate SBOM
  uses: anchore/sbom-action@v0
  with:
    format: spdx-json
    output-file: sbom.spdx.json
```

## Performance Optimization

### Parallel Jobs
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]
  
  test:
    runs-on: ubuntu-latest
    steps: [...]
  
  build:
    needs: [lint, test]  # Only after both pass
    runs-on: ubuntu-latest
    steps: [...]
```

### Caching
```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

## Cost Optimization

### Reduce Build Time
- Use prebuilt images
- Cache Docker layers
- Parallel test execution
- Skip redundant builds

### Manage Storage
```yaml
# Clean up old images
- name: Delete old versions
  uses: actions/delete-package-versions@v4
  with:
    min-versions-to-keep: 3
```

### Smart Triggers
```yaml
# Only on relevant changes
on:
  push:
    paths:
      - 'src/**'
      - 'package.json'
  pull_request:
    paths-ignore:
      - 'docs/**'
      - '**/*.md'
```

## Deployment Patterns

### Blue-Green Deployment
```yaml
- name: Deploy to staging
  run: |
    kubectl set image deployment/app \
      app=ghcr.io/org/repo:${{ github.sha }} \
      --namespace=staging

- name: Run smoke tests
  run: npm run smoke-test

- name: Deploy to production
  if: success()
  run: |
    kubectl set image deployment/app \
      app=ghcr.io/org/repo:${{ github.sha }} \
      --namespace=production
```

### Canary Deployment
```yaml
- name: Deploy 10% traffic
  run: kubectl apply -f k8s/canary-10.yaml

- name: Monitor metrics (15 minutes)
  run: ./scripts/monitor-canary.sh

- name: Deploy 100% if healthy
  if: success()
  run: kubectl apply -f k8s/canary-100.yaml
```

## Monitoring & Alerting

### Build Notifications
```yaml
- name: Notify on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Build failed!'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Metrics Collection
```yaml
- name: Report metrics
  run: |
    echo "build_duration_seconds ${{ job.duration }}" >> metrics.txt
    curl -X POST https://metrics.company.com/api/v1/import \
      --data-binary @metrics.txt
```

## Documentation

### README Badge
```markdown
![CI](https://github.com/org/repo/workflows/CI/badge.svg)
```

### Change Logs
```yaml
- name: Generate changelog
  uses: metcalfc/changelog-generator@v4.0.0
  with:
    myToken: ${{ secrets.GITHUB_TOKEN }}
```

## Compliance

### License Scanning
```yaml
- name: Check licenses
  run: npx license-checker --production --onlyAllow 'MIT;Apache-2.0;BSD'
```

### Audit Logging
```yaml
- name: Log deployment
  run: |
    echo "${{ github.actor }} deployed ${{ github.sha }}" >> audit.log
    aws s3 cp audit.log s3://company-audit-logs/
```

## Rollback Strategy

### Automatic Rollback
```yaml
- name: Deploy
  id: deploy
  run: ./scripts/deploy.sh

- name: Health check
  run: ./scripts/health-check.sh

- name: Rollback on failure
  if: failure()
  run: ./scripts/rollback.sh ${{ steps.deploy.outputs.previous_version }}
```

### Manual Rollback
```bash
# From GitHub UI:
# Actions → Select workflow → Re-run with previous SHA
```

## Team Workflows

### PR Checks
```yaml
# Require all checks to pass
# Settings → Branches → Branch protection rules
# ✓ Require status checks to pass
# ✓ Require branches to be up to date
```

### Auto-merge
```yaml
- name: Auto-merge dependabot
  if: github.actor == 'dependabot[bot]'
  run: gh pr merge --auto --squash
```

## Measuring Success

### Key Metrics
- Build duration
- Test pass rate  
- Deployment frequency
- Mean time to recovery
- Container startup time

### Dashboards
- GitHub Actions insights
- Custom metrics in Grafana
- Cost tracking in billing
