Param(
    [string]$Url,
    [string]$UnsignedTransaction,
    [string]$Signature
)

$arguments = @{
    "unsignedTransaction" = $UnsignedTransaction
    "signature" = $Signature
}

$field = ./scripts/generate-method.ps1 -Name "signTransaction" -Arguments $arguments -IndentLevel 2 -PrettyPrint

$query = @"
query {
    transaction{
$field
    }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
$result.transaction.signTransaction
