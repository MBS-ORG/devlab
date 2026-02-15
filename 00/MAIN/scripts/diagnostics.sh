#!/bin/bash

echo "=== System Diagnostics ==="
echo ""
echo "Date: $(date)"
echo "User: $(whoami)"
echo "PWD: $(pwd)"
echo ""

echo "=== Docker Info ==="
docker version
docker info
echo ""

echo "=== Running Containers ==="
docker ps
echo ""

echo "=== Docker Networks ==="
docker network ls
echo ""

echo "=== Docker Volumes ==="
docker volume ls
echo ""

echo "=== Disk Usage ==="
df -h
echo ""

echo "=== Container Logs (last 50 lines) ==="
docker-compose logs --tail=50
