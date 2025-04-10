# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git

ARG GITHUB_TOKEN
RUN git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/" && \
    git clone https://github.com/Alex-Hashtag/front-end.git .

RUN npm install --legacy-peer-deps
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl
