Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [switch]$Quiet
)

$field = ./scripts/generate-method.ps1 -Name "nextTxNonce" -Arguments @{ "address" = $Address }

$query = @"
query {
    $field
}
"@

./scripts/write-host-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result -Quiet:$Quiet
[long]$result.data.nextTxNonce
