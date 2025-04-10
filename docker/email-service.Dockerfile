FROM gradle:8-jdk21-alpine
WORKDIR /app

# Copy email service source code
COPY ./email-service/ .

RUN gradle build -x test
EXPOSE 8081
CMD ["java", "-jar", "build/libs/app-mail.jar"]
