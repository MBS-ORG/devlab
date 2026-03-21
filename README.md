# devlab

> Personal home DevOps toolkit — CI/CD workflows, project templates, boilerplates, and automation scripts.

---

## Contents

| Directory | Description |
|---|---|
| [`workflows/github-actions/`](workflows/github-actions/) | GitHub Actions CI/CD workflow templates |
| [`workflows/azure-devops/`](workflows/azure-devops/) | Azure DevOps YAML pipeline templates |
| [`templates/al-extension/`](templates/al-extension/) | Dynamics 365 Business Central AL extension scaffold |
| [`templates/docker/`](templates/docker/) | Production Dockerfiles and Compose stack |
| [`templates/terraform/`](templates/terraform/) | Azure infrastructure-as-code starter |
| [`templates/k8s/`](templates/k8s/) | Kubernetes manifests (Deployment, Service, Ingress) |
| [`boilerplates/nodejs-api/`](boilerplates/nodejs-api/) | Express REST API with tests |
| [`boilerplates/python-script/`](boilerplates/python-script/) | Python CLI script with argparse and pytest |
| [`scripts/al/`](scripts/al/) | AL development helpers |
| [`scripts/docker/`](scripts/docker/) | Docker utility scripts |
| [`scripts/system/`](scripts/system/) | Machine bootstrap scripts |
| [`docs/`](docs/) | Full reference documentation |

---

## Quick Start

```bash
git clone https://github.com/yourorg/devlab.git
cd devlab
```

### Scaffold a new AL extension

```bash
bash scripts/al/al-new-extension.sh \
  --name "My Extension" \
  --publisher "MyPublisher"
```

### Start a new Node.js API

```bash
cp -r boilerplates/nodejs-api my-api && cd my-api
npm install && npm run dev
```

### Start a new Python script

```bash
cp -r boilerplates/python-script my-script && cd my-script
pip install -r requirements-dev.txt && python main.py --help
```

### Add a CI workflow to any repo

```bash
# AL build + test
cp workflows/github-actions/al-build-and-test.yml <repo>/.github/workflows/

# Docker build + push
cp workflows/github-actions/docker-build-push.yml <repo>/.github/workflows/
```

---

## Documentation

- [Getting Started](docs/getting-started.md)
- [Workflows Reference](docs/workflows.md)
- [Templates Reference](docs/templates.md)
- [Boilerplates Reference](docs/boilerplates.md)
- [Scripts Reference](docs/scripts.md)

---

## Highlights

- **AL/Business Central** — extension scaffold, CI/CD workflows for compilation, testing, and GitHub releases.
- **Docker** — multi-stage, multi-arch, non-root images with healthchecks; full Compose stack.
- **Terraform** — Azure RG + Storage + Key Vault with security best practices (deny-by-default, purge protection).
- **Kubernetes** — hardened manifests (non-root, read-only FS, capabilities dropped, topology spread).
- **GitHub Actions** — Node.js, Python, Docker, AL, Dependabot auto-merge.
- **Azure DevOps** — AL build/release pipeline, Docker → AKS pipeline.
- **Scripts** — dev machine bootstrap, Docker cleanup/push helpers, AL scaffold generator.
