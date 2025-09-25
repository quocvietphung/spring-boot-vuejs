# Docker multi-stage build

# 1. Building the App with Maven
FROM maven:3.9.9-eclipse-temurin-21 AS builder

ADD . /springbootvuejs
WORKDIR /springbootvuejs

# Just echo so we can see, if everything is there :)
RUN ls -l

# Run Maven build
RUN mvn clean install -DskipTests


# Just using the build artifact and then removing the build-container
FROM eclipse-temurin:21-jdk

MAINTAINER Jonas Hecht

VOLUME /tmp

# Add Spring Boot app.jar to Container
COPY --from=builder "/springbootvuejs/backend/target/backend-0.0.1-SNAPSHOT.jar" app.jar

ENV JAVA_OPTS=""

# Fire up our Spring Boot app by default
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]