# Kubernetes Manifests Template

Production-ready Kubernetes manifest templates.

## Files

| File | Description |
|---|---|
| `deployment.yml` | Deployment with rolling update, health probes, resource limits, security context |
| `service.yml` | ClusterIP Service |
| `ingress.yml` | NGINX Ingress with TLS (cert-manager) |

## Security Features

- Non-root user (UID 1001)
- Read-only root filesystem
- All Linux capabilities dropped
- `allowPrivilegeEscalation: false`

## Customisation Checklist

- [ ] Replace `myapp` with your app name
- [ ] Update `image` with your registry/image
- [ ] Set `replicas` appropriate for your workload
- [ ] Update `host` in `ingress.yml`
- [ ] Create secret `myapp-secrets` with required keys
- [ ] Adjust resource `requests` and `limits`
- [ ] Update `cert-manager.io/cluster-issuer` annotation if needed

## Apply

```bash
kubectl apply -f .
```
