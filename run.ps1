Param( 
    [string]$Url,
    [string]$PrivateKey,
    [string]$ActionQueryName,
    [hashtable]$ActionQueryArguments
)

$dotnetVersion = Invoke-Expression "dotnet --version"
if ($LASTEXITCODE) {
    throw "dotnet is not installed."
}

$planetVersion = Invoke-Expression "planet --version"
if ($LASTEXITCODE) {
    throw "planet is not installed."
}

Write-Host "Dotnet: $dotnetVersion"
Write-Host "Planet: $planetVersion"

$derived = ./scripts/key-derive.ps1 -PrivateKey $privateKey
$signerPublicKey = $derived.PublicKey
$signer = $derived.Address

Write-Host "Action Query Name: $actionQueryName"
Write-Host "Action Query Arguments: $actionQueryArguments"

$keyId = ./scripts/key-id.ps1 -Address $signer
Write-Host "Key ID: $keyId"
$plainValue = ./scripts/action-query.ps1 -Url $url -Name $actionQueryName -Arguments $actionQueryArguments
Write-Host "Plain Value: $plainValue"
$nonce = ./scripts/nonce.ps1 -Url $url -Address $signer
Write-Host "Nonce: $nonce"
$unsignedTransaction = ./scripts/unsigned-transaction.ps1 -Url $url -PublicKey $signerPublicKey -MaxGasPrice 1 -Nonce $nonce -PlainValue $plainValue
Write-Host "Unsigned Transaction: $unsignedTransaction"
$signature = ./scripts/signature.ps1 -KeyId $keyId -UnsignedTransaction $unsignedTransaction
Write-Host "Signature: $signature"
$signedTransaction = ./scripts/sign-transaction.ps1 -Url $url -UnsignedTransaction $unsignedTransaction -Signature $signature
Write-Host "Signed Transaction: $signedTransaction"
$transactionId = ./scripts/stage-transaction.ps1 -Url $url -SignedTransaction $signedTransaction
Write-Host "Transaction ID: $transactionId"
