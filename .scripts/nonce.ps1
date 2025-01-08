Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [switch]$Quiet
)

$field = ./.scripts/generate-method.ps1 -Name "nextTxNonce" -Arguments @{ "address" = $Address } -IndentLevel 1 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  $field
}
"@

./.scripts/write-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./.scripts/invoke.ps1 -Url $Url -Query $query
./.scripts/write-json.ps1 -Object $result -Quiet:$Quiet
[long]$result.data.nextTxNonce
