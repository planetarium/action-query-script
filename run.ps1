[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Address", Position = 0)]
    [string]$Address,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [hashtable]$Arguments,
    [Parameter(Mandatory = $true, HelpMessage = "The passphrase to get the private key from the planet.")]
    [AllowNull()]
    [AllowEmptyString()]
    [string]$PassPhrase,
    [string]$Url,
    [switch]$Quiet,
    [long]$MaxGasPrice = 1,
    [switch]$Confirm,
    [switch]$Watch
)

$oldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

try {
    if ($null -eq $PassPhrase) {
        $PassPhrase = Read-Host "Enter the passphrase to get the private key from the planet." -AsSecureString
    }
    elseif ($PassPhrase -eq "") {
        $PassPhrase = New-Object -TypeName System.Security.SecureString
    }
    else {
        $PassPhrase = ConvertTo-SecureString -String $PassPhrase -AsPlainText -Force
    }

    $planetVersion = Invoke-Expression "planet --version"
    if ($LASTEXITCODE) {
        throw "planet is not installed."
    }

    if (!$Url) {
        if ($env:ACTION_QUERY_URL) {
            $Url = $env:ACTION_QUERY_URL
        }
        else {
            throw "The URL for the action query is not specified. Please set the -Url parameter or the ACTION_QUERY_URL environment variable."
        }
    }

    if (!$Quiet) {
        Write-Host "## Arguments`n"
        ./scripts/write-host-json.ps1 -HashTable @{
            Planet    = $planetVersion
            Url       = $Url
            KeyId     = $KeyId
            Name      = $Name
            Arguments = $Arguments
        }
    }

    if (!$KeyId) {
        $KeyId = ./scripts/key-id.ps1 -Address $Address
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
    $plainValue = ./scripts/action-query.ps1 -Url $Url -Name $Name -Arguments $Arguments -Quiet:$Quiet

    ./scripts/write-host-title.ps1 "## Nonce`n" -Quiet:$Quiet
    $nonce = ./scripts/nonce.ps1 -Url $Url -Address $address -Quiet:$Quiet

    ./scripts/write-host-title.ps1 "## Unsigned Transaction`n" -Quiet:$Quiet
    $unsignedTransaction = ./scripts/transaction-unsigned.ps1 -Url $Url -PublicKey $publicKey -MaxGasPrice $MaxGasPrice -Nonce $nonce -PlainValue $plainValue -Quiet:$Quiet

    ./scripts/write-host-title.ps1 "## Signature`n" -Quiet:$Quiet
    $signature = ./scripts/signature.ps1 -KeyId $keyId -UnsignedTransaction $unsignedTransaction -PassPhrase $PassPhrase -Quiet:$Quiet

    ./scripts/write-host-title.ps1 "## Sign Transaction`n" -Quiet:$Quiet
    $signedTransaction = ./scripts/transaction-sign.ps1 -Url $Url -UnsignedTransaction $unsignedTransaction -Signature $signature -Quiet:$Quiet

    $confirmation = $Confirm ? "yes" : (Read-Host "Do you want to stage the transaction? (yes/no)")
    if (($confirmation -eq "yes") -or ($confirmation -eq "y")) {
        ./scripts/write-host-title.ps1 "## Stage Transaction`n" -Quiet:$Quiet
        $transactionId = ./scripts/transaction-stage.ps1 -Url $Url -SignedTransaction $signedTransaction -Quiet:$Quiet
        
        if ($Watch) {
            ./scripts/write-host-title.ps1 "## Transaction Result`n" -Quiet:$Quiet
            ./scripts/transaction-result.ps1 -Url $Url -TxId $transactionId -Quiet:$Quiet
        }
    }
    else {
        Write-Error "Transaction is not staged." -ErrorAction Continue
        Write-Error "Signed Transaction: $signedTransaction" -ErrorAction Continue
    }
}
finally {
    $ErrorActionPreference = $oldErrorActionPreference
}
