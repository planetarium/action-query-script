Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url
$arguments = @{
    address  = $Address
}

$field = ./scripts/generate-method.ps1 -Name "goldBalance" -Arguments $arguments -IndentLevel 1 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  $field
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
