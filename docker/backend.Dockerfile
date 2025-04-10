FROM gradle:8-jdk21-alpine
WORKDIR /app
RUN git clone https://Alex-Hashtag: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@github.com/Alex-Hashtag/back-end.git .
RUN gradle build -x test
EXPOSE 8080
CMD ["java", "-jar", "build/libs/app.jar"]