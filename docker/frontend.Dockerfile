FROM node:18-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/front-end.git .
RUN npm install --legacy-peer-deps

# Expose and run the dev server
EXPOSE 5173
CMD ["npm", "run", "dev"]  # Runs "vite dev" on port 5173