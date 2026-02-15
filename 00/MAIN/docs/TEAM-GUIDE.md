# 👥 Team Guide

## For New Team Members

### Your First Day

**Morning:**
1. Get GitHub access from team lead
2. Install prerequisites:
   - [VS Code](https://code.visualstudio.com)
   - [GitHub CLI](https://cli.github.com)
3. Clone repository:
   ```bash
   gh repo clone YOUR-ORG/YOUR-REPO
   ```
4. Open in Codespace or local container
5. Read this guide!

**Afternoon:**
1. Complete onboarding tutorial
2. Make your first commit
3. Submit your first PR
4. Join team standup

### Week 1 Checklist
- [ ] Environment setup complete
- [ ] Can run app locally
- [ ] Understand project structure
- [ ] Know where to find docs
- [ ] Met all team members
- [ ] Submitted at least 1 PR

## For Developers

### Daily Workflow
```bash
# Morning
gh codespace create --repo YOUR-REPO  # Or open local
git pull origin main
npm install  # If dependencies changed

# During work
git checkout -b feature/my-feature
# Make changes
npm test  # Test locally
git commit -m "feat: add feature"
git push origin feature/my-feature

# End of day
gh pr create  # Create PR
gh codespace stop  # Or let auto-stop
```

### Code Review Process
1. **Create PR** with clear description
2. **Wait for CI** to pass (auto-runs tests)
3. **Request review** from 2 team members
4. **Address feedback** promptly
5. **Merge** after approval

### Testing Guidelines
- Write tests for new features
- Maintain >80% coverage
- Run tests before pushing
- Fix failing tests immediately

## For Reviewers

### Review Checklist
- [ ] Code follows style guide
- [ ] Tests included and passing
- [ ] Documentation updated
- [ ] No security vulnerabilities
- [ ] Performance acceptable
- [ ] Backwards compatible

### Quick Review Tips
```bash
# Review in Codespace
gh codespace create --repo YOUR-REPO --ref pr/123

# Run tests
npm test

# Check coverage
npm run coverage

# Leave feedback
gh pr review 123 --comment
```

## For Team Leads

### Onboarding New Members
1. Grant GitHub access
2. Add to team Slack channels
3. Assign onboarding buddy
4. Schedule pairing sessions
5. Track progress weekly

### Managing Codespaces
```bash
# View team usage
gh api /orgs/YOUR-ORG/codespaces

# Set org policies
# Settings → Codespaces → Policies

# Monitor costs
# Billing → Codespaces
```

### Performance Reviews
- Pull request activity
- Code review quality
- Test coverage contributions
- Documentation updates

## For DevOps

### Infrastructure Management

**Container Registry:**
```bash
# View images
gh api /orgs/YOUR-ORG/packages

# Clean up old images
gh api -X DELETE /orgs/YOUR-ORG/packages/container/IMAGE/versions/VERSION
```

**Cost Monitoring:**
```bash
# Export usage data
gh api /orgs/YOUR-ORG/settings/billing/usage/codespaces > usage.json

# Analyze trends
python scripts/analyze-usage.py
```

**Security Scanning:**
```bash
# Manual scan
trivy image ghcr.io/org/repo:latest

# View alerts
gh api /repos/YOUR-ORG/YOUR-REPO/security-advisories
```

### Incident Response

**Build Failures:**
1. Check GitHub Actions logs
2. Review recent changes
3. Rollback if necessary
4. Fix and redeploy

**Container Issues:**
1. Check Codespace logs
2. Test locally
3. Rebuild container
4. Update documentation

### Capacity Planning
- Monitor usage trends
- Plan for peak times
- Allocate budget
- Optimize configurations

## Best Practices

### Communication
- **Async-first**: Document decisions
- **Synchronous**: Pair programming, urgent issues
- **Tools**: Slack, GitHub, Zoom

### Documentation
- Keep docs up-to-date
- Document the "why", not just "how"
- Include examples
- Review quarterly

### Code Quality
- Follow style guide
- Use linters/formatters
- Write meaningful commits
- Review own code first

### Collaboration
- Pair program weekly
- Share knowledge
- Celebrate wins
- Learn from mistakes

## Resources

### Internal
- Team Wiki: [Link]
- Slack Channels:
  - `#dev-general`
  - `#dev-environment`
  - `#help-desk`
- Office Hours: Tuesdays 2-3 PM

### External
- [Dev Containers Docs](https://containers.dev)
- [GitHub Codespaces](https://github.com/features/codespaces)
- [VS Code Docs](https://code.visualstudio.com/docs)

### Training
- Internal training portal
- Conference talks
- Online courses
- Certification programs

## FAQ

**Q: Can I work offline?**
A: Yes, with local dev containers. Codespaces require internet.

**Q: How much does Codespaces cost?**
A: See [pricing](https://github.com/features/codespaces). Team has 60 free hours/month.

**Q: Can I customize my environment?**
A: Yes, use dotfiles for personal settings. Don't modify shared configs.

**Q: What if I break something?**
A: Containers are disposable. Delete and create new one.

**Q: Who do I ask for help?**
A: Post in #help-desk Slack. Tag @devops for infra issues.

## Emergency Contacts

- **Platform Issues**: platform@company.com
- **Security Issues**: security@company.com  
- **On-call Engineer**: [PagerDuty Link]
- **Manager**: manager@company.com
