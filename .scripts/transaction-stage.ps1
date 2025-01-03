Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$SignedTransaction,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = "stageTransaction"
    Arguments   = @{
        payload = $SignedTransaction
    }
    IndentLevel = 1
    PrettyPrint = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters
$field = $field.TrimStart()

$query = @"
mutation {
  $field
}
"@

./.scripts/write-log-text.ps1 -Text "Query`n" -OutputToHost:$Detailed
./.scripts/write-log-graphql.ps1 -Query $query -OutputToHost:$Detailed
$result = ./.scripts/invoke-query.ps1 -Url $Url -Query $query
if ($result.errors) {
    ./.scripts/write-log-text.ps1 -Text "Error`n" -OutputToHost:$Detailed
    ./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
    throw $result.errors[0]
}

./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
$result.data.stageTransaction
