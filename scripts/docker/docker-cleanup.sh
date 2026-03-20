#!/usr/bin/env bash
# docker-cleanup.sh — Remove stopped containers, dangling images, unused volumes/networks.
#
# Usage:
#   ./docker-cleanup.sh [--all] [--dry-run]
#
# Options:
#   --all     Also remove unused images (not just dangling ones)
#   --dry-run Print what would be removed without actually doing it
#
set -euo pipefail

ALL=false
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --all)     ALL=true ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help)
      sed -n '2,10p' "$0" | sed 's/^# //'
      exit 0 ;;
  esac
done

run() {
  if "$DRY_RUN"; then
    echo "[DRY RUN] $*"
  else
    eval "$@"
  fi
}

echo "=== Docker Cleanup ==="
[[ "$DRY_RUN" == true ]] && echo "(dry-run mode — nothing will be deleted)"
echo

# Stopped containers
STOPPED=$(docker ps -aq --filter status=exited --filter status=created 2>/dev/null || true)
if [[ -n "$STOPPED" ]]; then
  echo "Removing stopped containers..."
  run "docker rm $STOPPED"
else
  echo "No stopped containers."
fi

# Dangling images
DANGLING=$(docker images -qf dangling=true 2>/dev/null || true)
if [[ -n "$DANGLING" ]]; then
  echo "Removing dangling images..."
  run "docker rmi $DANGLING"
else
  echo "No dangling images."
fi

# All unused images
if "$ALL"; then
  echo "Removing all unused images..."
  run "docker image prune -a -f"
fi

# Unused volumes
echo "Removing unused volumes..."
run "docker volume prune -f"

# Unused networks
echo "Removing unused networks..."
run "docker network prune -f"

echo
echo "Done."
docker system df 2>/dev/null || true
