# Getting Started

Welcome to **devlab** — a personal DevOps toolkit containing CI/CD workflows, project templates, boilerplate code, and automation scripts.

## Prerequisites

| Tool | Minimum Version | Install Guide |
|---|---|---|
| Git | 2.40 | [git-scm.com](https://git-scm.com) |
| Docker | 24.x | [docs.docker.com](https://docs.docker.com/get-docker/) |
| Node.js | 20 LTS | [nodejs.org](https://nodejs.org) |
| Python | 3.11+ | [python.org](https://www.python.org) |
| Terraform | 1.7+ | [developer.hashicorp.com](https://developer.hashicorp.com/terraform/install) |
| Azure CLI | 2.55+ | [learn.microsoft.com](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) |

## Clone the Repo

```bash
git clone https://github.com/yourorg/devlab.git
cd devlab
```

## Quick Reference

### Bootstrap a new dev machine

```bash
sudo bash scripts/system/setup-dev-env.sh
```

### Scaffold a new AL extension

```bash
bash scripts/al/al-new-extension.sh \
  --name "My Extension" \
  --publisher "MyPublisher" \
  --output ./my-extension
```

### Clean up Docker resources

```bash
bash scripts/docker/docker-cleanup.sh        # dangling only
bash scripts/docker/docker-cleanup.sh --all  # all unused images
```

### Use a GitHub Actions workflow

1. Browse `workflows/github-actions/`.
2. Copy the relevant `.yml` file into your project's `.github/workflows/` directory.
3. Adjust variables and secrets as described in the workflow's `README.md`.

### Start a new project from a boilerplate

```bash
# Node.js API
cp -r boilerplates/nodejs-api my-new-api
cd my-new-api && npm install

# Python script
cp -r boilerplates/python-script my-new-script
cd my-new-script && pip install -r requirements-dev.txt
```

## Directory Layout

```
devlab/
├── workflows/
│   ├── github-actions/     CI/CD workflow YAML files for GitHub Actions
│   └── azure-devops/       Pipeline YAML files for Azure DevOps
├── templates/
│   ├── al-extension/       Dynamics 365 Business Central AL extension scaffold
│   ├── docker/             Production Dockerfiles and Compose template
│   ├── terraform/          Azure infrastructure-as-code starter
│   └── k8s/                Kubernetes manifests (Deployment, Service, Ingress)
├── boilerplates/
│   ├── nodejs-api/         Express REST API with tests
│   └── python-script/      CLI script with argparse, logging, and pytest
├── scripts/
│   ├── al/                 AL development helpers
│   ├── docker/             Docker utility scripts
│   └── system/             Machine bootstrap scripts
└── docs/                   This documentation
```
