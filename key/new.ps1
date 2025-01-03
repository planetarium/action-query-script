<#
.SYNOPSIS
    Generates new keys.

.PARAMETER Count
    The number of keys to generate. Default is 1.

.PARAMETER AsJson
    If specified, returns the keys as JSON instead of objects.

.EXAMPLE
    .\new.ps1 -Count 5

    Generates 5 new keys and returns them as JSON.

.EXAMPLE
    .\new.ps1 -Count 3 -AsJson

    Generates 3 new keys and returns them as JSON.
#>
Param(
    [ValidateScript({ $_ -gt 0 })]
    [int]$Count = 1,
    [switch]$AsJson,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $planetPath = ./.scripts/planet.ps1
    $keys = @()

    for ($i = 0; $i -lt $Count; $i++) {
        $line = & $planetPath key generate --public-key 2>$null
        if ($LASTEXITCODE) {
            throw "Failed to identify key"
        }

        $items = $line -split " "

        $keys += [PSCustomObject]@{
            PrivateKey = $items[0]
            PublicKey  = $items[2]
            Address    = $items[1]
        }
    }

    if ($AsJson) {
        $json = $keys | ConvertTo-Json -Depth 10 -AsArray
        if ($Colorize -and (Get-Command "pygmentize")) {
            Write-Output ($json | pygmentize -l json -f terminal256 -O style=monokai)
        }
        else {
            Write-Output $json
        }
    }
    else {
        $keys
    }
}
finally {
    Pop-Location
}
