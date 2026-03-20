# Azure DevOps Pipelines

Reusable Azure DevOps YAML pipeline templates.

## Available Pipelines

| Pipeline | File | Description |
|---|---|---|
| AL Build & Test | `al-pipeline.yml` | Compile, test, and publish AL/BC extensions |
| Docker Build & Deploy | `docker-pipeline.yml` | Build Docker image, push to ACR, deploy to AKS |

## Usage

1. Copy the pipeline YAML to the root (or `.azuredevops/`) of your repository.
2. Create a new pipeline in Azure DevOps pointing to the file.
3. Configure the required variable groups and service connections below.

### Required Service Connections

| Pipeline | Connection Name | Type |
|---|---|---|
| Docker | `acr-service-connection` | Docker Registry (ACR) |

### Required Variable Updates

**docker-pipeline.yml:**
- `containerRegistry` — your ACR hostname (e.g. `myregistry.azurecr.io`)
- `dockerRegistryServiceConnection` — name of your ADO service connection
