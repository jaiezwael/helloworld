# Use the official Java image as the base image
FROM openjdk:8-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Build the project using Maven
RUN ./mvnw clean package

# Copy the generated .war file to the Jelastic deployment directory
RUN cp target/*.war /opt/jelastic/repo/

# Cleanup the working directory
RUN rm -rf *

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]

