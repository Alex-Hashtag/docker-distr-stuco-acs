FROM gradle:8-jdk21-alpine
WORKDIR /app

RUN apk add --no-cache git
# Copy email service source code

RUN gradle build -x test
EXPOSE 8081
CMD ["java", "-jar", "build/libs/app-mail.jar"]
