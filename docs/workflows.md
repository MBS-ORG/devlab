# Workflows

Detailed reference for all CI/CD workflow templates.

## GitHub Actions

All files live in `workflows/github-actions/`.

---

### `al-build-and-test.yml`

Compiles an AL extension and runs tests on every push and pull request.

**Trigger:** Push to `main`/`master`/`develop` (`.al` or `app.json` changes), pull requests.

**Requires:** Windows runner (uses BcContainerHelper PowerShell module).

**Artifacts produced:**
- `<publisher>_<name>_<version>` — compiled `.app` file
- `test-results` — XUnit XML results

**Usage:**
```bash
cp workflows/github-actions/al-build-and-test.yml .github/workflows/
```

---

### `al-release.yml`

Builds the AL extension and creates a GitHub Release on version tag push.

**Trigger:** Push of tags matching `v*.*.*`.

**Artifacts produced:** GitHub Release with attached `.app` file.

**Pre-release detection:** Tags containing `-rc` or `-beta` are marked as pre-release.

---

### `docker-build-push.yml`

Builds a multi-architecture Docker image and pushes to GitHub Container Registry (GHCR).

**Trigger:** Push to `main`/`master`, tags `v*.*.*`, pull requests (build only, no push).

**Platforms:** `linux/amd64`, `linux/arm64`.

**Cache:** GitHub Actions cache (`type=gha`).

**Tags applied:**
| Trigger | Tag |
|---|---|
| Branch push | `branch-name` |
| PR | `pr-123` |
| Version tag | `1.2.3`, `1.2` |
| Push to `main` | `latest` |

---

### `ci-node.yml`

Lint, build, and test a Node.js project across multiple Node versions.

**Trigger:** Push and PR to `main`/`master`/`develop`.

**Matrix:** Node 18.x, 20.x, 22.x.

**Steps:** Install → Lint → Build → Test → Upload coverage (Node 20 only).

---

### `ci-python.yml`

Lint, type-check, and test a Python project.

**Trigger:** Push and PR to `main`/`master`/`develop`.

**Matrix:** Python 3.11, 3.12, 3.13.

**Tools:** `ruff` (lint + format), `mypy` (types), `pytest --cov` (tests + coverage).

---

### `dependabot-automerge.yml`

Automatically merges Dependabot PRs for patch and minor updates.

**Trigger:** Pull requests from `dependabot[bot]`.

**Merges:** `semver-patch` and `semver-minor` updates only (major updates require manual review).

---

## Azure DevOps

All files live in `workflows/azure-devops/`.

---

### `al-pipeline.yml`

Two-stage pipeline: Build (compile + test) → Release (publish to Azure Artifacts feed).

**Stages:**
1. **Build** — Compiles AL, runs tests, publishes artifacts.
2. **Release** — Runs only on `main` branch; publishes app to a Universal Package feed.

**Configure:**
- Update the Universal Package feed name in the Deploy step.

---

### `docker-pipeline.yml`

Build Docker image, push to Azure Container Registry, deploy to AKS.

**Stages:**
1. **Build** — `docker buildAndPush` to ACR.
2. **Deploy** — `KubernetesManifest` deploy using manifests in `manifests/`.

**Configure:**
- `containerRegistry` variable — your ACR hostname.
- `dockerRegistryServiceConnection` — ADO service connection name.
- Place `deployment.yml` and `service.yml` in a `manifests/` folder.
