<#
.SYNOPSIS
    Queries the state of an avatar.

.PARAMETER Address
    The address to query.

.PARAMETER AvatarIndex
    The index of the avatar to query.

.PARAMETER AvatarAddress
    The address of the avatar to query.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\avatar.ps1 -AvatarAddress "0x1234567890abcdef"

    Queries the state of the avatar with the specified address.

.EXAMPLE
    .\avatar.ps1 -AvatarAddress "0x1234567890abcdef" -AsJson

    Queries the state of the avatar with the specified address and returns the result as JSON.
#>

Param(
    [Parameter(ParameterSetName = "AddressSet", Position = 0)]
    [string]$Address = "",
    [Parameter(ParameterSetName = "AddressSet", Position = 1)]
    [int]$AvatarIndex,
    [Parameter(Mandatory = $true, ParameterSetName = "AvatarAddressSet")]
    [string]$AvatarAddress,
    [long]$BlockHeight = -1,
    [string]$BlockHash,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    if ($PSCmdlet.ParameterSetName -eq "AddressSet") {
        if (-not $Address) {
            $Address = ./.scripts/get-signer.ps1
        }

        $agentInfo = ./state/agent.ps1 -Address $Address
        $AvatarAddress = $agentInfo.avatarStates[$AvatarIndex].address
    }

    $stateParameters = @{
        BlockHeight = $BlockHeight
        BlockHash   = $BlockHash
        PrettyPrint = $true
        IndentLevel = 1
    }
    $stateField = ./.scripts/generate-state-method.ps1 @stateParameters
    $stateField = $stateField.TrimStart()

    $name = "avatar"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            avatarAddress = $AvatarAddress
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
      blockIndex
      characterId
      dailyRewardReceivedIndex
      agentAddress
      index
      updatedAt
      name
      exp
      level
      actionPoint
      ear
      hair
      lens
      tail
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
