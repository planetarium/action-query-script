Param(
    [uri]$Url,
    [string]$SignedTransaction
)

$arguments = @{
    "payload" = $SignedTransaction
}

$field = ./scripts/generate-method.ps1 -Name "stageTransaction" -Arguments $arguments -IndentLevel 1 -PrettyPrint

$query = @"
mutation {
$field
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
$result.stageTransaction
