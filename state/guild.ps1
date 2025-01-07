Param(
    [Parameter(Mandatory = $true)]
    [string]$AgentAddress,
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url
$arguments = @{
  "agentAddress" = $AgentAddress
}

$field = ./scripts/generate-method.ps1 -Name "guild" -Arguments $arguments -IndentLevel 2 -PrettyPrint
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

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
