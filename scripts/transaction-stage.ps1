Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$SignedTransaction,
    [switch]$Quiet
)

$arguments = @{
    payload = $SignedTransaction
}

$field = ./scripts/generate-method.ps1 -Name "stageTransaction" -Arguments $arguments -IndentLevel 1 -PrettyPrint
$field = $field.TrimStart()

$query = @"
mutation {
  $field
}
"@

./scripts/write-host-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result -Quiet:$Quiet
$result.data.stageTransaction
