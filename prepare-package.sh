#!/bin/bash
set -e

echo "Preparing docker-distr package for deployment..."

# Create required directories if they don't exist
mkdir -p frontend
mkdir -p backend
mkdir -p email-service
mkdir -p ssl

# Instructions for copying source code
echo "INSTRUCTIONS:"
echo "=============="
echo "1. Copy your frontend source code to the 'frontend' directory"
echo "2. Copy your backend source code to the 'backend' directory"
echo "3. Copy your email-service source code to the 'email-service' directory"
echo "4. Copy your SSL certificates (fullchain.pem and privkey.pem) to the 'ssl' directory"
echo ""
echo "Your directory structure should look like this:"
echo "docker-distr/"
echo "├── docker/"
echo "│   ├── frontend.Dockerfile"
echo "│   ├── backend.Dockerfile"
echo "│   ├── email-service.Dockerfile"
echo "│   └── nginx.conf"
echo "├── frontend/"
echo "├── backend/"
echo "├── email-service/"
echo "├── ssl/"
echo "│   ├── fullchain.pem"
echo "│   └── privkey.pem"
echo "├── docker-compose.yml"
echo "└── README.md"
echo ""
echo "Once your files are in place, transfer the entire docker-distr directory to your remote server."
echo "Then run: docker-compose up -d"
