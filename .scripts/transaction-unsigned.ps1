Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$PublicKey,
    [Parameter(Mandatory = $true)]
    # [ValidatePattern('^\d+(\.\d+)?$')]
    [int]$MaxGasPrice,
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
$result.data.transaction.unsignedTransaction
