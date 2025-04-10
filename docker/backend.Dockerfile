FROM gradle:8-jdk21-alpine
WORKDIR /app

RUN apk add --no-cache git
# Copy backend source code
COPY ./backend/ .

RUN gradle build -x test
EXPOSE 8080
CMD ["java", "-jar", "build/libs/app.jar"]
