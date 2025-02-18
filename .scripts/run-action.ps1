Param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [hashtable]$Arguments,
    [switch]$Detailed,
    [decimal]$MaxGasPrice = 0.00001,
    [switch]$Confirm,
    [switch]$Watch
)

$oldErrorActionPreference = $ErrorActionPreference
$oldLogPath = $Global:LogPath
$ErrorActionPreference = 'Stop'
try {
    $planetVersion = Invoke-Expression "planet --version"
    if ($LASTEXITCODE) {
        throw "planet is not installed."
    }

    $scriptCategory = Split-Path (Split-Path $MyInvocation.ScriptName -Parent) -Leaf
    $scriptName = Split-Path -Path $MyInvocation.ScriptName -LeafBase
    $dateTime = $(Get-Date -Format "yyyy-MM-ddTHH-mm-ss")
    if (-not $Global:LogPath) {
        $filename = "$dateTime-$scriptCategory-$scriptName.md"
        $Global:LogPath = Join-Path ".logs" $filename
        New-Item -ItemType File -Path $Global:LogPath -Force | Out-Null
    }
    else {
        if ($Global:LogIndex -is [int]) {
            $index = "$Global:LogIndex. "
            $Global:LogIndex++
        }

        ./.scripts/write-log-text.ps1 "## $index$scriptCategory-$scriptName`n" -OutputToHost:$Detailed
        ./.scripts/write-log-text.ps1 "$dateTime`n" -OutputToHost:$Detailed
    }

    $url = ./.scripts/get-url.ps1
    $signer = ./.scripts/get-signer.ps1
    $keyId = ./.scripts/key-id.ps1 -Address $signer

    ./.scripts/write-log-text.ps1 "### Arguments`n" -OutputToHost:$Detailed
    ./.scripts/write-log-json.ps1 -HashTable @{
        Planet    = $planetVersion
        Url       = $url
        Signer    = $signer
        KeyId     = $keyId
        Name      = $Name
        Arguments = $Arguments
    } -OutputToHost:$Detailed

    $derived = ./.scripts/key-get.ps1 -KeyId $keyId -PassPhrase $PassPhrase
    $publicKey = $derived.PublicKey
    $address = $derived.Address

    ./.scripts/write-log-text.ps1 "### Key Information`n" -OutputToHost:$Detailed
    ./.scripts/write-log-json.ps1 -HashTable @{
        PublicKey = $publicKey
        Address   = $address
    } -OutputToHost:$Detailed

    ./.scripts/write-log-text.ps1 "### Action Query`n" -OutputToHost:$Detailed
    $plainValueParameters = @{
        Url       = $url
        Name      = $Name
        Arguments = $Arguments
        Detailed  = $Detailed
    }
    $plainValue = ./.scripts/action-query.ps1 @plainValueParameters

    ./.scripts/write-log-text.ps1 "### Nonce`n" -OutputToHost:$Detailed
    $nonceParameters = @{
        Url      = $url
        Address  = $address
        Detailed = $Detailed
    }
    $nonce = ./.scripts/nonce.ps1 @nonceParameters

    ./.scripts/write-log-text.ps1 "### Unsigned Transaction`n" -OutputToHost:$Detailed
    $unsignedTransactionParameters = @{
        Url         = $url
        PublicKey   = $publicKey
        MaxGasPrice = $MaxGasPrice
        Nonce       = $nonce
        PlainValue  = $plainValue
        Detailed    = $Detailed
    }
    $unsignedTransaction = ./.scripts/transaction-unsigned.ps1 @unsignedTransactionParameters

    ./.scripts/write-log-text.ps1 "### Signature`n" -OutputToHost:$Detailed
    $signatureParameters = @{
        KeyId               = $keyId
        UnsignedTransaction = $unsignedTransaction
        PassPhrase          = $PassPhrase
        Detailed            = $Detailed
    }
    $signature = ./.scripts/signature.ps1 @signatureParameters

    ./.scripts/write-log-text.ps1 "### Sign Transaction`n" -OutputToHost:$Detailed
    $signedTransactionParameters = @{
        Url                 = $url
        UnsignedTransaction = $unsignedTransaction
        Signature           = $signature
        Detailed            = $Detailed
    }
    $signedTransaction = ./.scripts/transaction-sign.ps1 @signedTransactionParameters

    $confirmation = $Confirm ? "yes" : (Read-Host "Do you want to stage the transaction? (yes/no)")
    if (($confirmation -eq "yes") -or ($confirmation -eq "y")) {
        ./.scripts/write-log-text.ps1 "### Stage Transaction`n" -OutputToHost:$Detailed
        $transactionIdParameters = @{
            Url               = $url
            SignedTransaction = $signedTransaction
            Detailed          = $Detailed
        }
        $transactionId = ./.scripts/transaction-stage.ps1 @transactionIdParameters
        
        if ($Watch) {
            ./.scripts/write-log-text.ps1 "### Transaction Result`n" -OutputToHost:$Detailed
            $transactionResultParameters = @{
                Url      = $url
                TxId     = $transactionId
                Detailed = $Detailed
            }
            ./.scripts/transaction-result.ps1 @transactionResultParameters
        }

        $transactionId
    }
    else {
        Write-Error "Transaction is not staged." -ErrorAction Continue
        Write-Error "Signed Transaction: $signedTransaction" -ErrorAction Continue
    }
}
finally {
    $ErrorActionPreference = $oldErrorActionPreference
    if (-not $oldLogPath) {
        Remove-Variable -Name LogPath -Scope Global
    }
}
