#!/usr/bin/env bash
# docker-tag-push.sh — Tag a local image and push it to a registry.
#
# Usage:
#   ./docker-tag-push.sh <local-image> <registry/repo> [tag]
#
# Examples:
#   ./docker-tag-push.sh myapp ghcr.io/myorg/myapp 1.2.3
#   ./docker-tag-push.sh myapp ghcr.io/myorg/myapp        # uses 'latest'
#
set -euo pipefail

LOCAL_IMAGE="${1:-}"
REMOTE_REPO="${2:-}"
TAG="${3:-latest}"

if [[ -z "$LOCAL_IMAGE" || -z "$REMOTE_REPO" ]]; then
  sed -n '2,10p' "$0" | sed 's/^# //'
  exit 1
fi

REMOTE_IMAGE="${REMOTE_REPO}:${TAG}"

echo "Tagging  : $LOCAL_IMAGE → $REMOTE_IMAGE"
docker tag "$LOCAL_IMAGE" "$REMOTE_IMAGE"

echo "Pushing  : $REMOTE_IMAGE"
docker push "$REMOTE_IMAGE"

# Also tag and push :latest if a specific tag was given
if [[ "$TAG" != "latest" ]]; then
  LATEST="${REMOTE_REPO}:latest"
  echo "Tagging  : $LOCAL_IMAGE → $LATEST"
  docker tag "$LOCAL_IMAGE" "$LATEST"
  echo "Pushing  : $LATEST"
  docker push "$LATEST"
fi

echo "Done."
