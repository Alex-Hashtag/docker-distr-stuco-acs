FROM node:18-alpine as builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/front-end.git .
RUN npm install --legacy-peer-deps
RUN npm run build

FROM nginx:alpine

# Remove the default config (this is the key fix!)
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom config
COPY docker/nginx-frontend.conf /etc/nginx/conf.d/
EXPOSE 80