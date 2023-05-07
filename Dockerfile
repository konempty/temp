FROM ghcr.io/konempty/temp-gradle-cache:${APP_PHASE} AS build
COPY . /app
WORKDIR /app


RUN ./gradlew assemble

FROM eclipse-temurin:17.0.7_7-jdk AS run

ENV TZ=Asia/Seoul

RUN apt-get -y update && \
    apt-get -y upgrade

## spring 패키지 복사
COPY --from=build \
  /app/build/libs/*.jar \
  /app/app.jar

EXPOSE 8080
#불필요한 패키지 제거
#deploy 생성 후 권한 설정
RUN rm /usr/bin/curl

ENTRYPOINT java \
-Dspring.profiles.active=${APP_PHASE} \
-jar /app/app.jar
