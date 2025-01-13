try {
    Get-Command dotnet -ErrorAction SilentlyContinue | Out-Null
}
catch {
    throw ".NET SDK 6.0 is not installed. Please install it from https://dotnet.microsoft.com/download/dotnet/6.0"
}

$sdkVersions = & dotnet --list-sdks

if (-not ($sdkVersions -match "^6\.0\..*")) {
    throw ".NET SDK 6.0 is not installed. Please install it from https://dotnet.microsoft.com/download/dotnet/6.0"
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
    throw "'planet' is not installed. You can install it using 'dotnet tool install --global Libplanet.Tools --version 5.1.2'."
}
