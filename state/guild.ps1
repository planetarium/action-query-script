Param(
    [Parameter(Mandatory = $true)]
    [string]$AgentAddress,
    [string]$Url,
    [switch]$WhatIf
)

$Url = ./.scripts/resolve-url.ps1 -Url $Url
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
    $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
    ./.scripts/write-json.ps1 -Object $result -Raw -OutputType Output
}
