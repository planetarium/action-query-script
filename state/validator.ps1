<#
.SYNOPSIS
    Queries the state of a validator.

.PARAMETER ValidatorAddress
    The address of the validator to query.

.PARAMETER Url
    The URL of the endpoint to query. If not provided, the default URL is used.

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
    [Parameter(Mandatory = $true)]
    [string]$ValidatorAddress,
    [string]$Url,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Detailed
)

Push-Location $PSScriptRoot/..
try {
    $arguments = @{
        validatorAddress = $ValidatorAddress
    }

    $field = ./.scripts/generate-method.ps1 -Name "validator" -Arguments $arguments -IndentLevel 2 -PrettyPrint
    $field = $field.TrimStart()

    $query = @"
query {
  stateQuery {
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

    if ($WhatIf) {
        Write-Output $query
    }
    else {
        $Url = ./.scripts/resolve-url.ps1 -Url $Url
        $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
        if (!$Detailed) {
            $result = $result.data.stateQuery.validator
        }
        
        if ($AsJson) {
            ./.scripts/write-json.ps1 -Object $result -Raw -OutputType Output
        }
        else {
            ./.scripts/write-hashtable.ps1 $result
        }
    }
}
finally {
    Pop-Location
}
