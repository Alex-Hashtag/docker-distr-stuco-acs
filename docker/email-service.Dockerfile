FROM gradle:8-jdk21-alpine AS build
WORKDIR /app
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/email-service.git .
RUN gradle build -x test

FROM eclipse-temurin:21-jdk-alpine  # Changed to JDK 21 to match build stage
WORKDIR /app
# Copy only the main application JAR (adjust the filename pattern if needed)
COPY --from=build /app/build/libs/email-service-*.jar app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]