<#
.SYNOPSIS
    Queries the state of an agent.

.PARAMETER Address
    The address of the agent to query. If not specified, the default signer address will be used.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\agent.ps1 -Address "0x1234567890abcdef"

    Queries the state of the agent with the specified address.

.EXAMPLE
    .\agent.ps1 -AsJson

    Queries the state of the default signer and returns the result as JSON.
#>

Param(
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid address format.")]
    [string]$Address,
    [ValidateScript(
        { $_ -ge 0 },
        ErrorMessage = "Block height must be greater than or equal to 0.")]
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
        PrettyPrint = $true
        IndentLevel = 1
    }
    $stateField = ./.scripts/generate-state-method.ps1 @stateParameters
    $stateField = $stateField.TrimStart()

    $name = "agent"
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
      address
      avatarStates {
        index
        address
      }
      gold
      monsterCollectionRound
      monsterCollectionLevel
      hasTradedItem
      crystal
      pledge {
        patronAddress
        approved
        mead
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
