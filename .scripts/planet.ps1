try {
    Get-Command dotnet -ErrorAction SilentlyContinue | Out-Null
}
catch {
    $dotnetNotFoundMessage = @(
        "'.NET SDK 6.0 is not installed. Please install it "
        "from https://dotnet.microsoft.com/download/dotnet/6.0'.")
    throw $dotnetNotFoundMessage
}

$sdkVersions = & dotnet --list-sdks

if (-not ($sdkVersions -match "^6\.0\..*")) {
    $dotnetNotFoundMessage = @(
        "'.NET SDK 6.0 is not installed. Please install it "
        "from https://dotnet.microsoft.com/download/dotnet/6.0'.")
    throw $dotnetNotFoundMessage
}

try {
    if ($IsMacOS -or $IsLinux) {
        $path = Resolve-Path ~/.dotnet/tools/planet -ErrorAction Stop
        $path.Path
    }
    elseif ($IsWindows) {
        $path = Resolve-Path "$env:USERPROFILE\.dotnet\tools\planet.exe" -ErrorAction Stop
        $path.Path
    }
    else {
        throw "Unsupported platform."
    }
}
catch {
    $planetNotFoundMessage = @(
        "'planet' is not installed. You can install it using"
        "'dotnet tool install --global Libplanet.Tools --version 5.1.2'.")
    throw $planetNotFoundMessage
}
