Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = "nextTxNonce"
    Arguments   = @{
        "address" = $Address
    }
    IndentLevel = 1
    PrettyPrint = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters
$field = $field.TrimStart()

$query = @"
query {
  $field
}
"@

./.scripts/write-log-text.ps1 -Text "Query`n" -OutputToHost:$Detailed
./.scripts/write-log-graphql.ps1 -Query $query -OutputToHost:$Detailed
$result = ./.scripts/invoke-query.ps1 -Url $Url -Query $query
./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
[long]$result.data.nextTxNonce
