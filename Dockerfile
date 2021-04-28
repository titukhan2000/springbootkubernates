#FROM gradle:4.7.0-jdk8-alpine AS build
FROM gradle:6.8.3-jdk11-openj9
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN ls -ltr

RUN chmod 777 gradlew
RUN ./gradlew clean build sonarqube --no-daemon 

#FROM adoptopenjdk:11-jre-openj9
FROM openjdk:8-jre-slim

EXPOSE 8080

RUN mkdir /app
WORKDIR /home/gradle/src
RUN ls -ltr

COPY --from=build /home/gradle/src/build/libs/kubernatesboot-0.0.1-SNAPSHOT.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

