Param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $true)]
    [string]$UnsignedTransaction,
    [Parameter(Mandatory = $true)]
    [string]$Signature,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = "signTransaction"
    Arguments   = @{
        unsignedTransaction = $UnsignedTransaction
        signature           = $Signature
    }
    IndentLevel = 1
    PrettyPrint = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters
$field = $field.TrimStart()

$query = @"
query {
  transaction{
    $field
  }
}
"@

./.scripts/write-log-text.ps1 -Text "Query`n" -OutputToHost:$Detailed
./.scripts/write-log-graphql.ps1 -Query $query -OutputToHost:$Detailed
$result = ./.scripts/invoke-query.ps1 -Url $Url -Query $query
./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
$result.data.transaction.signTransaction
