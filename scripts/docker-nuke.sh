#!/bin/bash

echo "🚨 WARNING: This will remove ALL Docker containers, images, volumes, and networks."
read -p "Are you sure? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo "🧹 Stopping all containers..."
docker stop $(docker ps -aq) 2>/dev/null

echo "🧨 Removing all containers..."
docker rm -f $(docker ps -aq) 2>/dev/null

echo "🧼 Removing all images..."
docker rmi -f $(docker images -aq) 2>/dev/null

echo "🗑️  Removing all volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null

echo "🔌 Removing all networks (except default ones)..."
docker network rm $(docker network ls | grep -vE "bridge|host|none" | awk '{ print $1 }') 2>/dev/null

echo "♻️  Pruning everything else..."
docker system prune -af --volumes

echo "✅ Docker environment fully cleaned."
