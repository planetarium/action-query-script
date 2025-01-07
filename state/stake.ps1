Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url
$arguments = @{
  "address" = $Address
}

$field = ./scripts/generate-method.ps1 -Name "stakeState" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  stateQuery {
    $field {
      deposit
      startedBlockIndex
      receivedBlockIndex
      cancellableBlockIndex
      claimableBlockIndex
    }
  }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
