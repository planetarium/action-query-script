Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [hashtable]$Arguments,
    [switch]$Quiet
)

$field = ./.scripts/generate-method.ps1 -Name $Name -Arguments $Arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  actionQuery {
    $field
  }
}
"@

./.scripts/write-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./.scripts/invoke.ps1 -Url $Url -Query $query
./.scripts/write-json.ps1 -Object $result -Quiet:$Quiet
$result.data.actionQuery.$Name
