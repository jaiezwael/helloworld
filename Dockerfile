# Build the Docker image
docker build -t waelj17/helloworld:2.0 .

# Push the Docker image to Docker Hub
docker login -u waelj17 -p LeoMessi1987
docker push waelj17/helloworld:2.0

