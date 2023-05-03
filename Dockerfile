FROM eclipse-temurin:17 as builder
COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .
COPY settings.gradle.kts .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

FROM eclipse-temurin:17
COPY --from=builder build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
