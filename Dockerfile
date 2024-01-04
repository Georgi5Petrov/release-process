# Depicting the Openjdk image from Docker Hub 
# (https://hub.docker.com/_/openjdk)
FROM openjdk:11

COPY mvn-project/target/java-validation-1.0.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
