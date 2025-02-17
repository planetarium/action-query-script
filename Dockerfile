# Use the official .NET SDK image as a parent image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Update
RUN apt update

# Install Phython3
RUN apt install python3-pip -y

# Install Pygments to highlight the code
RUN pip install Pygments

# Install PowerShell 7.4.*
RUN dotnet tool install --global PowerShell --version 7.2.*

# Install Libplanet.Tools 5.1.2
RUN dotnet tool install --global Libplanet.Tools --version 5.1.2

# Set the PATH environment variable
ENV PATH="$PATH:/root/.dotnet/tools"

# Set the working directory
WORKDIR /workspaces/action-query-script

# Copy the scripts into the container
COPY action /workspaces/action-query-script/action
COPY mutation /workspaces/action-query-script/mutation
COPY key /workspaces/action-query-script/key
COPY node /workspaces/action-query-script/node
COPY state /workspaces/action-query-script/state
COPY .scripts /workspaces/action-query-script/.scripts
COPY signer.ps1 /workspaces/action-query-script
COPY url.ps1 /workspaces/action-query-script
COPY help.ps1 /workspaces/action-query-script
COPY test-mutation.ps1 /workspaces/action-query-script

# Copy the PowerShell profile script into the container
COPY .scripts/profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Keep the container running
CMD ["pwsh", "-NoProfile", "-Command", "while ($true) { Start-Sleep -Seconds 3600 }"]
