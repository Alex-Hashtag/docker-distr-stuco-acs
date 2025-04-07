FROM gradle:8-jdk21-alpine AS build
WORKDIR /app
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/back-end.git .
RUN gradle build -x test

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
# Copy only the main application JAR (adjust the filename pattern if needed)
COPY --from=build /app/build/libs/back-end-*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]