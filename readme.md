# STUCO-ACS Docker Deployment

![Docker](https://img.shields.io/badge/Docker-3.0+-blue)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1-green)
![React](https://img.shields.io/badge/React-18+-61dafb)

## 📝 Overview
Production-ready Docker setup for:
- Frontend (React/Vite)
- Backend (Spring Boot)
- Email Service (Spring Boot)


## 🚀 Quick Start
```bash
git clone https://github.com/Alex-Hashtag/docker-distr-stuco-acs.git
cd docker-distr-stuco-acs
chmod +x run.sh
./run.sh
```

## 🔧 Update Procedures

### After Code Changes in Sub-Projects
1. **Pull latest changes**:
   ```bash
   # From host machine:
   cd ~/docker-distr-stuco-acs
   docker-compose down

   # For each sub-project (front-end, back-end, email-service):
   git -C src/frontend pull origin main
   git -C src/backend pull origin main
   git -C src/email-service pull origin main
   ```

2. **Rebuild affected services**:
   ```bash
   # Rebuild all:
   ./run.sh

   # Or rebuild specific service:
   docker-compose up -d --build frontend
   ```

### Dependency Updates
```bash
# Frontend (npm):
docker-compose exec frontend npm update --legacy-peer-deps

# Backend (Gradle):
docker-compose exec backend gradle dependencies --update-locks
```

## ⚠️ Common Issues & Fixes

### Slow First Build
- **Symptom**: Stuck on `npm install` or `gradle build`
- **Solution**: Wait 5-15 minutes (initial Gradle/NPM setup)
- **Verify**: Check CPU usage with `htop`

### Port Conflicts
```bash
sudo lsof -i :80 # Check port usage
sudo kill -9 <PID> # Free port
```

### Docker Permission Issues
```bash
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER
newgrp docker
```

## 📦 Service Details

| Service        | Internal Port | External URL               | Logs                  |
|----------------|---------------|----------------------------|-----------------------|
| Frontend       | 80            | `https://stucoacs.com`     | `logs/frontend.log`   |
| Backend        | 8080          | `https://stucoacs.com/api` | `logs/backend.log`    |
| Email Service  | 8081          | `https://stucoacs.com/email` | `logs/email-service.log` |

## 🔄 Maintenance Commands

```bash
# View running containers:
docker ps

# Access service shells:
docker-compose exec frontend sh
docker-compose exec backend bash

# Full system reset:
docker system prune -a --volumes
```

## 📧 Support
Contact: **Alexander Mihaylov**  
Email: [aleksmihailov2015@gmail.com](mailto:aleksmihailov2015@gmail.com)

## 🗓️ Last Updated
2023-12-01

## 🔒 Security Note
Remember to:
1. Rotate GitHub tokens regularly
2. Update `.env` files with production credentials
3. Restrict Docker API access
```