# GitHub Actions Workflows

Reusable GitHub Actions workflow templates for common CI/CD scenarios.

## Available Workflows

| Workflow | File | Description |
|---|---|---|
| AL Build & Test | `al-build-and-test.yml` | Compile and test AL/BC extensions |
| AL Release | `al-release.yml` | Build and publish AL extension on tag push |
| Docker Build & Push | `docker-build-push.yml` | Multi-arch Docker image build and push to GHCR |
| Node.js CI | `ci-node.yml` | Lint, build, test across Node versions |
| Python CI | `ci-python.yml` | Lint, type-check, test across Python versions |
| Dependabot Auto-merge | `dependabot-automerge.yml` | Auto-merge patch/minor Dependabot PRs |

## Usage

Copy the desired workflow file into your repository's `.github/workflows/` directory and adjust as needed.

### Required Secrets

| Workflow | Secret | Purpose |
|---|---|---|
| AL Build & Test | *(none)* | Uses Windows container locally |
| Docker Build & Push | `GITHUB_TOKEN` (auto) | Push to GHCR |
| Node.js / Python CI | `CODECOV_TOKEN` | Coverage reporting (optional) |
