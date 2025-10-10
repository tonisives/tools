#!/bin/bash

set -e

NEW_DOCKER_ROOT="/mnt/disks/local-ssd/docker"
OLD_DOCKER_ROOT="/var/lib/docker"

echo "This script will move Docker data to $NEW_DOCKER_ROOT"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

echo "Stopping Docker..."
sudo systemctl stop docker
sudo systemctl stop docker.socket

echo "Creating new Docker directory..."
sudo mkdir -p "$NEW_DOCKER_ROOT"

echo "Creating Docker daemon configuration..."
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "data-root": "$NEW_DOCKER_ROOT",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

if [ -d "$OLD_DOCKER_ROOT" ] && [ "$(ls -A $OLD_DOCKER_ROOT)" ]; then
    echo "Moving existing Docker data from $OLD_DOCKER_ROOT to $NEW_DOCKER_ROOT..."
    sudo rsync -aP "$OLD_DOCKER_ROOT/" "$NEW_DOCKER_ROOT/"
    echo "Data moved successfully"
else
    echo "No existing Docker data found, skipping migration"
fi

echo "Starting Docker..."
sudo systemctl start docker

echo "Verifying new Docker root directory..."
DOCKER_ROOT=$(docker info 2>/dev/null | grep "Docker Root Dir" | awk '{print $4}')

if [ "$DOCKER_ROOT" = "$NEW_DOCKER_ROOT" ]; then
    echo "SUCCESS! Docker is now using: $DOCKER_ROOT"
    echo ""
    echo "You can now remove the old Docker data with:"
    echo "  sudo rm -rf $OLD_DOCKER_ROOT"
else
    echo "WARNING: Docker Root Dir is: $DOCKER_ROOT"
    echo "Expected: $NEW_DOCKER_ROOT"
    exit 1
fi
