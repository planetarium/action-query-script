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
    [switch]$AsJson
)

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
        $result | ConvertTo-Json -Depth 10 -AsArray
    }
    else {
        $result
    }
}
finally {
    Pop-Location
}
