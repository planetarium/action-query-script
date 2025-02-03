#!/bin/sh

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Build the Docker image with the tag 'action-query'
docker build -t action-query .

# Check if the Docker build command was successful
if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

# Run the Docker container and capture the container ID
container_id=$(docker run -d action-query:latest)

# Output the container ID
echo "Container ID: $container_id"

# Execute a command in the running container
docker exec -it $container_id /usr/bin/pwsh

# Stop and remove the container after the command execution
docker stop $container_id
docker rm $container_id

echo "Container $container_id has been removed."