Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [hashtable]$Arguments,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = $Name
    Arguments   = $Arguments
    IndentLevel = 2
    PrettyPrint = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters
$field = $field.TrimStart()

$query = @"
query {
  actionQuery {
    $field
  }
}
"@

./.scripts/write-log-text.ps1 -Text "Query`n" -OutputToHost:$Detailed
./.scripts/write-log-graphql.ps1 -Query $query -OutputToHost:$Detailed
$result = ./.scripts/invoke-query.ps1 -Url $Url -Query $query
./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
$result.data.actionQuery.$Name
