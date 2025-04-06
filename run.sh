#!/bin/bash

# Initialize
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
export COMPOSE_HTTP_TIMEOUT=200

# Cleanup old containers
docker-compose down || echo "No existing containers to remove"

# Build and start
echo "Building and starting services..."
docker-compose up -d --build

# Log services
echo "Service status:"
docker-compose ps

# Tail logs
echo -e "\nTailing logs (Ctrl+C to exit)..."
docker-compose logs -f --tail=50 2>&1 | tee "$LOG_DIR/combined.log" &
tail -f "$LOG_DIR/combined.log"