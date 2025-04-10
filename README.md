# ACS Student Council Website Docker Distribution

This package contains everything needed to deploy the ACS Student Council website on a remote Linux server.

## Prerequisites

- Docker
- Docker Compose (v3.8+)
- SSL certificates (for HTTPS)

## Setup Instructions

### 1. Prepare the Package

Run the included preparation script:

```bash
chmod +x prepare-package.sh
./prepare-package.sh
```

This script will create the necessary directory structure and provide guidance on where to place your files.

### 2. Copy Your Source Code and Assets

- Copy your frontend code to the `frontend/` directory
- Copy your backend code to the `backend/` directory  
- Copy your email service code to the `email-service/` directory
- Copy your SSL certificates to the `ssl/` directory:
  - `fullchain.pem` - Your SSL certificate chain
  - `privkey.pem` - Your SSL private key

### 3. Transfer to Remote Server

Transfer the entire `docker-distr` directory to your remote Linux server:

```bash
# Example using scp
scp -r docker-distr user@remote-server:/path/to/destination
```

### 4. Build and Run

SSH into your remote server, navigate to the docker-distr directory, and run:

```bash
cd /path/to/docker-distr
docker-compose up -d
```

This will build all services and start them in detached mode.

### 5. Verify Deployment

Access your website:
- Frontend: https://your-server-domain
- Backend API: https://your-server-domain/api
- Email service: Internal port 8081

## Troubleshooting

- **SSL Issues**: Make sure your SSL certificates are correctly named and placed in the ssl/ directory
- **Build Failures**: Check the logs with `docker-compose logs [service-name]`
- **Port Conflicts**: Ensure ports 80, 443, 8080, and 8081 are available on your server

## Services

- **Frontend**: Nginx serving the React application
- **Backend**: Java Spring Boot API
- **Email Service**: Java service for email functionality

## Maintenance

To update any service, replace the code in its respective directory and rebuild:

```bash
docker-compose build [service-name]
docker-compose up -d
```
