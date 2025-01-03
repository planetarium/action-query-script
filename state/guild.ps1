<#
.SYNOPSIS
    Retrieves guild state information.

.DESCRIPTION
    This script queries the state of a guild using the provided agent address. If no agent address is provided, it will use the default signer.

.PARAMETER AgentAddress
    The address of the agent in hexadecimal format (40 characters). If not provided, the default signer will be used.

.PARAMETER WhatIf
    If set, the query will be outputted instead of executed.

.PARAMETER AsJson
    If set, the result will be outputted in JSON format.

.PARAMETER Detailed
    If set, the detailed result will be returned.

.EXAMPLE
    .\guild.ps1 -AgentAddress "0x1234567890abcdef1234567890abcdef12345678"
#>
Param(
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid agent address format.")]
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

    $name = "guild"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            agentAddress = $Address ? $Address : (./.scripts/get-signer.ps1)
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
      validatorAddress
      guildMasterAddress
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
