FROM node:18-alpine as builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/front-end.git .
RUN npm install --legacy-peer-deps
RUN npm run build

# Use Nginx to serve on port 5173
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./docker/nginx-frontend.conf /etc/nginx/conf.d/default.conf
EXPOSE 5173