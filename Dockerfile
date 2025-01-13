# Use the official .NET SDK image as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Install PowerShell 7.4.*
RUN dotnet tool install --global PowerShell --version 7.2.*

# Install Libplanet.Tools 5.1.2
RUN dotnet tool install --global Libplanet.Tools --version 5.1.2

# Set the PATH environment variable
ENV PATH="$PATH:/root/.dotnet/tools"

# Set the default shell to PowerShell
SHELL ["pwsh", "-Command"]

# Set the working directory
WORKDIR /scripts

# Copy the scripts into the container
COPY action /scripts/action
COPY key /scripts/key
COPY node /scripts/node
COPY state /scripts/state
COPY .scripts /scripts/.scripts

# Keep the container running
CMD ["pwsh", "-Command", "while ($true) { Start-Sleep -Seconds 3600 }"]
