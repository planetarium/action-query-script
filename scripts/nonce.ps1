Param(
    [uri]$Url,
    [string]$Address
)

$field = ./scripts/generate-method.ps1 -Name "nextTxNonce" -Arguments @{ "address" = $Address }

$query = @"
query {
    $field
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query

[long]$result.nextTxNonce
