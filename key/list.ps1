<#
.SYNOPSIS
    Lists keys and their addresses.

.PARAMETER Address
    The address to filter the keys by. If not provided, all keys are listed.

.PARAMETER AsJson
    If specified, returns the keys as JSON instead of objects.

.EXAMPLE
    .\list.ps1

    Lists all keys and their addresses.

.EXAMPLE
    .\list.ps1 -Address "0x1234567890abcdef"

    Lists the key with the specified address.

.EXAMPLE
    .\list.ps1 -AsJson

    Lists all keys and their addresses as JSON.
#>
Param(
    [string]$Address,
    [switch]$AsJson,
    [switch]$Colorize
)

if ($Colorize) {
    if (!(Get-Command "pygmentize")) {
        Write-Warning "The -Colorize parameter requires the 'pygmentize' command to be installed."
        $Colorize = $false
    }

    if (-not $AsJson) {
        Write-Warning "The -Colorize parameter is only supported when -AsJson or -WhatIf is set."
        $Colorize = $false
    }
}

Push-Location $PSScriptRoot/..
try {
    $planetPath = ./.scripts/planet.ps1
    $lines = & $planetPath key 2>$null
    if ($LASTEXITCODE) {
        throw "Failed to identify key"
    }

    if ($Address -and !$Address.StartsWith("0x")) {
        $Address = "0x$Address"
    }

    $idByAddress = @{}
    foreach ($line in $lines) {
        $items = $line -split " "
        if (!$Address -or ($items[1] -eq $Address)) {
            $idByAddress[$items[1]] = $items[0]
        }
    }

    if ($idByAddress.Count -eq 0) {
        if ($Address) {
            throw "No key found."
        }
        else {
            Write-Host "There is no registered key."
        }
    }

    $result = @()
    foreach ($key in $idByAddress.Keys) {
        $result += [PSCustomObject]@{
            KeyId   = $idByAddress[$key]
            Address = $key
        }
    }

    if ($AsJson) {
        $json = $result | ConvertTo-Json -Depth 10 -AsArray
        if ($Colorize -and (Get-Command "pygmentize")) {
            Write-Output ($json | pygmentize -l json -f terminal256 -O style=monokai)
        }
        else {
            Write-Output $json
        }
    }
    else {
        $result
    }
}
finally {
    Pop-Location
}
