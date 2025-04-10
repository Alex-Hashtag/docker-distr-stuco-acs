# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/front-end.git .
RUN npm install --legacy-peer-deps
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Create SSL directory (certificates will be mounted at runtime)
RUN mkdir -p /etc/nginx/ssl
