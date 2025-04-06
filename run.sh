#!/bin/bash

# Configuration
LOG_DIR="./logs"
TIMEOUT_MINUTES=30
SWAP_LIMIT_MB=1500

# Initialize
mkdir -p "$LOG_DIR"
export COMPOSE_HTTP_TIMEOUT=$((TIMEOUT_MINUTES * 60))

# Colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Live logging function
log_live() {
  while read -r line; do
    # Filter important messages
    if [[ "$line" == *"Step"* || "$line" == *"npm"* || "$line" == *"gradle"* ]]; then
      echo -e "${YELLOW}[BUILD]${NC} $line"
    elif [[ "$line" == *"ERROR"* || "$line" == *"Failed"* ]]; then
      echo -e "${RED}[ERROR]${NC} $line"
    fi
    echo "$line" >> "$LOG_DIR/full.log"
  done
}

# Resource Monitor
start_monitor() {
  echo -e "\n${YELLOW}🖥️  Starting resource monitor...${NC}"
  {
    while true; do
      echo -ne "\r${YELLOW}SYSTEM:${NC} CPU $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.1f%%", usage}') | "
      echo -ne "RAM $(free -m | awk '/Mem:/{printf "%.1fGB/%.1fGB", $3/1024, $2/1024}') | "
      echo -ne "SWAP $(free -m | awk '/Swap:/{printf "%dMB", $3}')"
      sleep 5
    done
  } &
  MONITOR_PID=$!
}

# Cleanup
safe_cleanup() {
  echo -e "\n${YELLOW}🧹 Cleaning up old containers...${NC}"
  docker-compose down 2>&1 | log_live
}

# Build with live feedback
build_services() {
  echo -e "\n${GREEN}🔨 Building services (Timeout: ${TIMEOUT_MINUTES}min)...${NC}"
  timeout ${TIMEOUT_MINUTES}m docker-compose build --progress=plain 2>&1 | log_live
  return $?
}

# Start services
start_services() {
  echo -e "\n${GREEN}🚀 Starting services...${NC}"
  docker-compose up -d 2>&1 | log_live
}

# ========================
# Main Execution
# ========================

clear
echo -e "${GREEN}=== STUCO-ACS Deployment ===${NC}"
echo -e "Start: $(date)\nLogs: $LOG_DIR/"

start_monitor
safe_cleanup

if build_services; then
  if start_services; then
    echo -e "\n${GREEN}✅ Services started successfully!${NC}"
    echo -e "\n${YELLOW}Container status:${NC}"
    docker-compose ps
    
    echo -e "\n${GREEN}📋 Live logs (Ctrl+C to exit):${NC}"
    docker-compose logs -f --tail=10 2>&1 | tee "$LOG_DIR/runtime.log"
  else
    echo -e "\n${RED}❌ Failed to start services!${NC}"
    docker-compose logs --tail=50 > "$LOG_DIR/startup_failure.log"
  fi
else
  echo -e "\n${RED}❌ Build timed out after ${TIMEOUT_MINUTES} minutes!${NC}"
fi

# Cleanup
kill $MONITOR_PID 2>/dev/null
echo -e "\n${GREEN}Deployment ended at: $(date)${NC}"