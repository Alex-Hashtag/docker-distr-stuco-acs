FROM gradle:8-jdk21-alpine
WORKDIR /app

ARG GITHUB_TOKEN
RUN git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/" && \
    git clone https://github.com/Alex-Hashtag/email-service.git .

RUN gradle build -x test
EXPOSE 8081
CMD ["java", "-jar", "build/libs/app-mail.jar"]
