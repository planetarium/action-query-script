Param( 
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $true)]
    [string]$KeyId,
    [Parameter(Mandatory = $true)]
    [string]$ActionQueryName,
    [hashtable]$ActionQueryArguments,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Quiet,
    [long]$MaxGasPrice = 1
)

$planetVersion = Invoke-Expression "planet --version"
if ($LASTEXITCODE) {
    throw "planet is not installed."
}

if (!$Quiet) {
    Write-Host "## Arguments`n"
    ./scripts/write-host-json.ps1 -HashTable @{
        Planet               = $planetVersion
        Url                  = $Url
        KeyId                = $KeyId
        ActionQueryName      = $ActionQueryName
        ActionQueryArguments = $ActionQueryArguments
    }
}

$derived = ./scripts/key-get.ps1 -KeyId $KeyId -PassPhrase $PassPhrase
$publicKey = $derived.PublicKey
$address = $derived.Address

if (!$Quiet) {
    Write-Host "## Key Information`n"
    ./scripts/write-host-json.ps1 -HashTable @{
        PublicKey = $publicKey
        Address   = $address
    }
}

./scripts/write-host-title.ps1 "## Action Query`n" -Quiet:$Quiet
$plainValue = ./scripts/action-query.ps1 -Url $url -Name $actionQueryName -Arguments $actionQueryArguments -Quiet:$Quiet

./scripts/write-host-title.ps1 "## Nonce`n" -Quiet:$Quiet
$nonce = ./scripts/nonce.ps1 -Url $url -Address $address -Quiet:$Quiet

./scripts/write-host-title.ps1 "## Unsigned Transaction`n" -Quiet:$Quiet
$unsignedTransaction = ./scripts/unsigned-transaction.ps1 -Url $url -PublicKey $publicKey -MaxGasPrice $MaxGasPrice -Nonce $nonce -PlainValue $plainValue -Quiet:$Quiet

./scripts/write-host-title.ps1 "## Signature`n" -Quiet:$Quiet
$signature = ./scripts/signature.ps1 -KeyId $keyId -UnsignedTransaction $unsignedTransaction -PassPhrase $PassPhrase -Quiet:$Quiet

./scripts/write-host-title.ps1 "## Sign Transaction`n" -Quiet:$Quiet
$signedTransaction = ./scripts/sign-transaction.ps1 -Url $url -UnsignedTransaction $unsignedTransaction -Signature $signature -Quiet:$Quiet

./scripts/write-host-title.ps1 "## Stage Transaction`n" -Quiet:$Quiet
$transactionId = ./scripts/stage-transaction.ps1 -Url $url -SignedTransaction $signedTransaction -Quiet:$Quiet

$transactionId
