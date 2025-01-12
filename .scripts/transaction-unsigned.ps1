Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$PublicKey,
    [Parameter(Mandatory = $true)]
    [long]$MaxGasPrice,
    [Parameter(Mandatory = $true)]
    [long]$Nonce,
    [Parameter(Mandatory = $true)]
    [string]$PlainValue,
    [switch]$Quiet
)

$decimalPlaces = 18
$quntity = $MaxGasPrice
$arguments = @{
    publicKey   = $PublicKey
    maxGasPrice = @{ quantity = $quntity; ticker = "Mead"; decimalPlaces = $decimalPlaces; }
    nonce       = $Nonce
    plainValue  = $PlainValue
}

$field = ./.scripts/generate-method.ps1 -Name "unsignedTransaction" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  transaction{
    $field
  }
}
"@

./.scripts/write-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./.scripts/invoke.ps1 -Url $Url -Query $query
./.scripts/write-json.ps1 -Object $result -Quiet:$Quiet
$result.data.transaction.unsignedTransaction
