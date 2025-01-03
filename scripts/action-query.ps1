Param(
    [uri]$Url,
    [string]$Name,
    [hashtable]$Arguments
)

$field = ./scripts/generate-method.ps1 -Name $Name -Arguments $Arguments -IndentLevel 2 -PrettyPrint

$query = @"
query {
    actionQuery {
$field
    }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
$result.actionQuery.$Name
