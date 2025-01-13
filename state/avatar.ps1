<#
.SYNOPSIS
    Queries the state of an avatar.

.PARAMETER AvatarAddress
    The address of the avatar to query.

.PARAMETER Url
    The URL of the endpoint to query. If not provided, the default URL is used.

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
    [Parameter(Mandatory = $true)]
    [string]$AvatarAddress,
    [string]$Url,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Detailed
)

Push-Location $PSScriptRoot/..
try {
    $arguments = @{
        avatarAddress = $AvatarAddress
    }

    $field = ./.scripts/generate-method.ps1 -Name "avatar" -Arguments $arguments -IndentLevel 2 -PrettyPrint
    $field = $field.TrimStart()

    $query = @"
query {
  stateQuery {
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

    if ($WhatIf) {
        Write-Output $query
    }
    else {
        $Url = ./.scripts/resolve-url.ps1 -Url $Url
        $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
        if (!$Detailed) {
            $result = $result.data.stateQuery.avatar
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
