Param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $true)]
    [string]$UnsignedTransaction,
    [Parameter(Mandatory = $true)]
    [string]$Signature,
    [switch]$Quiet
)

$arguments = @{
    "unsignedTransaction" = $UnsignedTransaction
    "signature"           = $Signature
}

$field = ./scripts/generate-method.ps1 -Name "signTransaction" -Arguments $arguments -IndentLevel 2 -PrettyPrint

$query = @"
query {
  transaction{
$field
  }
}
"@

./scripts/write-host-graphql.ps1 -Query $query -Quiet:$Quiet
$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result -Quiet:$Quiet
$result.data.transaction.signTransaction