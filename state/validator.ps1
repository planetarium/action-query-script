<#
.SYNOPSIS
    Queries the state of a validator.

.PARAMETER ValidatorAddress
    The address of the validator to query.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\validator.ps1 -ValidatorAddress "0x1234567890abcdef"

    Queries the state of the validator with the specified address.

.EXAMPLE
    .\validator.ps1 -ValidatorAddress "0x1234567890abcdef" -AsJson

    Queries the state of the validator with the specified address and returns the result as JSON.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid validator address format.")]
    [string]$ValidatorAddress,
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
        PrettyPrint = $PrettyPrint
        IndentLevel = 1
    }
    $stateField = ./.scripts/generate-state-method.ps1 @stateParameters
    $stateField = $stateField.TrimStart()

    $name = "validator"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            validatorAddress = $ValidatorAddress
        }
        IndentLevel = 2
        PrettyPrint = $PrettyPrint
    }
    $field = ./.scripts/generate-method.ps1 @fieldParameters
    $field = $field.TrimStart()

    $query = @"
query {
  $stateField {
    $field {
      power
      isActive
      totalShares
      jailed
      jailedUntil
      tombstoned
      totalDelegated { 
        currency
        quantity
      }
    }
  }
}
"@

    $parameters = @{
        Query      = $query
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", "stateQuery", $name)
    }
    ./.scripts/run-state.ps1 @parameters
}
finally {
    Pop-Location
}
