<#
.SYNOPSIS
    Queries the MEAD balance of an address.

.PARAMETER Address
    The address to query the MEAD balance for. If not specified, the default signer address will be used.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\mead.ps1 -Address "0x1234567890abcdef"

    Queries the MEAD balance of the specified address.

.EXAMPLE
    .\mead.ps1 -AsJson

    Queries the MEAD balance of the default signer and returns the result as JSON.
#>

Param(
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid address format.")]
    [string]$Address,
    [long]$BlockHeight = -1,
    [string]$BlockHash,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $stateParameters = @{
        BlockHeight = $BlockHeight
        BlockHash   = $BlockHash
        IndentLevel = 1
        PrettyPrint = $true
    }
    $stateField = ./.scripts/generate-state-method.ps1 @stateParameters
    $stateField = $stateField.TrimStart()

    $name = "balance"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            address  = $Address ? $Address : (./.scripts/get-signer.ps1)
            currency = @{ ticker = "Mead"; decimalPlaces = 18; }
        }
        IndentLevel = 2
        PrettyPrint = $true
    }
    $field = ./.scripts/generate-method.ps1 @fieldParameters
    $field = $field.TrimStart()

    $query = @"
query {
  $stateField {
    $field {
      quantity
    }
  }
}
"@

    $parameters = @{
        Query      = $query
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", "stateQuery", $name, "quantity")
    }
    ./.scripts/run-state.ps1 @parameters
}
finally {
    Pop-Location
}
