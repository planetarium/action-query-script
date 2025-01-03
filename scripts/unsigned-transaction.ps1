Param(
    [uri]$Url,
    [string]$PublicKey,
    [long]$MaxGasPrice,
    [long]$Nonce,
    [string]$PlainValue
)

$decimalPlaces = 18
$quntity = $MaxGasPrice
$arguments = @{
    "publicKey" = $PublicKey
    "maxGasPrice" = @{ quantity = $quntity; ticker = "Mead"; decimalPlaces = $decimalPlaces; }
    "nonce" = $Nonce
    "plainValue" = $PlainValue
}

$field = ./scripts/generate-method.ps1 -Name "unsignedTransaction" -Arguments $arguments -IndentLevel 2 -PrettyPrint

$query = @"
query {
    transaction{
$field
    }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
$result.transaction.unsignedTransaction
