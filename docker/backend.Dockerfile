FROM gradle:8-jdk21-alpine
WORKDIR /app

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

# Install git if not already present
RUN apk add --no-cache git

# Clone with both username + token
RUN git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/Alex-Hashtag/back-end.git .

RUN gradle build -x test
EXPOSE 8080
CMD ["java", "-jar", "build/libs/app.jar"]
