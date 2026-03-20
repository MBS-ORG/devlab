# Scripts

Reference for all automation scripts.

## AL Scripts (`scripts/al/`)

### `al-new-extension.sh`

Scaffolds a new AL extension from the `templates/al-extension/` template.

```bash
bash scripts/al/al-new-extension.sh \
  --name "My Extension" \
  --publisher "MyPublisher" \
  --output ./my-extension   # optional, defaults to ./<slugified-name>
```

**What it does:**
1. Copies the AL extension template to the output directory.
2. Generates a new GUID for `app.json`.
3. Replaces placeholder name and publisher with the provided values.

**Requirements:** `uuidgen` or `python3` (for GUID generation), `bash` 4+.

---

## Docker Scripts (`scripts/docker/`)

### `docker-cleanup.sh`

Removes stopped containers, dangling images, unused volumes and networks.

```bash
bash scripts/docker/docker-cleanup.sh            # remove dangling images only
bash scripts/docker/docker-cleanup.sh --all      # remove all unused images
bash scripts/docker/docker-cleanup.sh --dry-run  # preview without deleting
```

### `docker-tag-push.sh`

Tags a local image and pushes it (plus `:latest`) to a remote registry.

```bash
bash scripts/docker/docker-tag-push.sh <local-image> <registry/repo> [tag]

# Examples
bash scripts/docker/docker-tag-push.sh myapp ghcr.io/myorg/myapp 1.2.3
bash scripts/docker/docker-tag-push.sh myapp ghcr.io/myorg/myapp        # uses 'latest'
```

---

## System Scripts (`scripts/system/`)

### `setup-dev-env.sh`

Bootstraps a fresh Ubuntu/Debian machine with common developer tools.

**Installed by default:**
- Base packages (`git`, `curl`, `jq`, `tmux`, `vim`, etc.)
- Docker CE + Compose plugin
- Node.js (latest LTS via nvm)
- Python 3.12 (via pyenv) + `ruff`, `mypy`, `pipx`

```bash
sudo bash scripts/system/setup-dev-env.sh

# Skip specific components
sudo bash scripts/system/setup-dev-env.sh --skip-docker --skip-node
```

**Flags:** `--skip-docker`, `--skip-node`, `--skip-python`

**Tested on:** Ubuntu 22.04, Ubuntu 24.04, Debian 12.
