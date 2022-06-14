# the first stage of our build will use a maven 3.8.4 parent image
FROM maven:3.8.4-jdk-17 AS MAVEN_BUILD

# copy the pom and src code to the container
COPY ./ ./

# package our application code
RUN mvn clean package

# the second stage of our build will use open jdk 17 on alpine 3.9
FROM openjdk:17.0.1-jdk-slim

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=MAVEN_BUILD /target/rest-service-0.0.1-SNAPSHOT.jar /demo.jar

# set the startup command to execute the jar
CMD ["java", "-jar", "/demo.jar"]