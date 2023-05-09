FROM ghcr.io/konempty/temp-gradle-cache AS build
COPY . /app
WORKDIR /app

RUN ./gradlew assemble

FROM eclipse-temurin:17.0.7_7-jdk AS run

ENV TZ=Asia/Seoul

## spring 패키지 복사
COPY --from=build \
  /app/build/libs/*.jar \
  /app/app.jar

EXPOSE 8080

ENTRYPOINT ["apt-get", "-y", "update", "&&", "apt-get", "-y", "upgrade"]

ENTRYPOINT ["rm", "/usr/bin/curl"]

ENTRYPOINT
 apt-get -y update &&
 apt-get -y upgrade && \
 java \
-Dspring.profiles.active=${APP_PHASE} \
-jar /app/app.jar
