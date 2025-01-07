Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url
$arguments = @{
  "address" = $Address
}

$field = ./scripts/generate-method.ps1 -Name "delegator" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  stateQuery {
    $field {
      lastDistributeHeight
      share
      fav {
        currency
        quantity
      }
    }
  }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
