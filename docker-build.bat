@echo off

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed. Please install Docker and try again.
    exit /b 1
)

REM Build the Docker image
docker build -t action-query .
