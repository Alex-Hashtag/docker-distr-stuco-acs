# ACS Student Council Website Docker Deployment

This repository contains all the necessary Docker files to deploy the ACS Student Council website on any Linux server.

## Prerequisites

- Docker and Docker Compose installed on the server
- GitHub credentials with access to the relevant repositories
- SSL certificates (if using HTTPS)

## Setup Instructions

### 1. Configure GitHub Credentials

Create a `.env` file in the root directory with your GitHub credentials:

```bash
# .env file
GITHUB_USERNAME=your_github_username
GITHUB_TOKEN=your_github_token
```

### 2. SSL Certificates (for HTTPS)

Place your SSL certificates in the `docker/ssl` directory:
- `certificate.crt` - Your SSL certificate
- `private.key` - Your private key

If you don't have SSL certificates yet, you can:
- Use Let's Encrypt to generate free certificates
- Remove the SSL-related volumes from docker-compose.yml for HTTP-only deployment

### 3. Build and Deploy

Run the following commands to build and start the services:

```bash
# Build all containers
docker-compose build

# Start the services
docker-compose up -d
```

### 4. Access the Services

- Frontend: http://your-server-ip (or https://your-server-ip)
- Backend API: http://your-server-ip:8080
- Email Service: http://your-server-ip:8081

## Troubleshooting

If you encounter any issues:

1. Check Docker logs:
   ```bash
   docker-compose logs
   ```

2. Verify your GitHub credentials have access to the repositories

3. Ensure all ports are open in your firewall:
   ```bash
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw allow 8080/tcp
   sudo ufw allow 8081/tcp
   ```

## Project Structure

- `docker/` - Contains all Dockerfiles
  - `backend.Dockerfile` - Builds the Java backend service
  - `email-service.Dockerfile` - Builds the email service
  - `frontend.Dockerfile` - Builds the React frontend
  - `nginx.conf` - Nginx configuration for the frontend
  - `ssl/` - Directory for SSL certificates
- `docker-compose.yml` - Defines and configures all services
