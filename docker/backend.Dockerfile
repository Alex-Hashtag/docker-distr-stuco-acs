FROM gradle:8-jdk21-alpine AS build
WORKDIR /app
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/back-end.git .
RUN gradle build -x test

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app-mail
COPY --from=build /app/build/libs/app-mail.jar .
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]