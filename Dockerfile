# Depicting the Openjdk image from Docker Hub 
# (https://hub.docker.com/_/openjdk)
FROM openjdk:8-jdk-alpine

# The volume point to /tmp because it is where the Spring Boot application 
# creates working directories for Tomcat by default.
VOLUME /tmp

# The argument for the JAR_FILE could be passed during the Docker build
ARG JAR_FILE=mvn-project/target/java-validation-1.0.0-SNAPSHOT.jar

# "layered JAR" structure
COPY ${JAR_FILE} app.jar 

# Add the application's JAR file to the environment
ADD target/*.jar app.jar 

# Run the JAR file 
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]
