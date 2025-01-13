<#
.SYNOPSIS
    Retrieves guild state information.

.DESCRIPTION
    This script queries the state of a guild using the provided agent address.

.PARAMETER AgentAddress
    The address of the agent in hexadecimal format (40 characters).

.PARAMETER Url
    The URL to send the query to.

.PARAMETER WhatIf
    If set, the query will be outputted instead of executed.

.PARAMETER AsJson
    If set, the result will be outputted in JSON format.

.PARAMETER Detailed
    If set, the detailed result will be returned.

.EXAMPLE
    .\guild.ps1 -AgentAddress "0x1234567890abcdef1234567890abcdef12345678" -Url "http://example.com/graphql"
#>
Param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("(?:0x)?[0-9a-fA-F]{40}")]
    [string]$AgentAddress,
    [string]$Url,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Detailed
)

Push-Location $PSScriptRoot/..
try {
    $arguments = @{
        agentAddress = $AgentAddress
    }

    $field = ./.scripts/generate-method.ps1 -Name "guild" -Arguments $arguments -IndentLevel 2 -PrettyPrint
    $field = $field.TrimStart()

    $query = @"
query {
  stateQuery {
    $field {
      address
      validatorAddress
      guildMasterAddress
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
            $result = $result.data.stateQuery.guild
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
