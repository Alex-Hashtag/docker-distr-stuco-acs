FROM gradle:8-jdk21-alpine
WORKDIR /app

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

RUN apk add --no-cache git

RUN git clone https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/Alex-Hashtag/email-service.git .

RUN gradle build -x test
EXPOSE 8081
CMD ["java", "-jar", "build/libs/app-mail.jar"]
