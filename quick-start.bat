@echo off

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed. Please install Docker from: https://docs.docker.com/get-docker/
    exit /b 1
)

REM Build the Docker image
docker build -t action-query .
REM Check if the Docker build command was successful
if %errorlevel% neq 0 (
    echo Docker build failed. Exiting.
    exit /b 1
)

REM Run the Docker container and capture the container ID
docker run -d action-query:latest > .container-id.txt
set /p container_id=<.container-id.txt
del .container-id.txt

REM Output the container ID
echo Container ID: %container_id%

REM Execute a command in the running container
docker exec -it %container_id% /usr/bin/pwsh

REM Stop and remove the container after the command execution
docker stop %container_id%
docker rm %container_id%

echo Container %container_id% has been removed.
