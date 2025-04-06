# Configuration
LOG_DIR="./logs"
TIMEOUT_MINUTES=30
SWAP_LIMIT_MB=1500
MAX_RETRIES=2

# Initialize
mkdir -p "$LOG_DIR"
export COMPOSE_HTTP_TIMEOUT=$((TIMEOUT_MINUTES * 60))

# Resource Monitor (runs in background)
start_monitor() {
  echo -e "\n🖥️  Starting resource monitor..."
  {
    echo "Timestamp,CPU%,Memory(MB),Swap(MB),DiskIO(kB/s)"
    while true; do
      stats=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
      mem=$(free -m | awk '/Mem:/{print $3}')
      swap=$(free -m | awk '/Swap:/{print $3}')
      io=$(iostat -d -k | awk '/^[v|s]d/{print $4}')
      echo "$(date '+%H:%M:%S'),$stats,$mem,$swap,$io"
      sleep 5
    done
  } > "$LOG_DIR/resources.csv" &
  MONITOR_PID=$!
}

# Cleanup with retries
safe_cleanup() {
  echo -e "\n🧹 Cleaning up..."
  for i in $(seq 1 $MAX_RETRIES); do
    docker-compose down && break || {
      echo "Attempt $i failed. Retrying..."
      sleep 5
    }
  done
}

# Build with timeout
build_with_timeout() {
  echo -e "\n🔨 Building services (Timeout: ${TIMEOUT_MINUTES}min)..."
  timeout ${TIMEOUT_MINUTES}m docker-compose build --progress=plain 2>&1 | tee "$LOG_DIR/build.log"
  return $?
}

# Main execution
try_up() {
  echo -e "\n🚀 Starting services..."
  docker-compose up -d
}

# ========================
# Execution Flow
# ========================
start_monitor

echo "=== STUCO-ACS Deployment ==="
echo "Start: $(date)"
echo "Logs: $LOG_DIR/"

safe_cleanup

if build_with_timeout; then
  if try_up; then
    echo -e "\n✅ Services started successfully!"
    echo "Service status:"
    docker-compose ps
    
    echo -e "\n📋 Tailing logs (Ctrl+C to exit)..."
    docker-compose logs -f --tail=50 2>&1 | tee "$LOG_DIR/runtime.log" &
    tail -f "$LOG_DIR/runtime.log"
  else
    echo -e "\n❌ Failed to start services!"
    docker-compose logs > "$LOG_DIR/startup_failure.log"
  fi
else
  echo -e "\n❌ Build timed out after ${TIMEOUT_MINUTES} minutes!"
  echo "Check $LOG_DIR/build.log for details"
fi

# Cleanup
kill $MONITOR_PID 2>/dev/null
echo -e "\nDeployment ended at: $(date)"