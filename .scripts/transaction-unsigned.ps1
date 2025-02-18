Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$PublicKey,
    [Parameter(Mandatory = $true)]
    [decimal]$MaxGasPrice,
    [Parameter(Mandatory = $true)]
    [long]$Nonce,
    [Parameter(Mandatory = $true)]
    [string]$PlainValue,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = "unsignedTransaction"
    Arguments   = @{
        publicKey   = $PublicKey
        maxGasPrice = @{ 
            quantity      = $MaxGasPrice
            ticker        = "Mead"
            decimalPlaces = 18
        }
        nonce       = $Nonce
        plainValue  = $PlainValue
    }
    IndentLevel = 2
    PrettyPrint = $true
    TrimStart   = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters

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
if ($result.errors) {
    ./.scripts/write-log-text.ps1 -Text "Error`n" -OutputToHost:$Detailed
    ./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
    throw $result.errors[0]
}

./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
$result.data.transaction.unsignedTransaction
