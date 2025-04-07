FROM gradle:8-jdk21-alpine AS build
WORKDIR /app
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/back-end.git .
RUN gradle build -x test

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]