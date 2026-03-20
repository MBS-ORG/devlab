# Docker Templates

Production-ready Dockerfile and Compose templates.

## Files

| File | Description |
|---|---|
| `Dockerfile.node` | Multi-stage Node.js 20 image (Alpine, non-root) |
| `Dockerfile.python` | Multi-stage Python 3.12 image (slim, non-root) |
| `docker-compose.yml` | Full stack: app + PostgreSQL + Redis + Nginx |
| `.env.example` | Environment variable template |

## Usage

### Single Container

```bash
# Node
cp Dockerfile.node <project>/Dockerfile

# Python
cp Dockerfile.python <project>/Dockerfile
```

### Full Stack (Compose)

```bash
cp docker-compose.yml .env.example <project>/
cd <project>
cp .env.example .env
# Edit .env with real values
docker compose up -d
```

## Security Notes

- Both Dockerfiles run as **non-root** users (UID 1001).
- Multi-stage builds exclude build tools from the final image.
- All secrets must be provided via environment variables — never baked into the image.
- Healthchecks are configured on all services.

## Customisation Checklist

- [ ] Replace image name in `docker-compose.yml`
- [ ] Generate strong passwords/secrets in `.env`
- [ ] Add SSL certificate files for Nginx
- [ ] Adjust exposed ports if needed
- [ ] Review resource limits (add `deploy.resources` blocks for production)
