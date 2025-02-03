#!/bin/sh

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Build the Docker image with the tag 'action-query'
docker build -t action-query .
