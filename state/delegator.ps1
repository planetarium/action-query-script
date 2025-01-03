<#
.SYNOPSIS
    Queries the state of a delegator.

.PARAMETER Address
    The address of the delegator to query. If not specified, the default signer address will be used.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\delegator.ps1 -Address "0x1234567890abcdef"

    Queries the state of the delegator with the specified address.

.EXAMPLE
    .\delegator.ps1 -AsJson

    Queries the state of the default signer and returns the result as JSON.
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

    $name = "delegator"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            address = $Address ? $Address : (./.scripts/get-signer.ps1)
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
      guildDelegator {
        lastDistributeHeight
        share
        fav {
          currency
          quantity
        }
      }
      validatorDelegator {
        lastDistributeHeight
        share
        fav {
          currency
          quantity
        }
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
