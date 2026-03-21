# Templates

Reference for all project templates.

## AL Extension (`templates/al-extension/`)

A minimal Dynamics 365 Business Central AL extension scaffold.

| File | Purpose |
|---|---|
| `app.json` | Extension manifest — update ID, name, publisher, version, idRanges |
| `HelloWorld.Page.al` | Sample Card page object |
| `HelloWorldTest.Codeunit.al` | Sample test codeunit |
| `.gitignore` | Ignores compiler cache, symbols, output, and artefacts |

**BC Version:** Targets BC 23 (2024 Wave 1). Update `platform`, `application`, and `runtime` in `app.json` for other versions.

**ID Ranges:** Uses `50000–50099` as placeholder. Replace with your licensed range before publishing.

See `templates/al-extension/README.md` for step-by-step setup.

---

## Docker (`templates/docker/`)

| File | Purpose |
|---|---|
| `Dockerfile.node` | Multi-stage Node.js 20 Alpine image, non-root user |
| `Dockerfile.python` | Multi-stage Python 3.12 slim image, non-root user |
| `docker-compose.yml` | Full stack: App + PostgreSQL 16 + Redis 7 + Nginx |
| `.env.example` | Environment variable template — copy to `.env` |

**Security hardening applied:**
- Multi-stage builds (build tools excluded from final image)
- Non-root users (UID 1001)
- Healthchecks on all services
- Secrets via env vars only (never baked in)

---

## Terraform / Azure (`templates/terraform/`)

Provisions: Resource Group, Storage Account (GRS in prod / LRS elsewhere), Key Vault.

| File | Purpose |
|---|---|
| `main.tf` | Resource definitions |
| `variables.tf` | Input variables with validation |
| `outputs.tf` | Output values |
| `terraform.tfvars.example` | Variable values template |

**Notable features:**
- Storage Account: blob versioning, soft-delete, shared-key access disabled
- Key Vault: network ACL deny-by-default, purge protection on prod
- Random suffix prevents naming conflicts across deployments

See `templates/terraform/README.md` for remote state setup.

---

## Kubernetes (`templates/k8s/`)

| File | Purpose |
|---|---|
| `deployment.yml` | Deployment with rolling update strategy, probes, resource limits |
| `service.yml` | ClusterIP Service |
| `ingress.yml` | NGINX Ingress with cert-manager TLS |

**Security hardening applied:**
- `runAsNonRoot: true`, `runAsUser: 1001`
- `readOnlyRootFilesystem: true`
- All Linux capabilities dropped
- `allowPrivilegeEscalation: false`
- `topologySpreadConstraints` for HA across nodes
