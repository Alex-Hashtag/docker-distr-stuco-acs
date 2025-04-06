#!/bin/bash

# Exit on any error
set -e

# Define log directory
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

# Clean up old containers (optional)
echo "Cleaning up old containers..."
docker-compose down || true

# Build and start services
echo "Building and starting services..."
docker-compose up -d --build

# Follow logs with colored output and save to files
echo "Tailing logs to $LOG_DIR/..."
docker-compose logs -f --tail=50 frontend > "$LOG_DIR/frontend.log" 2>&1 &
docker-compose logs -f --tail=50 backend > "$LOG_DIR/backend.log" 2>&1 &
docker-compose logs -f --tail=50 email-service > "$LOG_DIR/email-service.log" 2>&1 &

# Print access info
echo -e "\n\033[1;32mServices are running!\033[0m"
echo -e "Frontend:    \033[1;34mhttps://stucoacs.com\033[0m"
echo -e "Backend API: \033[1;34mhttps://stucoacs.com/api/\033[0m"
echo -e "Email API:   \033[1;34mhttps://stucoacs.com/email/\033[0m"
echo -e "\nView logs:   \033[1;33mtail -f $LOG_DIR/*.log\033[0m"
echo -e "Stop services: \033[1;33mdocker-compose down\033[0m"

# Attach to the frontend log by default (Ctrl+C to exit)
tail -f "$LOG_DIR/frontend.log"