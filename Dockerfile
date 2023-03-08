# Use a Java runtime as a base image
FROM openjdk:8-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the source code to the container
COPY . .

# Build the application into a .war file
RUN ./mvnw package

# Expose port 8080
EXPOSE 8080

# Start the application
CMD ["java", "-jar", "target/helloworld.war"]
