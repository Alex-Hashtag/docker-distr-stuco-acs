# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

RUN apk add --no-cache git

# Clone the repository or use local files if they exist
RUN git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/Alex-Hashtag/front-end.git . || echo "Using provided source files"

RUN npm install --legacy-peer-deps
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl
