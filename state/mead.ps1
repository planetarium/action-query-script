Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url
$arguments = @{
    address  = $Address
    currency = @{ ticker = "Mead"; decimalPlaces = 18; }
}

$field = ./scripts/generate-method.ps1 -Name "balance" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  stateQuery {
    $field {
      quantity
    }
  }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
